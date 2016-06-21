# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'proactives/version'

Gem::Specification.new do |spec|
  spec.name          = "proactives"
  spec.version       = Proactives::VERSION
  spec.authors       = ["Raphael Monteiro"]
  spec.email         = ["rmonteiro89@hotmail.com"]

  spec.summary       = 'Ruby client for the Proactives API'
  spec.description   = 'Proactives is a suite for the apps Goyave, Papaye, Jobo and Pitaya.  See http://proactives.site for details.'
  spec.homepage      = 'http://proactives.site'
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- test/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
