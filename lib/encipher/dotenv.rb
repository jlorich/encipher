# Encipher
module Encipher
  # Dotenv parser
  class Dotenv
    def initialize(path, encipher)
      @dotenv = YAML.load(File.read(path))
      @encipher = encipher
    end

    def secrets
      @dotenv
    end

    def store
      @dotenv.each do |name, secret|
        @encipher.store name, secret
      end
    end
  end
end