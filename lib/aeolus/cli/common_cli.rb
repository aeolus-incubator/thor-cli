require 'active_resource'
require 'thor'
require 'aeolus/cli/config'
require 'aeolus/cli/formatting'
require 'aeolus/client/base'
require 'aeolus/client/provider_type'

class Aeolus::Cli::CommonCli < Thor
  class_option :conductor_url, :type => :string
  class_option :username, :type => :string
  class_option :password, :type => :string
  class_option :format, :type => :string,
    :desc => "FORMAT can be 'human' or 'machine'"

  attr_accessor :output_format
  attr_accessor :config

  def initialize(*args)
    super
    load_config(options)
    set_output_format(options)
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

    def method_options_for_resource_list
      method_option_fields
      method_option_sort_by
    end

    def method_option_fields
      method_option :fields,
        :type => :string,
        :desc => 'Fields (attributes) to print in the listing'
    end

    def method_option_sort_by
      method_option :sort_by,
        :type => :string,
        :desc => 'Sort output by value of field(s)'
    end
  end

  def load_config(options)
    @config = Aeolus::Cli::Config.load_config(options)
    @config.push
  end

  # Set output format (human vs. machine)
  def set_output_format(options)
    @output_format = Aeolus::Cli::Formatting.create_format(shell, options)
  end

  # Transforms e.g. 'name,status' into [:name, :status]
  def resource_fields(fields_option)
    return nil unless fields_option
    if fields_option == ''
      raise Thor::MalformattedArgumentError.new("Option 'fields' cannot be empty.")
    end
    fields_option.split(',').map { |option| option.to_sym }
  end

  def resource_sort_by(sort_by_option)
    return nil unless sort_by_option
    if sort_by_option == ''
      raise Thor::MalformattedArgumentError.new("Option 'sort_by' cannot be empty.")
    end
    sort_by_option.split(',').map { |option| parse_one_sort_by_option(option) }
  end

  def parse_one_sort_by_option(option)
    case option[-1]
    when '+'
      [option[0..-2].to_sym, :asc]
    when '-'
      [option[0..-2].to_sym, :desc]
    else
      [option.to_sym, :asc]
    end
  end

  def provider_type(type_s)
    # we need to hit the API to get the map of provider_type.name =>
    # provider_type.id, so make sure we only do this once.
    @provider_type_hash ||= provider_type_hash
    @provider_type_hash[type_s]
  end

  def provider_type_hash
    deltacloud_driver_to_provider_type = Hash.new
    provider_types = Aeolus::Client::ProviderType.all
    if provider_types.size == 0
      raise "Retrieved zero provider types from Conductor"
    end
    provider_types.each do |pt|
      deltacloud_driver_to_provider_type[pt.deltacloud_driver] = pt
    end
    deltacloud_driver_to_provider_type
  end

end
