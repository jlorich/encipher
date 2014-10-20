require 'dot_configure'
require 'recursive-open-struct'

# Encipher secrets storage
module Encipher
  extend DotConfigure

  # Requires a key or array of keys to be present, otherwise throw an exception
  def self.require(keys)
    [*keys].each do |key|
      fail "Encipher key (#{key}) not found" unless secrets.keys.include? key.to_s
    end
  end

  # Gets the current encipher environment
  # Precedence: Manually set env, ENCIPHER_ENV environment variable, options env, default
  def self.env
    @env ||= if ENV['ENCIPHER_ENV']
               ENV['ENCIPHER_ENV'].to_sym
             else
               (options.env ? options.env.to_sym : nil) || :development
             end
  end

  # Manually set the encipher env
  def self.env=(env)
    @env = env.to_sym
  end

  # Loads, caches, and returns all available secrets
  # @param reload [Boolean] Forces the secrets to reload
  def self.secrets(reload: false)
    return @secrets if @secrets && !reload
    environment = Encipher::Environment.new(options.keypath)
    @secrets = RecursiveOpenStruct.new(environment.hash)
  end

  # Forces a secrets reload
  def self.reload
    secrets(reload: true)
  end
end
