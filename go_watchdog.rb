require 'sinatra'
require 'json'
$LOAD_PATH << 'lib'
require 'go_watchdog_helper'
require 'impatient_watchdog'
require 'time_ago'

class GoWatchdogApp < Sinatra::Base
  include GoWatchdogHelper

  set :public_folder, File.dirname(__FILE__) + '/static'

  get '/' do
    erb :index
  end

  get '/time' do
    content_type :json
    { 'time' =>  TimeAgo::in_words(last_green_build_time),
      'mood' => ImpatientWatchdog.new(config).mood(:waiting_since => last_green_build_time) }.to_json
  end

end
