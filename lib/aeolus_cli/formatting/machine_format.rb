require 'aeolus_cli/formatting/format'
require 'aeolus_cli/formatting/provider_presenter'
require 'aeolus_cli/formatting/provider_account_presenter'

module AeolusCli::Formatting
  # Format that prints objects in a machine-friendly way.
  class MachineFormat < Format
    def initialize(shell, separator = "\t")
      super(shell)
      @separator = separator

      register("AeolusCli::Model::Provider", ProviderPresenter)
      register("AeolusCli::Model::ProviderAccount", ProviderAccountPresenter)
    end

    def detail(object, fields_override = nil)
      presenter_for(object, fields_override).detail.each do |line|
        print(line.join(@separator))
      end
    end

    def list(objects, fields_override = nil, sort_by = nil)
      return if objects.empty?

      list = []
      objects.each do |object|
        list << presenter_for(object, fields_override).list_item
      end

      print_list(list, @separator)
    end
  end
end
