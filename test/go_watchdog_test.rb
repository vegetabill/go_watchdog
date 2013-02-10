$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'test/unit'
require 'mocha/setup'
require 'go_watchdog'
require 'last_green_build_fetcher'

class GoWatchdogTest < Test::Unit::TestCase

  def test_knows_if_there_are_any_updates
    with_stub_fetcher_that_returns(Time.now) do
      osito = GoWatchdog.new(simple_config)
      assert osito.any_updates?
    end
  end

  def test_if_fetcher_returns_false_knows_there_are_no_updates
    with_stub_fetcher_that_returns(false) do
      osito = GoWatchdog.new(simple_config)
      assert_equal false, osito.any_updates?
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
      'mood_cutoff_in_minutes' => 
      {
        'enraged' => 60,
        'angry' => 30,
        'neutral' => 10
      }
    }
  end

  def with_stub_fetcher_that_returns(return_value)
    LastGreenBuildFetcher.any_instance.stubs(:fetch).returns(return_value)
    yield
  end

end
