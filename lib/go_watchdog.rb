require 'net/http'
require 'net/https'

class GoWatchdog
  
  def initialize(config)
    @config = config
    @pipeline_config = @config['pipeline']
  end
  
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
      "#{minutes.ceil} minutes"
    elsif (60..120).include?(minutes)
      "about an hour"
    else 
      "#{(minutes/60.0).floor} hours"
    end
  end
  
  def mood
    minutes = minutes_ago(last_green_build_time)
    mood_cutoffs_in_minutes = @config['mood_cutoffs_in_minutes']
    return "enraged" if minutes > mood_cutoffs_in_minutes['enraged']
    return "angry" if minutes > mood_cutoffs_in_minutes['angry']
    return "neutral" if minutes > mood_cutoffs_in_minutes['neutral']
    "happy"
  end
  
  def pipeline_timestamp
    @body ||= begin
      http_request
    end
  end
  
  def http_request
    http = Net::HTTP.new(@pipeline_config['host'], @pipeline_config['port'])
    url = "/go/properties/#{@pipeline_config['name']}/latest/#{@pipeline_config['stage']}/latest/#{@pipeline_config['job']}/cruise_timestamp_06_completed"
    req = Net::HTTP::Get.new(url)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req.basic_auth ENV['GO_USERNAME'], ENV['GO_PASSWORD']
    response = http.request(req)
    @body = response.body    
  end
end
