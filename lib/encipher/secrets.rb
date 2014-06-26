module Encipher
  # The main encipher secrets storage entrypoint
  class Secrets
    attr_accessor :security
    attr_accessor :user_id

    @security = nil
    @user_id = nil
    @dm = nil

    def initialize(secret_key)
      initialize_database
      @security = Security.new(secret_key)
    end

    # Finalizes datamapper and initializes the sqlite database
    def initialize_database(database_path = './secrets.db')
      DataMapper.finalize

      database_path = File.expand_path database_path

      @dm = DataMapper.setup(:default, "sqlite:///#{database_path}")

      unless File.exist? database_path
        SQLite3::Database.new(database_path)
        DataMapper.auto_migrate!
      end
    end

    # Enroll a new user's key or the current users
    def enroll(key_path = nil)
      #ssh_key ? Net::SSH::KeyFactory.load_data_public_key(ssh_key) :

      if key_path
        raise Exception.new 'Bad key path' unless File.exist? File.expand_path(key_path)
        key = File.read(key_path)
      else
        key = @security.public_key
      end

      if user_exists? key
        puts 'Key already enrolled'
      else
        User.create(public_key: key) 
        puts 'Key was successfully enrolled'
      end
    end

    # Checks if a user exists by public key
    def user_exists?(public_key)
      User.all(public_key: public_key).count > 0
    end

    # Revoke a user by key or name
    def revoke(name: nil, key:nil)
      fail Exception.new 'Current user must be enrolled' unless current_user

      if key
        User.all(public_key: key).destroy
      end
    end

    # Gets the current user object
    def current_user
      User.all(public_key: @security.public_key).first
    end


    # Store a new secret
    def store(name, value)
      fail Exception.new 'Current user must be enrolled' unless current_user

      Secret.all(name: name).destroy

      User.each do |user|
        encrypted = @security.encrypt(value.to_s, user.public_key.to_s)
        s = Secret.create(user: user, name: name, value: encrypted)
      end
    end

    def secret_exists?(name)
      fail Exception.new 'Current user must be enrolled' unless current_user

      Secret.all(name: name).count > 0
    end

    def retrieve(name)
      fail Exception.new 'Current user must be enrolled' unless current_user

      @security.decrypt current_user.secrets.all(name: name).first.value
    end

    def destroy(name)
      fail Exception.new 'Current user must be enrolled' unless current_user

      Secret.all(name: name).destroy
    end

    def users
      fail Exception.new 'Current user must be enrolled' unless current_user
      #@database.list_users
    end

    def secrets
      fail Exception.new 'Current user must be enrolled' unless current_user

      current_user.secrets.collect { |c| c.name }
    end
  end
end