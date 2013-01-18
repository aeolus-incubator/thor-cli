require 'aeolus_cli/formatting/errors'

module AeolusCli::Formatting
  # Presenter class formats a single object for output. The generic Presenter
  # produces sort of machine-friendly output.
  class Presenter
    def initialize(object, fields_override = nil)
      @object = object
      @fields_override = fields_override
    end

    # Returns an array of lines or table rows. If an element is a string, it
    # should render a line. If an element is an array of strings, it should be
    # rendered as a table row.  Consecutive table rows form a table. (If you
    # put a string between two table rows, the string will work as a separator
    # between two independent tables.)
    def detail
      output = []
      detail_fields.each do |field_name|
        output << [field_name.to_s, field(field_name).to_s]
      end

      output
    end

    # Returns an array of strings (one table row). The list item method must
    # not produce multiline output.
    def list_item
      row = []
      list_item_fields.each do |field_name|
        row << field(field_name).to_s
      end

      row
    end

    def field(field_name)
      hidden = self.class.hidden_fields.include?(field_name)
      raise UnknownFieldError.new(self, @object, field_name) if hidden

      field_definition = self.class.field_definitions[field_name]
      if field_definition
        field_definition.call(@object)
      elsif @object.respond_to? field_name
        @object.send(field_name)
      else
        raise UnknownFieldError.new(self, @object, field_name)
      end
    end

    def detail_fields
      @fields_override || self.class.default_detail_fields
    end

    def list_item_fields
      @fields_override || self.class.default_list_item_fields
    end

    class << self
      def default_detail_fields(*fields)
        @default_detail_fields = fields unless fields.empty?
        @default_detail_fields
      end

      def default_list_item_fields(*fields)
        @default_list_item_fields = fields unless fields.empty?
        @default_list_item_fields
      end

      def field_definition(field_name, &field_proc)
        @field_definitions ||= {}
        @field_definitions[field_name.to_sym] = field_proc
      end

      def alias_field(new_name, old_name, hide_old_field = true)
        field_definition(new_name) { |object| object.send(old_name) }
        hidden_field(old_name) if hide_old_field
      end

      def field_definitions
        @field_definitions ||= {}
      end

      def hidden_field(field_name)
        @hidden_fields ||= []
        @hidden_fields << field_name.to_sym unless @hidden_fields.include?(field_name)
      end

      def hidden_fields
        @hidden_fields ||= []
      end
    end

  end
end
