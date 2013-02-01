module Aeolus::Cli::Formatting
  # Sorts array of Presenter objects by their field values.
  class PresenterSorter
    # Parameter sort_by is expected like e.g. [[:status, :desc], [:name, :asc]],
    # which means "sort by status descending, and if status is the same, sort
    # by name ascending".
    def initialize(presenters, sort_by)
      @presenters = presenters
      @sort_by = sort_by
    end

    def sorted_presenters
      return @presenters if @sort_by.nil? || @sort_by.empty?
      @presenters.sort do |presenter1, presenter2|
        compare(presenter1, presenter2, @sort_by)
      end
    end

    private

    def compare(presenter1, presenter2, sort_by)
      return 0 if sort_by.empty?
      next_sort_by = sort_by.dup
      field_name, direction = next_sort_by.shift

      current_comparison =
        presenter1.send(:field, field_name) <=> presenter2.send(:field, field_name)

      if current_comparison == 0
        compare(presenter1, presenter2, next_sort_by)
      else
        direction == :desc ? -current_comparison : current_comparison
      end
    end
  end
end
