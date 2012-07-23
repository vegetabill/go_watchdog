require 'sinatra'
require 'net/http'
require 'net/https'

raise "Must supply Go password in env variable GO_PASSWORD" unless ENV['GO_PASSWORD']
set :public_folder, File.dirname(__FILE__) + '/static'

class GoWatchdog
  
  def time_since_last_green_build
    time_ago_in_words(last_green_build_time)
  end
  
  def last_green_build_time
    value = pipeline_timestamp.strip.split("\n")[1]
    DateTime.parse(value).to_time
  end
  
  def minutes_ago(time)
    (Time.now - time) / 60.0
  end
  
  def time_ago_in_words(time)
    minutes = minutes_ago(time)
    if minutes  < 60.0
      "#{minutes.ceil} minutes ago"
    elsif (60..120).include?(minutes)
      "about an hour"
    else 
      "#{(minutes/60.0).floor} hours"
    end
  end
  
  def mood
    minutes = minutes_ago(last_green_build_time)
    return "enraged" if minutes > (36*60)
    return "angry" if minutes > (24*60)
    return "neutral" if minutes > 120
    "happy"
  end
  
  def pipeline_timestamp
    @body ||= begin
      http = Net::HTTP.new('go01.thoughtworks.com',443)
      req = Net::HTTP::Get.new('/go/properties/GreenInstallers/latest/defaultStage/latest/defaultJob/cruise_timestamp_06_completed')
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req.basic_auth 'mingle_builder2', ENV['GO_PASSWORD']
      response = http.request(req)
      @body = response.body
    end
  end
  
end

get '/' do
    erb :index, :locals => { :watchdog => GoWatchdog.new }
end

get '/time' do
  osito = GoWatchdog.new
<<-JAVASCRIPT
 $("#time_since_last_green_build").text('#{osito.time_since_last_green_build}');
 $('body').removeClass('happy neutral angry');
 $('body').addClass('#{osito.mood}');
JAVASCRIPT
end

class Ago
  def initialize(minutes)
    @minutes = minutes
  end
  
  def ago
    Time.now - @minutes * 60
  end
end

class Fixnum
  def minutes
    Ago.new(self)
  end
end
