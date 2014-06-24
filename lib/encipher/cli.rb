require 'thor'
require 'yaml'
require 'hashie'

require 'pry'

require 'encipher'
require 'encipher/dotenv'

# Encipher
module Encipher
  # Encipher command line interface
  class CLI < Thor

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
      encipher.enroll(key)
    end

    desc 'store', 'Storess the given value for the key'
    def store(key, value)
      encipher.store key, value
    end

    desc 'get', 'Retreives the given value for the key'
    def get(key)
      puts encipher.retrieve key
    end

    desc 'destroy', 'Destroys the value for the given key'
    def destroy(key)
      encipher.destroy key
      puts 'Secret successfully destroyed'
    end

    desc 'list', 'Lists all available Encipher secrets'
    def list
      secrets =  encipher.secrets

      if secrets.count == 0
        puts 'No secrets stored'
      else
        puts secrets
      end
    end

    desc 'dotenv', 'Loads a .env file to secrets.db'
    def dotenv(path='./.env')
      path = File.expand_path path

      if !File.exist? path
        fail Exception.new 'A valid .env file must exist'
      end

      loader = Dotenv.new(path, encipher)
      loader.store

      if loader.secrets.count == 0
        puts 'No secrets stored'
      else
        puts "#{loader.secrets.count} secrets loaded"
      end
    end

    private

    # Loads and configures encipher
    def encipher
      return @encipher if defined? @encipher

      @encipher = Encipher::Secrets.new(config.key_path)
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
end
