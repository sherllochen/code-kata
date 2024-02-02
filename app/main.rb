# frozen_string_literal: true

require 'concurrent'
require_relative './clients/simple_client'
require_relative '../lib/cli_handler'
require_relative '../lib/simple_logger'
require_relative './url_generators/incremental_id_url_generator'

module CodeKata
  # Entry for the application
  class Main
    include SimpleLogger

    class << self
      # @param [Array<string>] argv Arguments from command line
      def run(argv)
        total, thread_count = CLIHandler.parse(argv)

        begin
          url_queue = Queue.new
          generated_result = CodeKata::UrlGenerators::IncrementalIdUrlGenerator.new(total, 0).generate
          generated_result[:urls].each { |url| url_queue.push(url) }

          # A thread pool
          promises = []
          thread_count.times do
            promise = Concurrent::Promise.execute do
              url = url_queue.pop(true) rescue nil
              while url
                Clients::SimpleClient.perform(method: :get, url: url)
                url = url_queue.pop(true) rescue nil
              end
            end

            promises << promise
          end

          Concurrent::Promise.zip(*promises).value!
        rescue Interrupt => e
          logger.info('SEE YOU~')
        rescue StandardError => e
          logger.error("ERROR WHEN RUNNING APP. [message] #{e.message}, [backtrace] #{e.backtrace.join(',')}")
        end
      end
    end
  end
end
