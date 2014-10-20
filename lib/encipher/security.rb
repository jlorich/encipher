# Encipher
module Encipher
  # Handles key loading, encryption, and decryption
  class Security

    # Loads the private key
    def initialize(private_key)
      @private_key = Net::SSH::KeyFactory.load_private_key(private_key)
    end

    # Returns the pem public key associated with this security object
    def public_key
      require_key

      @private_key.public_key.to_pem
    end

    # Encrypts a string of text with the given public key
    def encrypt(string, public_key = nil)
      require_key unless public_key

      key =  OpenSSL::PKey::RSA.new(public_key || @private_key.public_key.to_pem)

      Base64.encode64(key.public_encrypt(string))
    end

    # Decrypts a string of text with the current private key
    def decrypt(string)
      require_key

      @private_key.private_decrypt(Base64.decode64(string))
    end

    private

    # Raises an error if no private key has been loaded
    def require_key
      fail 'No private key loaded' unless @private_key
    end
  end
end
