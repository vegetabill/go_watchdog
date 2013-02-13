require 'time_ago'

class ImpatientWatchdog
  
  MOODS = %w[happy neutral angry enraged]
  
  def initialize(config)
    @mood_cutoffs_in_minutes = config['mood_cutoffs_in_minutes']
  end
  
  def mood(options)
    wait_time = TimeAgo::in_minutes(options[:waiting_since])
    
    return "enraged" if wait_time > @mood_cutoffs_in_minutes['enraged']
    return "angry" if wait_time > @mood_cutoffs_in_minutes['angry']
    return "neutral" if wait_time > @mood_cutoffs_in_minutes['neutral']
    "happy"
  end
  
end