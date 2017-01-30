require 'yaml'
require 'ostruct'

module CodeCampaign::Rubocop::ConfigurationLoader
  DEFAULT_FILE_PATH = '.code_campaign.yml'

  def self.load
    @configuration = OpenStruct.new(YAML.load_file(DEFAULT_FILE_PATH)['code_campaign'])
  end
end
