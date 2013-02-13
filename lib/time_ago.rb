module TimeAgo
  
  def self.in_words(time)
    minutes = TimeAgo::in_minutes(time)
    if minutes < 60.0
      "#{minutes.ceil} minutes"
    elsif (60..120).include?(minutes)
      "about an hour"
    else 
      "#{(minutes/60.0).floor} hours"
    end
  end
  
  def self.in_minutes(time)
    (TimeAgo::now - time) / 60.0
  end
  
  def self.now
    Time.now
  end
  
end