require 'sinatra'
require 'json'

require_relative 'go_watchdog_helper'
require_relative 'impatient_watchdog'

class GoWatchdogApp < Sinatra::Base
  include GoWatchdogHelper

  set :root, File.join(__dir__, '..')
  set :public_folder, File.join(__dir__, '..', 'static')

  get '/' do
    erb :index
  end

  get '/time' do
    content_type :json
    { 'time' =>  last_green_build_time.iso8601,
      'mood' => ImpatientWatchdog.new(watchdog_config).mood(:waiting_since => last_green_build_time) }.to_json
  end

  private

  def watchdog_config
    WATCHDOG_CONFIG
  end

end
