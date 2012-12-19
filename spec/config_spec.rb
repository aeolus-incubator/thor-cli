require 'aeolus_cli/main'

describe "loading configuration-file by environment variable" do

  before do
    config_file = File.expand_path("spec/sample/aeolus-cli-config")
    ENV['AEOLUS_CLI_CONF'] = config_file
  end

  describe 'with no command line overrides' do
    before do
      AeolusCli::Provider.start
    end
    it 'the configuration file should be loaded' do
      AeolusCli::Model::Base.site.to_s.should == 'http://example.com:3013/api'
      AeolusCli::Model::Base.user.to_s.should == 'master'
      AeolusCli::Model::Base.password.to_s.should == 'ofuniverse'
      ActiveResource::Base.logger.level.should == Logger::DEBUG
    end
  end

  describe 'with --username override' do
    before do
      AeolusCli::Provider.start(["--username", "override-user"])
    end
    it 'the configuration file should be loaded' do
      AeolusCli::Model::Base.user.to_s.should == 'override-user'
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
      AeolusCli::Model::Base.site.to_s.should ==
        'https://localhost/conductor/api'
    end
  end
end
