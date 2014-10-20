require 'encipher/cli/base'
require 'encipher/cli/convert'
require 'exedit'
require 'json'
require 'awesome_print'
require 'pry'

module Encipher
  module Cli
    # Encipher command line interface
    class Cli < Base
      desc 'get [key]', 'Returns an unencrypted value'
      def get(key)
        puts environment.get key
      end

      desc 'set [key] [value]', 'Set an encrypted value'
      def set(key, value)
        environment.set key, value
      end

      desc 'list', 'Lists all secrets for the current environment'
      def list
        puts environment.list
      end

      desc 'edit', 'Edit all secrets in an external editor'
      def edit
        result = Exedit.edit environment.hash.to_yaml

        environment.hash = YAML.load(result)
      end

      desc 'keys', 'Lists all enrolled keys'
      def keys
        environment.user_hash.each do |id, ssh_key|
          wrapped = wrap(ssh_key, 70)

          if wrapped.count > 1
            puts "#{id.to_s.rjust(10)} - #{wrapped.shift}"

            wrapped.each do |string|
              puts "             #{string}"
            end
          else
            puts puts "#{id} - #{ssh_key}"
          end
        end
      end

      desc 'convert [type]', 'Converts various password stores to encipher'
      subcommand 'convert', Convert

      desc 'init', 'loads they key at the given keypath'
      def init(key_path = '~/.ssh/id_rsa')
        key_path = File.expand_path key_path
        config_path = File.expand_path './.encipher'

        fail '.encipher file already exists' if File.exist? config_path
        fail 'Specified key path does not exist' unless File.exist? key_path

        File.open(config_path, 'w') do |file|
          file.write({ key_path: key_path }.to_yaml)
        end

        puts 'Encipher is ready for use'
      end

      desc 'enroll', 'Enrolls a new public key'
      def enroll(key = nil)
        vault.enroll(key)
      end

      desc 'revoke', 'Destroys a user and all their secrets'
      def revoke(user_id)
        vault.revoke(user_id)
      end

      protected

      def wrap(string, width)
        string.chars.each_slice(width).map(&:join)
      end
    end
  end
end
