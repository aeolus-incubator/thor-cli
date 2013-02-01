module Aeolus::Cli::Formatting
  class PresenterMissingError < StandardError
    def initialize(format, object)
      super("Presenter not defined for #{object.class.name} in #{format.to_s}")
    end
  end

  class UnknownFieldError < StandardError
    def initialize(presenter, object, field)
      super("Field '#{field.to_s}' not defined for #{object.class.name} in #{presenter.class.to_s}")
    end
  end

  class UnknownFormatError < StandardError
    def initialize(format_name)
      super("Format '#{format_name}' is not defined.")
    end
  end
end
