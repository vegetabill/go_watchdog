require 'bundler'
Bundler.setup
require 'go_api_client'
require 'pstore'

class LastGreenBuildFetcher
  
  def initialize(options)
    @options = options
    @stage = @options.delete(:stage_name)
    @cache = PStore.new(File.expand_path(File.join(File.dirname(__FILE__), '..', '.go_watchdog_cache')))
    @options.merge!(:latest_atom_entry_id => recall_latest_atom_entry_id)
    if @options[:latest_atom_entry_id].nil? && ENV['QUIET'].nil?
      puts "Retrieving the feed for #{@options[:pipeline_name]}-#{@stage} for the first time.  This could take quite awhile for pipelines with lots of history."
    end
  end
  
  def fetch
    feed = GoApiClient.runs(@options)

    pipelines = feed[:pipelines]
    remember_latest_atom_entry_id(feed[:latest_atom_entry_id])
    puts "Checking for last green run of #{@stage}. Latest event: #{feed[:latest_atom_entry_id]}" unless ENV['QUIET']

    pipelines.reverse.each do |pipeline|
      stage = pipeline.stages.find { |stage| stage.name == @stage }
      return stage.completed_at if stage && stage.result == 'Passed'
    end

    false
  end
  
  private

  def recall_latest_atom_entry_id
    @cache.transaction(true) do
      @cache['latest_atom_entry_id']
    end
  end
  
  def remember_latest_atom_entry_id(latest_atom_entry_id)
    @cache.transaction do
      @cache['latest_atom_entry_id'] = latest_atom_entry_id
    end
  end
  
end
