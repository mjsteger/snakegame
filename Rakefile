require 'rake/testtask'
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*.rb']
end
task :default => :test

task :rebuild do
  %x{gem uninstall snakegame
  rm snakegame*.gem
  gem build snakegame.gemspec
  gem install ./snakegame*.gem}
end
