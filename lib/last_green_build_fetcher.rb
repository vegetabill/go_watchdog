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
    if @@latest_atom_entry_id
      @options.merge!(:latest_atom_entry_id => @@latest_atom_entry_id)
    else
      puts "Retrieving the feed for #{@options[:pipeline_name]}-#{@stage} for the first time.  This could take quite awhile for pipelines with lots of history."
    end
  end
  
  def fetch
    feed = GoApiClient.runs(@options)
    
    pipelines = feed[:pipelines]
    @@latest_atom_entry_id = feed[:latest_atom_entry_id]
    puts "Checking for last green run of #{@stage}. Latest event: #{@@latest_atom_entry_id}" if ENV['DEBUG']
    pipelines.reverse.each do |pipeline|
      stage = pipeline.stages.find { |stage| stage.name == @stage }
      return stage.completed_at if stage && stage.result == 'Passed'
    end
    false
  end
  
end
