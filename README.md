# Encipher

A public-key encryption based secrets storage solution. 

## Installation

Add this line to your application's Gemfile:

    gem 'encipher', git: git://github.com/jlorich/encipher.git

And then execute:

    $ bundle


## Usage

Initialize encipher with your desired private key (this location will be cached in the .encipher file)

    encipher init

Enroll yourself as the first user

    encipher enroll

To store a secret:

    encipher store "secret name" "this is really cool"

To retreive a secret:

    encipher get "secret name"
    
To load, encrypt, and store the contents of a dotenv file (note: this does not delete the .env file, it only loads the contents.  It is up to you to delete it yourself for security purposes.):

    encipher dotenv


## Loading enviornment variables

Encipher can also be used to load the available secrets into the enviornment.  As early as possible in your application simple do:

	require 'encipher'
    Encipher.load_env
    
## Future Thoughts

Store login information

    > encipher set login github my@email.com xxxxxxxx
	
Store login information via prompt

    > encipher set login
    Username/email: my@email.com
    Password: xxxxxxxx
	Description: github

View login information

	> encipher get login github
		User: my@email.com
	Password: xxxxxxxx
	
View login information via prompt

	> encipher get login
	Login information available for:
	  1. github
	  2. urban airship
	  3. apple developer center
	  
	Which would you like to view? 1.
	
	User: my@email.com
	Password: xxxxxxxx

		
	> encipher get login github.com

Set enviornment variable

    > encipher set env TEST_ENV_KEY xxxxxxxxxx
    	
Set enviornment variable via prompt

    > encipher set env
    key: TEST_ENV_KEY
    value: env_key_value_here
	

## Contributing

1. Fork it ( https://github.com/jlorich/encipher/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request










--- notes ---

