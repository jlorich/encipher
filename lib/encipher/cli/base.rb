require 'thor'
require 'yaml'
require 'ostruct'
require 'encipher/vault'
require 'encipher/environment'

module Encipher
  module Cli

    # Base CLI commands
    class Base < Thor
      protected

      # Loads and configures encipher
      def environment
        return @environment if defined? @environment

        @environment = Encipher::Environment.new(config.key_path)
      end

      def vault
        return @vault if defined? @vault

        @vault = Encipher::Vault.new(config.key_path)
      end

      # Loads and returns the config file (memoized)
      def config
        return @config if defined? @config

        config_path = File.expand_path './.encipher'

        unless File.exist? config_path
          fail 'You must run encipher init before running'
        end

        @config = OpenStruct.new YAML.load(File.read(config_path))
      end
    end
  end
end
