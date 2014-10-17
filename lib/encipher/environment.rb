require 'yaml'
require 'encipher'
require 'encipher/vault'
require 'recursive-open-struct'

module Encipher
  # Enviornment variable storage
  class Environment < Vault

    # Store a new environment variable
    def set(name, value)
      require_user

      # Delete all existing variables of that name
      where({type: :env, name: name}).map(&:destroy)

      User.each do |user|
        lock(Secret.new(user: user, unlocked_value: {
          env: Encipher.env,
          type: :env,
          name: name,
          value: value
         })).save
      end
    end

    def get(name)
      require_user
      
      env = unlock(where({type: :env, name: name}).first).unlocked_value
      env[:value]
    end

    def list
      require_user
      where(type: :env).collect { |s| unlock(s).unlocked_value[:name] }
    end

    def get_hash
      RecursiveOpenStruct.new.tap do |result|
        all.map do |secret|
          result[secret[:name]] = secret[:value]
        end
      end
    end

    def set_hash(hash)
      hash.each do |key, value|
        set(key, value)
      end
    end

    private

    def all
      where(type: :env).collect { |s| unlock(s).unlocked_value }
    end
  end
end