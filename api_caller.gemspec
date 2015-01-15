# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'api_caller/version'

Gem::Specification.new do |spec|
  spec.name          = "api_caller"
  spec.version       = ApiCaller::VERSION
  spec.authors       = ["vpopolitov"]
  spec.email         = ["tiermes@yandex.ru"]
  spec.description   = %q{Wrapper around REST and SOAP services meant for unify an access to them}
  spec.summary       = %q{API wrapper}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
