module TimeAgoInWords
  
  def minutes_ago(time)
    (now - time) / 60.0
  end
  
  def time_ago_in_words(time)
    minutes = minutes_ago(time)
    if minutes < 60.0
      "#{minutes.ceil} minutes"
    elsif (60..120).include?(minutes)
      "about an hour"
    else 
      "#{(minutes/60.0).floor} hours"
    end
  end
  
  def now
    Time.now
  end
  
end