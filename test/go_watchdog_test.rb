$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'test/unit'
require 'mocha/setup'
require 'go_watchdog'
require 'last_green_build_fetcher'

class GoWatchdogTest < Test::Unit::TestCase

  def test_when_fetcher_returns_a_time_knows_if_there_are_any_updates
    with_stub_fetcher_that_returns(Time.now) do
      osito = GoWatchdog.new(simple_config)
      assert osito.any_updates?
    end
  end

  def test_when_fetcher_returns_false_knows_there_are_no_updates
    with_stub_fetcher_that_returns(false) do
      osito = GoWatchdog.new(simple_config)
      assert_equal false, osito.any_updates?
    end
  end

  def test_when_fetcher_returns_nil_knows_there_are_no_updates
    with_stub_fetcher_that_returns(nil) do
      osito = GoWatchdog.new(simple_config)
      assert_equal false, osito.any_updates?
    end
  end

  def test_time_since_last_green_build
    with_stub_fetcher_that_returns(Time.now - (60 * 75)) do
      osito = GoWatchdog.new(simple_config)
      assert_equal 'about an hour', osito.time_since_last_green_build
    end
  end

  def test_mood_when_below_neutral_cutoff_is_happy
    with_stub_fetcher_that_returns(Time.now - 30) do
      osito = GoWatchdog.new(simple_config)
      assert_equal 'happy', osito.mood
    end
  end

  def test_mood_when_below_angry_cutoff_is_neutral
    with_stub_fetcher_that_returns(Time.now - 120) do
      osito = GoWatchdog.new(simple_config)
      assert_equal 'neutral', osito.mood
    end
  end

  def test_mood_when_below_enraged_cutoff_is_angry
    with_stub_fetcher_that_returns(Time.now - 330) do
      osito = GoWatchdog.new(simple_config)
      assert_equal 'angry', osito.mood
    end
  end

  def test_mood_when_above_enraged_cutoff_is_enraged
    with_stub_fetcher_that_returns(Time.now - 601) do
      osito = GoWatchdog.new(simple_config)
      assert_equal 'enraged', osito.mood
    end
  end


  private 

  def simple_config
    {'pipeline' =>
      {
        'protocol' => 'http',
        'host' => 'go.example.com',
        'port' => '8153',
        'name' => 'build',
        'stage' => 'units'
      },
      'mood_cutoffs_in_minutes' => 
      {
        'enraged' => 10,
        'angry' => 5,
        'neutral' => 1
      }
    }
  end

  def with_stub_fetcher_that_returns(return_value)
    LastGreenBuildFetcher.any_instance.stubs(:fetch).returns(return_value)
    yield
  end

end
