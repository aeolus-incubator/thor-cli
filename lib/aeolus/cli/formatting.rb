require 'aeolus/cli/formatting/errors'

module Aeolus::Cli::Formatting
  class << self
    def create_format(shell, options)
      format_name = options[:format] || default_format

      load_format_class(format_name).new(shell)
    end

    private

    def default_format
      STDOUT.tty? ? 'human' : 'machine'
    end

    def load_format_class(format_name)
      class_name = format_name.gsub(/^(.)/) { |first_letter| first_letter.upcase } + "Format"
      begin
        require "aeolus/cli/formatting/#{format_name}_format"
        const_get(class_name)
      rescue LoadError, NameError
        raise UnknownFormatError.new(format_name)
      end
    end
  end
end
