# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'proactives/version'

Gem::Specification.new do |spec|
  spec.name          = 'proactives'
  spec.version       = Proactives::VERSION
  spec.authors       = ['Raphael Monteiro']
  spec.email         = ['rmonteiro89@hotmail.com']

  spec.summary       = 'Ruby client for the Proactives API'
  spec.description   = 'Proactives is a suite for the apps Goyave, Papaye, Jobo and Pitaya.  See http://proactives.site for details.'
  spec.homepage      = 'http://proactives.site'
  spec.license       = 'MIT'

  spec.files         = %w(LICENSE.txt README.md proactives.gemspec) + Dir['lib/*.rb', 'lib/proactives/*.rb', 'lib/proactives/api/*.rb', 'lib/proactives/errors/*.rb', 'lib/proactives/modules/controller/*.rb', 'lib/proactives/modules/model/*.rb']
  spec.test_files    = `git ls-files -- test/*`.split("\n")
  spec.require_paths = ['lib']

  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'mocha', '~> 1.0'
  spec.add_dependency 'oauth2', '~> 1.0'
  spec.add_dependency 'faraday', '~> 0.9.2'
  spec.add_dependency 'activemodel', '~> 5.0'
end
