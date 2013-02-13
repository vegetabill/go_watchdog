$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'test/unit'
require 'mocha/setup'
require 'impatient_watchdog'
require 'last_green_build_fetcher'

class ImpatientWatchdogTest < Test::Unit::TestCase

  def setup
    @osito = ImpatientWatchdog.new(simple_config)
  end

  def test_mood_when_below_neutral_cutoff_is_happy
    assert_equal 'happy', @osito.mood(:waiting_since => (Time.now - 30))
  end

  def test_mood_when_below_angry_cutoff_is_neutral
    assert_equal 'neutral', @osito.mood(:waiting_since => (Time.now - 120))
  end

  def test_mood_when_below_enraged_cutoff_is_angry
    assert_equal 'angry', @osito.mood(:waiting_since => (Time.now - 330))
  end

  def test_mood_when_above_enraged_cutoff_is_enraged
    assert_equal 'enraged', @osito.mood(:waiting_since => (Time.now - 601))
  end


  private 

  def simple_config
    {
      'mood_cutoffs_in_minutes' => 
      {
        'enraged' => 10,
        'angry' => 5,
        'neutral' => 1
      }
    }
  end

end
