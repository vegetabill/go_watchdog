# -*- coding: utf-8 -*-
require 'last_green_build_fetcher'
require File.join(File.dirname(__FILE__), 'time_ago_in_words')

class GoWatchdog
  include TimeAgoInWords
  
  def initialize(config)
    @config = config
    @pipeline_config = @config['pipeline']
  end
  
  def time_since_last_green_build
    time_ago_in_words(last_green_build_time)
  end
    
  def mood
    minutes = minutes_ago(last_green_build_time)
    mood_cutoffs_in_minutes = @config['mood_cutoffs_in_minutes']
    return "enraged" if minutes > mood_cutoffs_in_minutes['enraged']
    return "angry" if minutes > mood_cutoffs_in_minutes['angry']
    return "neutral" if minutes > mood_cutoffs_in_minutes['neutral']
    "happy"
  end  
  
  private

  def last_green_build_time
    @last_green_build_time ||= begin
      LastGreenBuildFetcher.new(:protocol => @pipeline_config['protocol'],
                                  :host => @pipeline_config['host'],
                                  :port => @pipeline_config['port'],
                                  :username => ENV['GO_USERNAME'],
                                  :password => ENV['GO_PASSWORD'],
                                  :pipeline_name => @pipeline_config['name'],
                                  :stage_name => @pipeline_config['stage']).fetch
    end
  end
  
end
