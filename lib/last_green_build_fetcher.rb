require 'bundler'
Bundler.setup
require 'go_api_client'
require 'pstore'
require 'benchmark'

class LastGreenBuildFetcher
  
  def initialize(options)
    @options = options
    @stage = @options.delete(:stage_name)
    @cache = PStore.new(File.expand_path(File.join(File.dirname(__FILE__), '..', '.go_watchdog_cache')))
    @options.merge!(:latest_atom_entry_id => recall(:latest_atom_entry_id))
    if @options[:latest_atom_entry_id].nil? && ENV['QUIET'].nil?
      puts "Retrieving the feed for #{@options[:pipeline_name]}-#{@stage} for the first time.  This could take quite awhile for pipelines with lots of history."
    end
  end
  
  def fetch
    feed = nil
    ms = Benchmark.realtime do
      feed = GoApiClient.runs(@options)
    end
    puts "fetched pipeline runs in #{ms/1000}sec" unless ENV['QUIET']

    pipelines = feed[:pipelines]
    remember(:latest_atom_entry_id, feed[:latest_atom_entry_id])
    puts "Checking for last green run of #{@stage}. Latest event: #{feed[:latest_atom_entry_id]}" unless ENV['QUIET']

    pipelines.reverse.each do |pipeline|
      stage = pipeline.stages.find { |stage| stage.name == @stage }
      if stage && stage.result == 'Passed'
        return stage.completed_at.tap { |time| remember(:latest_green_build_time, time) }
      end
    end

    recall :latest_green_build_time
  end
  
  private

  def remember(key, value)
    @cache.transaction do
      @cache[key] = value
    end  
  end

  def recall(key)
    @cache.transaction(true) do
      @cache[key]
    end
  end
end
