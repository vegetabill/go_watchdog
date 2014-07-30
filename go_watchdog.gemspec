lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'bundler/version'

Gem::Specification.new do |s|
  s.name        = "go_watchdog"
  s.version     = "1.2.4"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bill DePhillips"]
  s.email       = ["bill.dephillips@gmail.com"]
  s.licenses    = ['MIT']
  s.homepage    = "https://github.com/rearadmiral/go_watchdog"
  s.summary     = "the watchdog angrier the longer it's been since a green build"
  s.description = "watches your Go.CD pipeline and changes status depending on time since last green build"

  s.add_runtime_dependency "last_green_go_pipeline", '~> 1.1'
  s.add_runtime_dependency "highline", '~> 1.6'
  s.add_runtime_dependency "sinatra", '~> 1.4'

  s.executables << 'go_watchdog'

  s.files        = Dir.glob("{lib}/**/*") + %w(LICENSE README.md config.yml.example)
  s.require_path = 'lib'
end
