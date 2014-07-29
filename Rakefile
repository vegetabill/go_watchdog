require 'rspec/core/rake_task'

task :quiet do
  ENV['QUIET'] = 'true'
end

RSpec::Core::RakeTask.new(:spec)

task :default => [:quiet, :spec]
