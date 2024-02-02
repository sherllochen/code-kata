# frozen_string_literal: true
require './lib/config'

module CodeKata
  class CLIHandler
    DEFAULT_TOTAL = CodeKata::Config.instance.default_total
    DEFAULT_THREADS = CodeKata::Config.instance.default_threads
    HELP_COMMANDS = %w[-h --help].freeze
    USAGE_INSTRUCTION = <<~EOF
      Usage: bin/entry [total [threads]]
      total    The total amount of TODOs to request (default: #{DEFAULT_TOTAL})
      threads  The number of request threads to be run in parallel (default: #{DEFAULT_THREADS})
    EOF

    def self.parse(cli_argv)
      @cli_argv = cli_argv

      handle_help

      return parse_arguments
    end

    private

    def self.handle_help
      return unless (HELP_COMMANDS & @cli_argv).any?

      puts USAGE_INSTRUCTION

      exit(1)
    end

    def self.parse_arguments
      begin
        argv1, argv2 = @cli_argv
        total = argv1 ? Integer(argv1) : DEFAULT_TOTAL
        thread_count = argv2 ? Integer(argv2) : DEFAULT_THREADS
      rescue ArgumentError
        puts 'Both arguments should be integer'
        exit(1)
      end

      [total, thread_count]
    end
  end
end