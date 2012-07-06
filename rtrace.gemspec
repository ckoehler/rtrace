# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rtrace/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Christoph"]
  gem.email         = ["christoph@zerodeviation.net"]
  gem.description   = %q{traceroute in Ruby}
  gem.summary       = %q{traceroute in Ruby with flair.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rtrace"
  gem.require_paths = ["lib"]
  gem.version       = Rtrace::VERSION

  gem.add_dependency 'geocoder'
end
