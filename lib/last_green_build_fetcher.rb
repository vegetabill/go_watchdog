require 'bundler'
Bundler.setup
require 'go_api_client'

class LastGreenBuildFetcher
  
  @@latest_atom_entry_id = nil

  def self.latest_atom_entry_id
    @@latest_atom_entry_id
  end

  def initialize(options)
    @options = options
    @stage = @options.delete(:stage_name)
    @options.merge!(:latest_atom_entry_id => recall_latest_atom_entry_id(@options))
    if @options[:latest_atom_entry_id].nil? && ENV['QUIET'].nil?
      puts "Retrieving the feed for #{@options[:pipeline_name]}-#{@stage} for the first time.  This could take quite awhile for pipelines with lots of history."
    end
  end
  
  def fetch
    feed = GoApiClient.runs(@options)

    pipelines = feed[:pipelines]
    remember_latest_atom_entry_id(feed[:latest_atom_entry_id])
    puts "Checking for last green run of #{@stage}. Latest event: #{@@latest_atom_entry_id}" if ENV['DEBUG']

    pipelines.reverse.each do |pipeline|
      stage = pipeline.stages.find { |stage| stage.name == @stage }
      return stage.completed_at if stage && stage.result == 'Passed'
    end

    false
  end
  
  private
  
  def recall_latest_atom_entry_id(options)
    return File.read(cache_filename) if File.exists?(cache_filename)
    @@latest_atom_entry_id
  end
  
  def remember_latest_atom_entry_id(latest_atom_entry_id)
    @@latest_atom_entry_id = latest_atom_entry_id
    File.open(cache_filename, 'w') { |file| file.write(latest_atom_entry_id) }
  end
  
  def cache_filename
    File.expand_path(File.join(File.dirname(__FILE__), '.latest_atom_entry_id'))
  end
  
end
