require 'pry'
module Encipher
  class Security
    @private_key = nil
    @public_key = nil

    def initialize(private_key)
      binding.pry
      @private_key = Net::SSH::KeyFactory.load_private_key(private_key)
    end

    def public_key
      @private_key.public_key.to_s
    end

    def parse_public_key(public_key)
      Net::SSH::KeyFactory.load_data_public_key(public_key).to_s
    end

    def encrypt(string, public_key = nil)
      fail 'No key specified' if !public_key && !@private_key 

      key =  OpenSSL::PKey::RSA.new(@private_key.public_key.to_pem)

      Base64.encode64(key.public_encrypt(string))
    end

    def decrypt(string)
      raise Exception.new("no private key loaded") unless @private_key
      @private_key.private_decrypt(Base64.decode64(string))
    end
  end
end