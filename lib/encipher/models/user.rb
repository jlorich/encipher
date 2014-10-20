require 'data_mapper'

module Encipher
  # An encipher user
  class User
    include DataMapper::Resource

    has n, :secrets

    property :id,         Serial
    property :public_key, Text
  end
end
