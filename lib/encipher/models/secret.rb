require 'data_mapper'

module Encipher
  class Secret
    include DataMapper::Resource

    attr_accessor :unlocked_value
    attr_accessor :locked
    
    belongs_to :user

    property :id,          Serial
    property :value,       Text


    # def value
    #   unlocked? ? unlocked_value : super
    # end

    def value=(v)
      fail "Secret must be unlocked to set the value" if locked?

      super v
    end

    def locked?
      !!@locked
    end

    def unlocked?
      !locked?
    end

    def unlocked_value=(value)
      @unlocked_value = value
      @unlocked = true
    end

    def save
      fail "Cannot save an unlocked secret" unless locked?
      super
    end
  end
end