require 'sinatra'
require 'net/http'
require 'net/https'
require 'base64'

class GoWatchdog  
  def time_since_last_green_build
    http = Net::HTTP.new('go01.thoughtworks.com',443)
    req = Net::HTTP::Get.new('/go/properties/GreenInstallers/latest/defaultStage/latest/defaultJob/cruise_timestamp_06_completed')
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req.basic_auth 'mingle_builder2', Base64.decode64(ENV['GO_PASSWORD'])
    response = http.request(req)
    doc = response.body
    value = doc.strip.split("\n")[1]
    last_green_build_time = DateTime.parse(value)
  end
end

set :public_folder, File.dirname(__FILE__) + '/static'

get '/' do
    erb :index, :locals => { :watchdog => GoWatchdog.new }
end

get '/time' do
  # GoWatchdog.new.time_since_last_green_build
  Time.now.to_s
end