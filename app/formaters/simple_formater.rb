# frozen_string_literal: true
require_relative './base_formater'

module CodeKata
  module Formaters
    class SimpleFormater < BaseFormater
      class << self
        # @param [hash] json
        # @return [string]
        def format(json)
          title = json['title']
          completed = json['completed']

          "TITLE: #{title}, COMPLETED: #{completed}"
        end
      end
    end
  end
end