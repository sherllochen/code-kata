# frozen_string_literal: true

require 'yaml'
require 'singleton'

module CodeKata
  class Config
    include Singleton

    attr_accessor :log_level

    CONFIG_FILE = './config.yml'

    def initialize
      yml_config = YAML.load_file(CONFIG_FILE)
      yml_config.each do |attribute_name, attribute_value|
        self.class.send(:define_method, attribute_name.to_sym) do
          instance_variable_get("@#{attribute_name.to_s}")
        end

        self.send("#{attribute_name}=".to_sym, attribute_value)
      end
    end
  end
end