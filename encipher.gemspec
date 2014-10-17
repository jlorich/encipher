# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'encipher/version'

Gem::Specification.new do |spec|
  spec.name          = "encipher"
  spec.version       = Encipher::VERSION
  spec.authors       = ["Joey Lorich"]
  spec.email         = ["jospeh@lorich.me"]
  spec.summary       = %q{Secure secrets management}
  spec.description   = %q{Secure secrets management description!}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency 'rake', '~> 10.3.2'
  spec.add_development_dependency 'pry-byebug', '~> 1.3.3'
  spec.add_development_dependency 'rspec', '~> 3.0.0'
  spec.add_development_dependency 'clint_eastwood', '~> 0.0.1'

  spec.add_dependency 'thor', '~> 0.19.1'
  spec.add_dependency 'highline', '~> 1.6.21'
  spec.add_dependency 'deep_merge', '~> 1.0.1'
  spec.add_dependency 'net-ssh', '~> 2.9.1'
  spec.add_dependency 'sqlite3', '~> 1.3.9'
  spec.add_dependency 'data_mapper', '~> 1.2.0'
  spec.add_dependency 'dm-sqlite-adapter', '~> 1.2.0'
  spec.add_dependency 'dot_configure', '~> 0.0.1'
  spec.add_dependency 'exedit', '~> 0.0.1'
  spec.add_dependency 'awesome_print', '~> 1.2.0'

  spec.executables = ['encipher']
end
