# frozen_string_literal: true

module CodeKata
  module Outputs
    class BaseOutput
      class << self
        def puts
          raise NotImplementedError, 'You must implement the #puts method'
        end
      end
    end
  end
end