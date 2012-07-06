# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rtrace/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Christoph Koehler"]
  gem.email         = ["christoph@zerodeviation.net"]
  gem.description   = %q{Subset of traceroute functionality with added geocoded
  location based on IP. Uses the geocoder gem.}
  gem.summary       = %q{traceroute in Ruby with geocoding.}
  gem.homepage = %q{http://rubygems.org/gems/rtrace}

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rtrace"
  gem.require_paths = ["lib"]
  gem.version       = Rtrace::VERSION

  gem.add_dependency 'geocoder'
end
