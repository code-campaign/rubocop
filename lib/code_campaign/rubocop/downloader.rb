require 'code_campaign/rubocop/configuration_loader'
require 'net/http'
require 'uri'
require 'json'

module CodeCampaign::Rubocop::Downloader
  ROOT_PATH = 'https://code-campaign.herokuapp.com'.freeze
  CONFIGURATION = CodeCampaign::Rubocop::ConfigurationLoader.load
  RUBOCOP_FILE = '.rubocop.yml'.freeze
  SPLIT_COMMENT = "\n# Code Campaign conventions\n".freeze

  def self.get
    uri = URI("#{ROOT_PATH}/#{CONFIGURATION.project_id}/ruby/configuration.json?access_token=#{CONFIGURATION.access_token}")
    response = Net::HTTP.get_response(uri)
    json_body = JSON.parse(response.body)
    remote_configuration = YAML.load json_body['configurations'].find { |configuration| configuration['linter'] == 'rubocop' }['content']

    rubocop_configuration =
      File.exist?(RUBOCOP_FILE) ? YAML.load_file(RUBOCOP_FILE) : {}

    File.open(RUBOCOP_FILE, 'w') do |file|
      file.write(rubocop_configuration.merge(remote_configuration).to_yaml)
    end
  end
end
