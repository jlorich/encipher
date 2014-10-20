require 'encipher/cli/base'

module Encipher
  module Cli
    # Encipher conversions
    class Convert < Base
      # desc 'dotenv', 'Loads a .env file to secrets.db'
      # def dotenv(path='./.env')
      #   path = File.expand_path path

      #   if !File.exist? path
      #     fail Exception.new 'A valid .env file must exist'
      #   end

      #   loader = Dotenv.new(path, encipher)
      #   loader.store

      #   if loader.secrets.count == 0
      #     puts 'No secrets stored'
      #   else
      #     puts "#{loader.secrets.count} secrets loaded"
      #   end
      # end
    end
  end
end
