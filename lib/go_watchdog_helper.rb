require 'yaml'
require 'go_cd/last_green_build_fetcher'

module GoWatchdogHelper

  def last_green_build_time
    pipeline_config = watchdog_config['pipeline']
    auth_config = watchdog_config['credentials']
    fetcher = GoCD::LastGreenBuildFetcher.new(:protocol => pipeline_config['protocol'],
                                        :host => pipeline_config['host'],
                                        :port => pipeline_config['port'],
                                        :username => auth_config['username'],
                                        :password => auth_config['password'],
                                        :pipeline_name => pipeline_config['name'],
                                        :stage_name => pipeline_config['stage'])
    fetcher.fetch.tap do |green_build|
      return green_build.completed_at if green_build
    end
  end

end
