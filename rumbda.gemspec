require File.join([File.dirname(__FILE__), 'lib', 'rumbda', 'version.rb'])

Gem::Specification.new do |gem|
  gem.name          = 'rumbda'
  gem.version       = Rumbda::VERSION
  gem.authors       = ['kleaver']
  gem.email         = []
  gem.summary       = 'Easily run ruby on lambda!'
  gem.description   = 'Run ruby scripts on aws lambda.'
  gem.homepage      = 'https://github.com/kleaver/rumbda'
  gem.licenses      = ['MIT']

  gem.files         = Dir['lib/**/*', 'bin/*', 'lambda/*']
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }

  gem.add_runtime_dependency 'thor', '~> 0.19'
  gem.add_runtime_dependency 'bundler', '= 1.9.9' # bundler version must match the version traveling ruby uses
end
