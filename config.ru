require_relative 'lib/go_watchdog.rb'
require 'highline/import'

config = YAML.load(File.read(File.join(ENV['HOME'], '.go_watchdog.yml')))
username = config['credentials']['username']
host = config['pipeline']['host']
config['credentials']['password'] ||= ask("enter password for #{username}@#{host}: ") { |prompt| prompt.echo = false }

WATCHDOG_CONFIG = config

run GoWatchdogApp
