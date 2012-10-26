# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aeocli/version'

Gem::Specification.new do |gem|
  gem.name          = "aeocli"
  gem.version       = Aeocli::VERSION
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
  gem.add_dependency "activeresource"
  gem.add_dependency "active_support", "~>3.0.0"
  gem.add_dependency "nokogiri", "~>1.5.5"
  gem.add_dependency "thor", "~>0.16.0"
end
