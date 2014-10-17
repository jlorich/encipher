require 'encipher/version'
require 'encipher/secrets'
require 'encipher/security'
require 'encipher/vault'
require 'encipher/environment'
require 'encipher/models/secret'
require 'encipher/models/user'

require 'sqlite3'
require 'rubygems'
require 'base64'
require 'data_mapper'
require 'net/ssh'
require 'pry'


# Encipher secrets storage
module Encipher
  def self.env
    @env ||= ENV['ENCIPHER_ENV'] ? ENV['ENCIPHER_ENV'].to_sym : :default
  end

  def self.load_env
    @encipher = Encipher::Secrets.new('~/.ssh/id_rsa')

    @encipher.secrets.each do |name|
      ENV[name] = @encipher.retrieve name
    end
  end
end
