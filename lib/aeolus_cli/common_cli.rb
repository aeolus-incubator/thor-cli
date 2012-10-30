#require 'rest_client'
require 'active_resource'
require 'active_support'
require 'nokogiri'
require 'logger'
require 'thor'
require 'aeolus_cli/model/base'
require 'aeolus_cli/model/provider_type'

class AeolusCli::CommonCli < Thor
  class_option :conductor_url, :type => :string
  class_option :username, :type => :string
  class_option :password, :type => :string

  def initialize(*args)
    super
    configure_conductor_connection(options)
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

  def configure_conductor_connection(options)
    @config = nil
    # check default config file locations 
    ["~/.aeolus-cli","/etc/aeolus-cli"].each do |fname|
      if is_file?(fname)
        @config = YAML::load(File.open(File.expand_path(fname)))
        break
      end
    end
    if @config != nil
      configure_active_resource
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

  # Given an array of attribute key name and pretty name pairs
  # and an active resource collection, print the output.
  def print_table( keys_and_pretty_names, ares_collection)
    t = Array.new
    row = Array.new
    keys_and_pretty_names.each do |key, pretty_name|
      row.push pretty_name
    end
    t.push row
    ares_collection.each do |ares|
      row = Array.new
      keys_and_pretty_names.each do |key, pretty_name|
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

  # The two methods below which are related to loading
  # site/username/password from a config file such as ~/.aeolus-cli
  # are borrowed from original aeolus-cli project
  def configure_active_resource
    if @config.has_key?(:conductor)
      [:url, :password, :username].each do |key|
        raise AeolusCli::ConfigError.new(
         "Error in configuration file: #{key} is missing") \
          unless @config[:conductor].has_key?(key)
      end
      AeolusCli::Model::Base.site = @config[:conductor][:url]
      AeolusCli::Model::Base.user = @config[:conductor][:username]
      AeolusCli::Model::Base.password = @config[:conductor][:password]
    else
      raise AeolusCli::ConfigError.new("Error in configuration file")
    end
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
