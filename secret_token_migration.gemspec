# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'secret_token_migration/version'

Gem::Specification.new do |gem|
  gem.name          = "secret_token_migration"
  gem.version       = SecretTokenMigration::VERSION
  gem.authors       = ["Tieg Zaharia"]
  gem.email         = ["tieg.zaharia@gmail.com"]
  gem.description   = %q{A gem for the maintaneance of secret_tokens.}
  gem.summary       = %q{Easy way to switch to a secret_token while not 
                        logging out most of your users.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "rails", "~> 3.2.11"

  gem.add_development_dependency "shoulda", "~> 3.3.2"
end
