# frozen_string_literal: true

module CodeKata
  class BaseGenerator
    def generate
      raise NotImplementedError, 'You must implement the #generate method'
    end
  end
end