# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'converter/version'

Gem::Specification.new do |spec|
  spec.name          = 'converter'
  spec.version       = Converter::VERSION
  spec.authors       = ['krujos']
  spec.email         = ['jkruck@pivotal.io']

  spec.summary       = %q{Convert vsphere manifests to photon manifests}
  spec.homepage      = 'github.com/pivotal-customer0'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'

end
