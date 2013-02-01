require 'delegate'

module Aeolus::Cli::Formatting
  # Wrapper for presenters that alters/adds behavior for
  # more human-friendly output.
  class HumanPresenterFilter < SimpleDelegator
    def initialize(presenter)
      super(presenter)
    end

    def detail
      __getobj__.detail.map do |row|
        case row
        when String
          row
        when Array
          # humanize the first item on the row
          ["#{humanize(row.first)}:"] + row[1..-1]
        end
      end
    end

    def list_table_header
      list_item_fields.map { |field| humanize(field) }
    end

    private

    def humanize(lower_case_and_underscored_word)
      lower_case_and_underscored_word.to_s
        .gsub(/_/, ' ')
        .gsub(/^\w/) { $&.upcase }
    end
  end
end
