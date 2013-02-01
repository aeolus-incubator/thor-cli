require 'aeolus/cli/formatting/format'
require 'aeolus/cli/formatting/human_presenter_filter'
require 'aeolus/cli/formatting/provider_presenter'
require 'aeolus/cli/formatting/provider_account_presenter'

module Aeolus::Cli::Formatting
  # Format that prints objects in a human-friendly way.
  class HumanFormat < Format
    def initialize(shell)
      super(shell)

      register("Aeolus::Client::Provider", ProviderPresenter)
      register("Aeolus::Client::ProviderAccount", ProviderAccountPresenter)
    end

    def detail(object, fields_override = nil)
      buffered_table = []
      presenter_for(object, fields_override).detail.each do |line|
        case line
        when String
          print_table(buffered_table) unless buffered_table.empty?
          buffered_table = []
          print(line)
        when Array
          buffered_table << line
        end
      end

      print_table(buffered_table) unless buffered_table.empty?
    end

    def list(objects, fields_override = nil, sort_by = nil)
      return if objects.empty?

      presenters = presenters_for(objects, fields_override, sort_by)

      table = []
      # table header
      table << presenters.first.list_table_header

      presenters.each do |presenter|
        table << presenter.list_item
      end

      print_table(table)
    end

    def presenter_for(object, fields_override = nil)
      HumanPresenterFilter.new(super(object, fields_override))
    end
  end
end
