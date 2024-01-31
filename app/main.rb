# frozen_string_literal: true
require 'net/http'
require 'uri'
require 'json'

module CodeKata
  # Entry for the application
  class Main
    class << self
      AMOUNT_TO_GENERATE = 5
      THREAD_AMOUNT = 2
      TOTAL_AMOUNT = 20
      URL_PREFIX = 'https://jsonplaceholder.typicode.com/todos/'

      def run
        begin
          url_queue = []
          requested_amount = 0
          last_id = 0
          while requested_amount < TOTAL_AMOUNT
            if url_queue.empty?
              generated_result = generate_urls(remaining_urls_to_request(requested_amount), last_id)
              url_queue.concat(generated_result[:urls])
              last_id = generated_result[:last_id]
            end

            to_request_urls = pop_urls(url_queue, THREAD_AMOUNT)
            execute_request(to_request_urls)
            # Remove urls from the sink
            url_queue.slice!(0, to_request_urls.length)
            requested_amount += to_request_urls.length
          end
        rescue Interrupt => e
          puts 'SEE YOU~'
        rescue StandardError => e
          puts "ERROR WHEN RUNNING APP. [message] #{e.message}, [backtrace] #{e.backtrace.join(',')}"
        end
      end

      private

      # @param [integer] amount the amount of TODOs to request
      # @param [integer] previous_id the last id of previous generated urls
      # @return [hash]
      def generate_urls(amount, previous_id)
        url_array = []
        amount.times do
          previous_id += 2
          url_array << "#{URL_PREFIX}#{previous_id}"
        end

        { urls: url_array, last_id: previous_id }
      end

      def remaining_urls_to_request(requested_amount)
        remaining = TOTAL_AMOUNT - requested_amount
        remaining < AMOUNT_TO_GENERATE ? remaining : AMOUNT_TO_GENERATE
      end

      # @param [array<string>] urls
      # @param [integer] amount
      # @return [array<string>] a url array
      def pop_urls(urls, amount)
        urls.first(amount)
      end

      # @param [array<string>] urls URL array
      def execute_request(urls)
        threads = []
        urls.each do |url|
          threads << Thread.new do
            if ENV['MOCK']
              # disable the real request for debugging.
              # TODO: should be removed later.
              puts url
            else
              res = ::Net::HTTP.get(URI(url))
              extract_and_output(res)
            end
          end
        end
        threads.each(&:join)
      end

      # @param [string] raw_data
      def extract_and_output(raw_data)
        parsed_hash = JSON.parse(raw_data)
        title = parsed_hash['title']
        completed = parsed_hash['completed']

        output(format_output(title, completed))
      end

      # @param [string] title
      # @param [string] completed
      # @return [string] formatted string ready for output
      def format_output(title, completed)
        "TITLE: #{title}, COMPLETED: #{completed}"
      end

      # @param [string] string string to be output
      def output(string)
        puts string
      end
    end
  end
end
