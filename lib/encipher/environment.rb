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
      where(type: :env, name: name).map(&:destroy)

      User.each do |user|
        lock(Secret.new(
          user: user,
          unlocked_value: {
            env: Encipher.env,
            type: :env,
            name: name,
            value: value
          }
        )).save
      end
    end

    def get(name)
      require_user

      env = unlock(where(type: :env, name: name).first).unlocked_value
      env[:value]
    end

    def list
      require_user
      where(type: :env).map { |s| unlock(s).unlocked_value[:name] }
    end

    def hash
      all.each_with_object({}) do |secret, result|
        result[secret[:name]] = secret[:value]
      end
    end

    def hash=(hash)
      hash.each do |key, value|
        set(key, value)
      end
    end

    def user_hash
      users.each_with_object({}) do |user, result|
        key = OpenSSL::PKey::RSA.new(user.public_key)
        type = key.ssh_type
        data = [key.to_blob].pack('m0')
        result[user.id] = "#{type} #{data}"
      end
    end

    private

    def users
      User.all
    end

    def all
      where(type: :env).map { |s| unlock(s).unlocked_value }
    end
  end
end
