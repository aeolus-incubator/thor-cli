require 'active_support/core_ext/hash/deep_merge'
require 'aeolus/cli/errors'

# push_config requirements
require 'aeolus/client/base'
require 'logger'

module Aeolus::Cli
  class Config < Hash
    DEFAULT_CONFIG_FILE =
      File.expand_path(File.join(File.dirname(__FILE__),
                                 '..', '..', '..', # thor-cli gem dir
                                 'templates', 'default_config.yml'))

    def push
      ActiveResource::Base.logger = case self[:logging][:file]
                                    when /\Astdout\Z/i
                                      Logger.new(STDOUT)
                                    when /\Astderr\Z/i
                                      Logger.new(STDERR)
                                    else
                                      Logger.new(File.expand_path(self[:logging][:file]))
                                    end
      ActiveResource::Base.logger.level = Logger.const_get(self[:logging][:level].upcase)

      Aeolus::Client::Base.site = self[:conductor][:url]
      Aeolus::Client::Base.user = self[:conductor][:username]
      Aeolus::Client::Base.password = self[:conductor][:password]
    end

    def validate!
      error_class = Aeolus::Cli::ConfigError
      required_attributes = {
        '--conductor-url' => self[:conductor][:url],
        '--username'      => self[:conductor][:username],
        '--password'      => self[:conductor][:password],
      }
      required_attributes.each do |name, value|
        raise error_class, "Setting #{name} is required." unless value
      end
      true
    end


    class << self
      def new_from_hash(hash)
        self.new.merge!(hash)
      end

      def load_config(options)
        config_hash = {}
        config_hash.deep_merge!(config_file_hash(DEFAULT_CONFIG_FILE))
        config_hash.deep_merge!(config_file_hash(config_file_to_load)) if config_file_to_load
        config_hash.deep_merge!(options_hash(options))
        self.new_from_hash(config_hash)
      end

      private

      def config_file_to_load
        env_config = ENV['AEOLUS_CLI_CONF']
        home_config = "#{ENV['HOME']}/.aeolus-cli"
        global_config = "/etc/aeolus-cli"

        return env_config    if env_config
        return home_config   if File.exists?(home_config)
        return global_config if File.exists?(global_config)
        nil
      end

      def config_file_hash(file_name)
        unless File.file?(file_name)
          raise Aeolus::Cli::ConfigError.new("Config file '#{file_name}' does not exist.")
        end

        YAML::load(File.read(File.expand_path(file_name)))
      end

      def options_hash(options)
        hash = {}
        hash.deep_merge!({ :conductor => { :url => options[:conductor_url] } }) if options[:conductor_url]
        hash.deep_merge!({ :conductor => { :username => options[:username] } }) if options[:username]
        hash.deep_merge!({ :conductor => { :password => options[:password] } }) if options[:password]
        hash
      end
    end
  end

end
