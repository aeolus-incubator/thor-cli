# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aeolus_cli/version'

Gem::Specification.new do |gem|
  gem.name          = "aeolus_cli"
  gem.version       = AeolusCli::VERSION
  gem.authors       = "Crag Wolfe"
  gem.email         = "cwolfe@redhat.com"
  gem.description   = %q{Command-line interface to aeolus}
  gem.summary       = %q{Command-line interface to aeolus}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency "aruba"
  gem.add_development_dependency "cucumber"
  gem.add_development_dependency "rspec"
  gem.add_dependency "activeresource", "~>3.2.8"
  gem.add_dependency "activesupport", "~>3.2.8"
  gem.add_dependency "nokogiri", "~>1.5.5"
  gem.add_dependency "thor", "~>0.16.0"
end
