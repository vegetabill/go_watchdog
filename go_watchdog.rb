require 'sinatra'
$LOAD_PATH << 'lib'
require 'go_watchdog_helper'
require 'impatient_watchdog'
require 'time_ago_in_words'

set :public_folder, File.dirname(__FILE__) + '/static'

include GoWatchdogHelper

get '/' do
  erb :index
end

get '/time' do
  time = TimeAgo::in_words last_green_build_time
  mood = ImpatientWatchdog.new(config).mood :waiting_since => last_green_build_time
  <<-JAVASCRIPT
   $("#time_since_last_green_build").text('#{time}');
   $('body').removeClass('happy neutral angry');
   $('body').addClass('#{mood}');
  JAVASCRIPT
end
