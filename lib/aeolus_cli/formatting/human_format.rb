require 'aeolus_cli/formatting/format'
require 'aeolus_cli/formatting/human_presenter_filter'
require 'aeolus_cli/formatting/provider_presenter'

module AeolusCli::Formatting
  # Format that prints objects in a human-friendly way.
  class HumanFormat < Format
    def initialize(shell)
      super(shell)

      register("AeolusCli::Model::Provider", ProviderPresenter)
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

      table = []

      # table header
      table << presenter_for(objects.first, fields_override).list_table_header

      objects.each do |object|
        table << presenter_for(object, fields_override).list_item
      end

      print_table(table)
    end

    def presenter_for(object, fields_override = nil)
      HumanPresenterFilter.new(super(object, fields_override))
    end
  end
end
