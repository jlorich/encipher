# Encipher

A public-key encryption based secrets storage solution. Will soon interface with both
secrets.yml and dotenv

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

## Loading

Encipher can also be used to load the available secrets into the enviornment.  As early as possible in your application simple do:

	require 'encipher'
    Encipher.load

## Contributing

1. Fork it ( https://github.com/jlorich/encipher/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
