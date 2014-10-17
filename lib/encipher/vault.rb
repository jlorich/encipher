require 'pry'
require 'data_mapper'
require 'encipher/security'
require 'encipher/models/user'
require 'encipher/models/secret'
require 'net/ssh'
require 'base64'
require 'deep_merge'

module Encipher
  # The main encipher secrets storage entrypoint
  class Vault
    # Initalizes the database and loads the keys
    def initialize(secret_key)
      @secret_key = secret_key
      initialize_database
    end

    # locks a secrets contents
    def lock(secret)
      secret.value = security.encrypt(secret.unlocked_value.to_yaml, secret.user.public_key)
      secret.locked = true
      secret
    end

    # unlocks a secrets contents
    def unlock(secret)
      secret.locked = false
      secret.unlocked_value = nil ? !secret.value : YAML.load(security.decrypt(secret.value))
      secret
    end

    def where(options)
      require_user

      [].tap { |r| 
        current_user.secrets.each do |secret|
          contents = unlock(secret).unlocked_value
          r << secret if compare(contents, { env: Encipher.env }.deep_merge(options))
        end
      }
    end

    # checks if the keys/values in options are included in ojbect
    def compare(object, options)
      options.keys.each do |key|
        return false unless object[key] == options[key]
      end

      true
    end

    # Enroll a new user's key or the current users
    def enroll(key_path = nil)
      #ssh_key ? Net::SSH::KeyFactory.load_data_public_key(ssh_key) :

      if key_path
        raise Exception.new 'Bad key path' unless File.exist? File.expand_path(key_path)
        key = File.read(key_path)
      else
        key = security.public_key
      end

      if user_exists? key
        puts 'Key already enrolled'
      else
        User.create(public_key: key) 
        puts 'Key was successfully enrolled'
      end
    end

    # Checks if a user exists by public key
    def user_exists?(public_key)
      User.all(public_key: public_key).count > 0
    end

    # Revoke a user by key or name
    def revoke(name: nil, key:nil)
      require_user

      if key
        User.all(public_key: key).destroy
      end
    end

    protected

    # returns the memoized security object
    def security
      return @security if defined? @security
      @security = Security.new(@secret_key)
    end

    # Finalizes datamapper and initializes the sqlite database
    def initialize_database(database_path = './secrets.db')
      DataMapper.finalize

      database_path = File.expand_path database_path

      @dm = DataMapper.setup(:default, "sqlite:///#{database_path}")

      unless File.exist? database_path
        SQLite3::Database.new(database_path)
        DataMapper.auto_migrate!
      end
    end

    # Gets the current user object
    def current_user
      User.all(public_key: security.public_key).first
    end

    def require_user
      fail Exception.new 'Current user must be enrolled' unless current_user  
    end
  end
end