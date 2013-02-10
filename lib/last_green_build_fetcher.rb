require 'bundler'
Bundler.setup
require 'go_api_client'

class LastGreenBuildFetcher
  
  @@latest_atom_entry_id = nil

  def initialize(options)
    @stage = options.delete(:stage_name)
    options.merge!(:latest_atom_entry_id => @@latest_atom_entry_id) if @@latest_atom_entry_id
    feed = GoApiClient.runs(options)
    @pipelines = feed[:pipelines]
    @@latest_atom_entry_id = feed[:latest_atom_entry_id]
    puts "Checking for last green run of #{@stage}. Latest event: #{@@latest_atom_entry_id}" if ENV['DEBUG']
  end
  
  def fetch
    return nil if no_builds_since_last_checked?
    @pipelines.reverse.each do |pipeline|
      stage = pipeline.stages.find { |stage| stage.name == @stage }
      return stage.completed_at if stage && stage.result == 'Passed'
    end
    nil
  end
  
  private

  def no_builds_since_last_checked?
    @pipelines.empty?
  end

end
