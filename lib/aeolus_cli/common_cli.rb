require 'active_resource'
require 'thor'
require 'aeolus_cli/model/base'
require 'aeolus_cli/model/provider_type'

class AeolusCli::CommonCli < Thor
  class_option :conductor_url, :type => :string
  class_option :username, :type => :string
  class_option :password, :type => :string

  def initialize(*args)
    super
    load_aeolus_config(options)
  end

  # abstract-y methods
  desc "list", "List all"
  def list(*args)
    self.shell.say "Implement me."
  end

  desc "add", "Add one"
  def add(*args)
    self.shell.say "Implement me."
  end

  protected

  class << self
    def banner(task, namespace = nil, subcommand = false)
      "#{basename} #{task.formatted_usage(self, false, true)}"

      # Above line Overrides the line from Thor, below, so the printed usage
      # line is correct, e.g. for "aeolus provider help list" we get
      #   Usage:
      #     aeolus provider list
      # instead of
      #   Usage:
      #     aeolus list
      #"#{basename} #{task.formatted_usage(self, $thor_runner, subcommand)}"
    end
  end

  def load_aeolus_config(options)
    # set logging defaults
    ActiveResource::Base.logger = Logger.new(STDOUT)
    ActiveResource::Base.logger.level = Logger::WARN

    # locate the config file if one exists
    config_fname = nil
    if ENV.has_key?("AEOLUS_CLI_CONF")
      config_fname = ENV["AEOLUS_CLI_CONF"]
      if !is_file?(config_fname)
        raise AeolusCli::ConfigError.new(
          "environment variable AEOLUS_CLI_CONF with value "+
          "'#{ ENV['AEOLUS_CLI_CONF']}' does not point to an existing file")
      end
    else
      ["~/.aeolus-cli","/etc/aeolus-cli"].each do |fname|
        if is_file?(fname)
          config_fname = fname
          break
        end
      end
    end

    # load the config file if we have one
    if config_fname != nil
      @config = YAML::load(File.open(File.expand_path(config_fname)))
      if @config.has_key?(:conductor)
        [:url, :password, :username].each do |key|
          raise AeolusCli::ConfigError.new \
          ("Error in configuration file: #{key} is missing"
           ) unless @config[:conductor].has_key?(key)
        end
        AeolusCli::Model::Base.site = @config[:conductor][:url]
        AeolusCli::Model::Base.user = @config[:conductor][:username]
        AeolusCli::Model::Base.password = @config[:conductor][:password]
      else
        raise AeolusCli::ConfigError.new("Error in configuration file")
      end
      if @config.has_key?(:logging)
        if  @config[:logging].has_key?(:logfile)
          if @config[:logging][:logfile].upcase == "STDOUT"
            ActiveResource::Base.logger = Logger.new(STDOUT)
          elsif @config[:logging][:logfile].upcase == "STDERR"
            ActiveResource::Base.logger = Logger.new(STDERR)
          else
            ActiveResource::Base.logger =
              Logger.new(@config[:logging][:logfile])
          end
        end
        if  @config[:logging].has_key?(:level)
          log_level = @config[:logging][:level]
          if ! ['DEBUG','WARN','INFO','ERROR','FATAL'].include?(log_level)
            raise AeolusCli::ConfigError.new \
            ("log level specified in configuration #{log_level}, is not valid."+
             ".  shoud be one of DEBUG, WARN, INFO, ERROR or FATAL")
          else
            ActiveResource::Base.logger.level = eval("Logger::#{log_level}")
          end
        end
      end
    end
    # allow overrides from command line
    if options[:conductor_url]
      AeolusCli::Model::Base.site = options[:conductor_url]
    end
    if options[:username]
      AeolusCli::Model::Base.user = options[:username]
    end
    if options[:password]
      AeolusCli::Model::Base.password = options[:password]
    end
  end

  # Given a hash of attribute key name to pretty name and an active
  # resource collection, print the output.
  def print_table( keys_to_pretty_names, ares_collection)
    t = Array.new

    # Add the first row, the column headings
    t.push keys_to_pretty_names.values

    # Add the data
    ares_collection.each do |ares|
      row = Array.new
      keys_to_pretty_names.keys.each do |key|
        row.push ares.attributes[key].to_s
      end
      t.push row
    end

    # use Thor's shell.print_table()
    self.shell.print_table(t)
  end

  def provider_type(type_s)
    # we need to hit the API to get the map of provider_type.name =>
    # provider_type.id, so make sure we only do this once.
    @provider_type_hash ||= provider_type_hash
    @provider_type_hash[type_s]
  end

  def provider_type_hash
    deltacloud_driver_to_provider_type = Hash.new
    provider_types = AeolusCli::Model::ProviderType.all
    if provider_types.size == 0
      raise "Retrieved zero provider types from Conductor"
    end
    provider_types.each do |pt|
      deltacloud_driver_to_provider_type[pt.deltacloud_driver] = pt
    end
    deltacloud_driver_to_provider_type
  end

  # TODO: Consider ripping all this file-related stuff into a module or
  # class for better encapsulation and testability
  def is_file?(path)
    full_path = File.expand_path(path)
    if File.exist?(full_path) && !File.directory?(full_path)
      return true
    end
    false
  end

end
