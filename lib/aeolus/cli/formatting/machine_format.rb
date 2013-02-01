require 'aeolus/cli/formatting/format'
require 'aeolus/cli/formatting/provider_presenter'
require 'aeolus/cli/formatting/provider_account_presenter'

module Aeolus::Cli::Formatting
  # Format that prints objects in a machine-friendly way.
  class MachineFormat < Format
    def initialize(shell, separator = "\t")
      super(shell)
      @separator = separator

      register("Aeolus::Client::Provider", ProviderPresenter)
      register("Aeolus::Client::ProviderAccount", ProviderAccountPresenter)
    end

    def detail(object, fields_override = nil)
      presenter_for(object, fields_override).detail.each do |line|
        print(line.join(@separator))
      end
    end

    def list(objects, fields_override = nil, sort_by = nil)
      return if objects.empty?

      presenters = presenters_for(objects, fields_override, sort_by)

      list = []
      presenters.each do |presenter|
        list << presenter.list_item
      end

      print_list(list, @separator)
    end
  end
end
