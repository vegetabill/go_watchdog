$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'test/unit'
require 'mocha/setup'
require 'go_watchdog'
require 'last_green_build_fetcher'
require 'ostruct'

class LastGreenBuilderFetcherTest < Test::Unit::TestCase
  
  def test_fetching_finds_most_recent_passing_stage
    mock_pipeline1 = OpenStruct.new
      passing_units = OpenStruct.new(:name => 'unit', :result => 'Passed', :completed_at => Time.parse('2013-02-10 11:40:00'))
      failing_acceptance = OpenStruct.new(:name => 'acceptance', :result => 'Failed', :completed_at => Time.parse('2013-02-10 11:45:00'))
    mock_pipeline1.stages = [passing_units, failing_acceptance]
    
    mock_pipeline2 = OpenStruct.new
      passing_units = OpenStruct.new(:name => 'unit', :result => 'Passed', :completed_at => Time.parse('2013-02-11 14:10:00'))
      passing_acceptance = OpenStruct.new(:name => 'acceptance', :result => 'Passed', :completed_at => Time.parse('2013-02-11 14:19:00'))
    mock_pipeline2.stages = [passing_units, passing_acceptance]
    
    with_go_api_client_returning({:pipelines => [mock_pipeline1, mock_pipeline2].reverse, :latest_atom_entry_id => 'ignore'}) do
      fetcher = LastGreenBuildFetcher.new({:stage_name => 'acceptance'})
      last_green_build_time = fetcher.fetch
      assert_equal passing_acceptance.completed_at, last_green_build_time
    end
  end

  def test_fetching_sets_latest_atom_entry_id
    with_go_api_client_returning({:pipelines => [], :latest_atom_entry_id => 'ABC123'}) do
      fetcher = LastGreenBuildFetcher.new({})
      fetcher.fetch
      assert_equal 'ABC123', LastGreenBuildFetcher.latest_atom_entry_id
    end
  end
  
  def test_fetching_empty_pipelines_returns_false
    with_go_api_client_returning({:pipelines => [], :latest_atom_entry_id => ''}) do
      fetcher = LastGreenBuildFetcher.new({})
      assert_equal false, fetcher.fetch
    end
  end

  def self.mock_return_value
    @@mock_return_value
  end
  
  private
  
  def with_go_api_client_returning(return_value)
    @@mock_return_value = return_value
    GoApiClient.module_eval do
      def self.runs(options)
        LastGreenBuilderFetcherTest.mock_return_value
      end
    end
    yield
  ensure
    @@mock_return_value = nil
  end

end