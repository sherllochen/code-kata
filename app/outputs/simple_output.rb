# frozen_string_literal: true
require_relative './base_output'
require_relative '../../lib/simple_logger'

module CodeKata
  module Outputs
    class SimpleOutput < BaseOutput
      include SimpleLogger

      class << self
        # @param [string] string
        def puts(string)
          logger.info(string)
        end
      end
    end
  end
end