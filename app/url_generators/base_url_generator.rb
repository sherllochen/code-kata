# frozen_string_literal: true

module CodeKata
  module UrlGenerators
    class BaseUrlGenerator
      def generate
        raise NotImplementedError, 'You must implement the #generate method'
      end
    end
  end
end