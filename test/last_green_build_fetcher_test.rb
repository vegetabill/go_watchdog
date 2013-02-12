$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'test/unit'
require 'mocha/setup'
require 'go_watchdog'
require 'last_green_build_fetcher'
require 'ostruct'

class LastGreenBuilderFetcherTest < Test::Unit::TestCase
  
  def test_fetching_finds_most_recent_passing_stage
    mock_pipeline = OpenStruct.new
    mock_stage1 = OpenStruct.new(:name => 'unit', :result => 'Passed', :completed_at => Time.parse('2013-02-11 14:10:00'))
    mock_stage2 = OpenStruct.new(:name => 'acceptance', :result => 'Passed', :completed_at => Time.parse('2013-02-11 14:19:00'))
    mock_pipeline.stages = [mock_stage1, mock_stage2]
    with_go_api_client_returning({:pipelines => [mock_pipeline], :latest_atom_entry_id => 'ignore'}) do
      fetcher = LastGreenBuildFetcher.new({:stage_name => 'acceptance'})
      t = fetcher.fetch
      assert_equal Time.parse('2013-02-11 14:19:00'), t
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