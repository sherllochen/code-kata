# frozen_string_literal: true
require 'json'
require_relative './request_client'
require_relative '../formaters/simple_formater'
require_relative '../outputs/simple_output'

module CodeKata
  module Clients
    class SimpleClient
      include RequestClient

      parser JSON
      formater Formaters::SimpleFormater
      output Outputs::SimpleOutput
    end
  end
end