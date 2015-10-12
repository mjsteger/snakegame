# expand_path('../lib/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Michael Steger"]
  gem.email         = ["mjsteger1@gmail.com"]
  gem.description   = %q{Play snake! Simply install, then run snake}
  gem.summary       = %q{snake game with curses}
  gem.homepage      = "http://stegerwerks.org"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = ["snake"]
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "snakegame"
  gem.add_runtime_dependency "curses"
  gem.require_paths = ["lib"]
  gem.version       = "0.0.3"
end
