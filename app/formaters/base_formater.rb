# frozen_string_literal: true

module CodeKata
  module Formaters
    class BaseFormater
      class << self
        def format
          raise NotImplementedError, 'You must implement the #format method'
        end
      end
    end
  end
end