require 'thor'
require 'yaml'
require 'hashie'

require 'pry'

require 'encipher'
require 'encipher/dotenv'
require 'encipher/environment'
require 'encipher/vault'

# Encipher
module Encipher
  # Base CLI commands
  class BaseCLI < Thor
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

      if !File.exist? config_path
        fail Exception.new 'You must run encipher init before running'
      end

      @config = Hashie::Mash.new YAML.load(File.read(config_path))
    end
  end

  # Encipher set methods
  class Set < BaseCLI 
    desc 'env', 'Storess the given value for the key'
    def env(key, value)
      environment.set key, value
    end

    # desc 'store', 'Storess the given value for the key'
    # def login(username, password, description)
    #   encipher.store key, value
    # end
  end

  # Encipher get methods
  class Get < BaseCLI 
    desc 'env', 'Returns the environment variable for the given key'
    def env(key)
      puts environment.get key
    end

    # desc 'env', 'Returns the login for the given key'
    # def login(key)
    #   encipher.get :login, key, value
    # end
  end

  class List < BaseCLI 
    desc 'env', 'Lists all available Encipher secrets'
    def env
      puts environment.list
      # secrets =  encipher.secrets

      # if secrets.count == 0
      #   puts 'No secrets stored'
      # else
      #   puts secrets
      # end
    end
  end

  # Encipher conversions
  class Convert < BaseCLI 
    # desc 'dotenv', 'Loads a .env file to secrets.db'
    # def dotenv(path='./.env')
    #   path = File.expand_path path

    #   if !File.exist? path
    #     fail Exception.new 'A valid .env file must exist'
    #   end

    #   loader = Dotenv.new(path, encipher)
    #   loader.store

    #   if loader.secrets.count == 0
    #     puts 'No secrets stored'
    #   else
    #     puts "#{loader.secrets.count} secrets loaded"
    #   end
    # end
  end

  # Encipher command line interface
  class CLI < BaseCLI
    desc 'get [type] [key]', 'Returns an unencrypted value'
    subcommand "get", Get

    desc 'set [type] [key] [value]', 'Set an encrypted value'
    subcommand "set", Set

    desc 'list [type]', 'Lists all secrets'
    subcommand "list", List

    desc 'convert [type]', 'Converts various password stores to encipher'
    subcommand "convert", Convert

    desc 'init', 'loads they key at the given keypath'
    def init(key_path = '~/.ssh/id_rsa')
      key_path = File.expand_path key_path
      config_path = File.expand_path './.encipher'

      fail Exception.new '.encipher file already exists' if File.exist? config_path
      fail Exception.new 'Specified key path does not exist' unless File.exist? key_path

      File.open(config_path, 'w') { |file|
        file.write({key_path: key_path}.to_yaml)
      }

      puts 'Encipher is ready for use'
    end

    desc 'enroll', 'Enrolls a new public key'
    def enroll(key = nil)
      vault.enroll(key)
    end
  end
end
