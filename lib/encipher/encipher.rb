require 'encipher/secrets'
require 'dot_configure'

# Encipher secrets storage
module Encipher
  extend DotConfigure

  def self.env
    @env ||= ENV['ENCIPHER_ENV'] ? ENV['ENCIPHER_ENV'].to_sym : options.env.to_sym || :development
  end

  def self.env=(env)
    @env = env.to_sym
  end

  def self.secrets(reload: false)
    return @secrets if @secrets && !reload
    environment = Encipher::Environment.new(options.keypath)
    @secrets = environment.get_hash
  end
end
