require 'encipher/version'
require 'encipher/secrets'
require 'encipher/security'
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
  def self.load(*filenames)
    @encipher = Encipher::Secrets.new('~/.ssh/id_rsa')

    @encipher.secrets.each do |name|
      ENV[name] = @encipher.retrieve name
    end
  end
end
