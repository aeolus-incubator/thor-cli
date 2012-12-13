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
    # if user specified a location by environment variable, load it
    if ENV.has_key?("AEOLUS_CLI_CONF") and !ENV["AEOLUS_CLI_CONF"].empty?
      require ::File.expand_path(ENV["AEOLUS_CLI_CONF"],  __FILE__)
    # else check the usual config file locations
    else
      ["~/.aeolus-cli.rb","/etc/aeolus-cli.rb"].each do |fname|
        if is_file?(fname)
          require ::File.expand_path(fname,  __FILE__)
          break
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
