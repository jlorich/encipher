# Encipher

An RSA ssh-key encryption based configuration storage solution. 

Keeping configuration information in the environment is one of the tenants of a [twelve-factor app](http://12factor.net/config), however configuring each server individually can be time consuming and when configuration information needs to change often lots of work must be done.

Encipher provides a method to simplify this situation by keeping enviroment and user restricted, public-key encrypted, secrets right in the repository.  On application load Encipher decrepts the secrets for the appropriate environment using a private key held on the server and stores them in memory.

####Really? Secrets in the repository?

Yes.  In general, secret information should not be kept in a source repository.  Each developer with permission to clone a repository should not necessarily have permission to deploy or edit configuration information. However, all Encipher-kept secrets are only decryptable by a user with a valid, enrolled, private key that has had a certain environments secrets enabled by an authorized user.

####How it works
Each encipher user and server has a public ssh key enrolled by another authroized user for a given environment (the initial secrets database creation enrolls the first user).  The enrolled user's public key is then stored for future use.  When a secret is added or modified, an entry is created and encrypted with each enrolled key.  Each user can *only* decrypt secrets encrypted with their public key, so limiting a key's access to a certain set of secrets is easy.


## Installation

Add this line to your application's Gemfile:

    gem 'encipher', git: git://github.com/jlorich/encipher.git

And then execute:

    $ bundle


## Environment-based restrictions
All actions are by default segregated by encipher-environment.  Each key must be enrolled in each environment to be able to read or set secrets for it. The enviorment is by default `:development`, but may be set by specifiying the `ENCIPHER_ENV` enviornment variable. The enviornment may also be set in code by calling `Encipher.env = :my_env`.

All secrets set will only be encrypted for keys enrolled in the given environment.


## Command line usage

Initialize encipher with your desired private key (this location will be cached in the .encipher file)

    encipher init

You can also specify the key path with 

    encipher init /path/to/your/private_key

#####Enroll yourself.  Your public key will be auto-generated from the private key used with encipher init.

    encipher enroll

#####Enroll a new user or servers key

    encipher enroll ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCvRm/KvZy8iDyDgjokMMMMUz8UK84OlBGbeeo6VT8UZc6e8E1xUNfFCNp6xUQMO8N+vpqxlOr3haAXn6sdHCnMb8BpWYwq0Un19WaToTiv/15tRvZzkQw9KPu/TjBy8OaSjNAAxo5rWkJbDc0K4WdBtDJ4uk3i+UmxpYXhOtC9eCLgMdxZ6xIWuP0ymyYe/SZSdupeKblaehYyFEb2NKTVbvnbef79ZogJG7IlWFYS+qaqk+xFZIRYEX3yLIijF/WvLmZw2NVurb8rhnNLNDI3v+Gy+bw0sitZKvX5MWunpmykFY8/5YnWuEA1AJGaexC/1EWXUzVN6o2my4Aqlwz

#####To store a secret:

    encipher set "secret name" "this is really cool"

#####To retreive a secret:

    encipher get "secret name"

#####To list all enrolled secrets:

    encipher list

## Easy Editing
For ease of editing, Encipher also provides the `edit` command line option.

    encipher edit

Calling `edit` will launch an external editor (specified by the `EDITOR` environment variable, and by default `vi` on most systems) populated with the entire secrets hash in [YAML](http://www.yaml.org/) for the current environment.  Once saved, all specified secrets will be re-encrypted for all appropriately enrolled keys and the tempfile used for editing will be destroyed.

## Programmatic usage

##### Configuration
Each application can be configured as follows:

    Encipher.configure do |config|
      config.keypath = '~/.ssh/my_server_key'
      config.env = :staging
    end

##### Secrets

All secrets are accessabile by calling

    Encipher.secrets
    
This returns a [Recursive OpenStruct](https://github.com/aetherknight/recursive-open-struct) (a hash deeply accessible by string, symbol, or dot notation) containing all secrets information for the specified environment.  Once loaded the information is cached in-memory so all subsequent calls to `secrets` won't need to re-decrypt each secret.

If secrets reloading is desired `Encipher.reload` can be called, or `Encipher.secrets(reload: true)` can be referenced to force reloading.

## Contributing

1. Fork it ( https://github.com/jlorich/encipher/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
