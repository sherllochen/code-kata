# frozen_string_literal: true
require 'logger'
require './lib/config'

module CodeKata
  module SimpleLogger
    LOG_PATH = 'logs/simple.log'
    LOG_SHIFT_SIZE = 10
    LOG_FILE_SIZE = 1024000

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def logger
        @logger ||= begin
                      # Logs are sent to both STDOUT and log file
                      logger_output = multi_logger_output
                      logger = Logger.new(logger_output, LOG_SHIFT_SIZE, LOG_FILE_SIZE)
                      logger.level = CodeKata::Config.instance.log_level || 'INFO'
                      logger
                    end
      end

      def multi_logger_output
        log_file = File.open(LOG_PATH, 'a')
        targets = [log_file, STDOUT]

        MultiIO.new(*targets)
      end

      class MultiIO
        def initialize(*targets)
          @targets = targets
        end

        def write(*args)
          @targets.each { |t| t.write(*args) }
        end

        def close
          @targets.each(&:close)
        end
      end

    end
  end
end
