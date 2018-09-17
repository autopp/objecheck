lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'objecheck/version'

Gem::Specification.new do |spec|
  spec.name          = 'objecheck'
  spec.version       = Objecheck::VERSION
  spec.authors       = ['autopp']
  spec.email         = ['autopp.inc@gmail.com']

  spec.summary       = 'schema and validatior for a Ruby object'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/autopp/objecheck'
  spec.license       = 'Apache-2.0'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
end
