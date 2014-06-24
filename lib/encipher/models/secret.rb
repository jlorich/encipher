require 'data_mapper'

module Encipher
  class Secret
    include DataMapper::Resource


    belongs_to :user
    property :id,         Serial
   # property :user_id, Integer, key: true
    property :name, String, key: true
    property :value, Text
  end
end