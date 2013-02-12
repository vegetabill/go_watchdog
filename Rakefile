require 'rake/testtask'

task :default => [:quiet, :test]

task :quiet do 
  ENV['QUIET'] = 'true'
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end