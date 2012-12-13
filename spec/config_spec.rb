require 'aeolus_cli/main'
#require 'aeolus_cli/common_cli'

describe "loading configuration-file by environment variable" do

  before do
    config_file = File.expand_path("tmp/aeolus-cli-config-rspec.rb")
    ENV['AEOLUS_CLI_CONF'] = config_file
    File.open(config_file, 'w') do |f|
      f.puts 'AeolusCli::Model::Base.site = "http://localhost:3123/api"'
      f.puts 'AeolusCli::Model::Base.user = "some-local-user"'
      f.puts 'AeolusCli::Model::Base.password = "uncrackable-password"'
      f.puts 'ActiveResource::Base.logger = Logger.new(STDOUT)'
      f.puts 'ActiveResource::Base.logger.level = Logger::INFO'
    end
    #AeolusCli::Provider.start
  end

  describe 'with no commad line overrides' do
    before do
      AeolusCli::Provider.start
    end
    it 'the configuration file should be loaded' do
      AeolusCli::Model::Base.site.to_s.should == 'http://localhost:3123/api'
      AeolusCli::Model::Base.user.to_s.should == 'some-local-user'
      AeolusCli::Model::Base.password.to_s.should == 'uncrackable-password'
      ActiveResource::Base.logger.level.should == Logger::INFO
    end
  end

  describe 'with --username override' do
    before do
      AeolusCli::Provider.start(["--username", "override-user"])
    end
    it 'the configuration file should be loaded' do
      AeolusCli::Model::Base.password.to_s.should == 'uncrackable-password'
    end
  end

  describe 'with --password override' do
    before do
      AeolusCli::Provider.start(["--password", "override-password"])
    end
    it 'the configuration file should be loaded' do
      AeolusCli::Model::Base.password.to_s.should == 'override-password'
    end
  end

  describe 'with --conductor-url override' do
    before do
      AeolusCli::Provider.start(["--conductor-url",
                                 "https://localhost/conductor/api"])
    end
    it 'the configuration file should be loaded' do
      AeolusCli::Model::Base.site.to_s.should == 'https://localhost/conductor/api'
    end
  end
end
