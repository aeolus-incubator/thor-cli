require 'aeolus_cli/formatting/errors'
require 'aeolus_cli/formatting/presenter_sorter'

module AeolusCli::Formatting
  # This class (or more precisely, classes that inherit from this one) can
  # format various objects for printing. Formatting is done via presenters.
  # Presenter classes can be registered with the Format to indicate which
  # presenters should be used for which objects.
  class Format
    def initialize(shell)
      @shell = shell
      @presenters = {}
    end

    # Prints a detail of an object.
    def detail(object, fields_override = nil)
      raise NotImplementedError
    end

    # Prints a list of objects.
    def list(object_array, fields_override = nil, sort_by = nil)
      raise NotImplementedError
    end

    # Gets a presenter that can be used to print given object. Raises an error
    # if there's no presenter registered for this object's type.
    def presenter_for(object, fields_override = nil)
      presenter_class = @presenters[object.class.name]
      raise PresenterMissingError.new(self, object) unless presenter_class

      presenter_class.new(object, fields_override)
    end

    # Gets an array of presenters for array of objects. The array sorted
    # according to the sort_by parameter. See PresenterSorter for details how
    # sorting works.
    def presenters_for(objects, fields_override = nil, sort_by = nil)
      presenters = objects.map { |object| presenter_for(object, fields_override) }
      PresenterSorter.new(presenters, sort_by).sorted_presenters
    end

    # Registers a presenter to use for objects of some type.
    def register(class_name, presenter)
      @presenters[class_name] = presenter
    end

    # Prints a simple line
    def print(line)
      @shell.say(line, nil, true)
    end

    # Prints a table (an array of rows where each row is an array of cells).
    def print_table(table)
      @shell.print_table(table)
    end

    # Prints a list (an array of items where each item is an array of fields).
    # Fields in an item are separated by a given separator.
    def print_list(list_items, separator)
      list_items.each do |item|
        print(item.join(separator))
      end
    end
  end
end
