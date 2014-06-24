require 'data_mapper'

module Encipher
  class User
    include DataMapper::Resource

    property :id,         Serial
    property :public_key, Text
    has n, :secrets
  end
end