# frozen_string_literal: true
require 'rest-client'
require_relative '../../lib/simple_logger'

module CodeKata
  module Clients
    # A module for declaring all we need for the process, for requesting data from different sources, we can define
    # different client.
    # - headers: Url request header(like authorization key), optional
    # - parser: Parser class for parsing response data, should implement a class method of `parse`,
    #   string as input, JSON hash as output
    # - formater: Formater class, should inherit from BaseFormat
    # - output: Output class, should inherit from BaseOutput
    module RequestClient
      MAX_RETRIES = 3

      # Error for insufficient declaration
      NotDeclaredError = Class.new(StandardError)

      def initialize(method:, url:, params: {}, payload: {})
        @method = method
        @url = url
        @params = params
        @payload = payload
      end

      module ClassMethods

        def perform(method:, url:, params: {}, payload: {})
          validate_declaration!
          validate_params!(method, url)

          self.send(:new, method: method, url: url, params: params, payload: payload).send(:perform)
        end

        private

        # Declare headers for the request, optional
        # @param [hash] headers_hash
        def headers(headers_hash)
          @headers = headers_hash
        end

        # Declare parser class for parsing response string, required
        # @param [BaseParser] parser_class
        # @return [string] string ready for output
        def parser(parser_class)
          @parser = parser_class
        end

        # Declare formater class, required
        # @param [BaseFormater] formater_class
        def formater(formater_class)
          @formater = formater_class
        end

        # Declare output class, required
        # @param [BaseOutput] output_class
        def output(output_class)
          @output = output_class
        end

        # Validate all required class are declared.
        def validate_declaration!
          raise NotDeclaredError unless @parser && @output && @formater
        end

        def validate_params!(method, url)
          raise ArgumentError, 'method and url can not be nil' if !method || !url
        end
      end

      def self.included(m)
        m.private_class_method :new

        m.extend(ClassMethods)
        m.include(SimpleLogger)
      end

      def perform
        @retried_time = 0

        resp = begin
                 RestClient::Request.execute(**build_request_args)
               rescue RestClient::ExceptionWithResponse, StandardError => e
                 status = e.respond_to?(:http_code) ? e.http_code : nil

                 if should_retry?(status) && @retried_time < MAX_RETRIES - 1
                   log_retry(e)
                   retry
                 else
                   log_re_raise_error(e, status)
                 end
               end

        parse_response(resp.body)
      end

      private

      # @return [hash] arguments hash for RestClient request
      def build_request_args
        final_headers = self.class.instance_variable_get(:@headers) || {}
        final_headers.merge!({ params: @params }) unless @params.empty?
        args = { method: @method.to_sym, url: @url }
        args.merge!({ headers: final_headers }) unless final_headers.empty?
        args.merge!({ payload: @payload }) unless @payload.empty?

        args
      end

      # @param [string] response_body
      def parse_response(response_body)
        parser_class = self.class.instance_variable_get(:@parser)
        formater_class = self.class.instance_variable_get(:@formater)
        output_class = self.class.instance_variable_get(:@output)
        output_class.puts(formater_class.format(parser_class.parse(response_body)))
      end

      # When received these HTTP code, it's not beneficial for retrying. So just log and re-raise the error.
      # @param [integer] status HTTP code
      def should_retry?(status)
        ![300, 301, 304, 500].include?(status) && !(400..499).include?(status)
      end

      def log_retry(e)
        @retried_time += 1
        self.class.logger.info("Error while requesting #{@url}: #{e.message}. Retry number #{@retried_time}.")
      end

      def log_re_raise_error(exception, status = nil)
        error_message = "Requesting #{@url}. Error:#{status.to_s} #{exception.message}"
        self.class.logger.error(error_message)

        raise exception
      end
    end
  end
end