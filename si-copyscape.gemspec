# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = "si-copyscape"
  spec.version       = SI::CopyScape::VERSION
  spec.authors       = ['Shane Kretzmann']
  spec.email         = ["SKretzmann@searchinfluence.com"]
  spec.summary       = %q{Gem to interface with Copyscape api}
  spec.description   = %q{Allow any ruby application to easily interact with copyscape premium api}
  spec.homepage      = "https://github.com/searchinfluence/copyscape"
  spec.license       = "Private Property (c) Search Influence"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "minitest"

  spec.add_runtime_dependency "crack"
end
