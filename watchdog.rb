require 'sinatra'
require 'yaml'
$LOAD_PATH << 'lib'
require 'go_watchdog'

raise "Must supply Go username in env variable GO_USERNAME" unless ENV['GO_USERNAME']
raise "Must supply Go password in env variable GO_PASSWORD" unless ENV['GO_PASSWORD']

set :public_folder, File.dirname(__FILE__) + '/static'

def config
  YAML.load(File.read('config.yml'))
end

get '/' do
    erb :index
end

get '/time' do
  osito = GoWatchdog.new(config)
<<-JAVASCRIPT
 $("#time_since_last_green_build").text('#{osito.time_since_last_green_build}');
 $('body').removeClass('happy neutral angry');
 $('body').addClass('#{osito.mood}');
JAVASCRIPT
end