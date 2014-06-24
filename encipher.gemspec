# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'encipher/version'

Gem::Specification.new do |spec|
  spec.name          = "encipher"
  spec.version       = Encipher::VERSION
  spec.authors       = ["Joey Lorich"]
  spec.email         = ["joey@cloudspace.com"]
  spec.summary       = %q{Secure secrets management}
  spec.description   = %q{Secure secrets management description!}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  
  spec.add_dependency 'hashie', '~> 3.0.0'
  spec.add_dependency 'thor', '~> 0.19.1'
  spec.add_dependency 'highline', '~> 1.6.21'

  spec.add_dependency 'net-ssh', '~> 2.9.1'
  spec.add_dependency 'sqlite3', '~> 1.3.9'
  spec.add_dependency 'data_mapper', '~> 1.2.0'
  spec.add_dependency 'dm-sqlite-adapter', '~> 1.2.0'


  spec.executables = ['encipher']
end
