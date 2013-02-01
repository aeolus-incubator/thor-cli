require 'aeolus/cli/formatting/presenter_sorter'

describe Aeolus::Cli::Formatting::PresenterSorter do

  def stub_fields(presenter, status, owner)
    presenter.stub(:field) do |param|
      # If I could get local variable by name without using eval, I would :)
      # Something like local_variable_get would be handy here.
      case param
      when :status
        status
      when :owner
        owner
      end
    end
  end

  let(:p1) { double('p1').tap { |p| stub_fields(p, 'stopped', 'alice') } }
  let(:p2) { double('p2').tap { |p| stub_fields(p, 'stopped', 'joe') } }
  let(:p3) { double('p3').tap { |p| stub_fields(p, 'running', 'alice') } }
  let(:p4) { double('p4').tap { |p| stub_fields(p, 'running', 'joe') } }

  let(:presenters) { [p4, p1, p3, p2] }
  let(:sorted_presenters) { [p1, p2, p3, p4] }
  let(:sort_by) { [[:status, :desc], [:owner, :asc]] }
  let(:sorter) { Aeolus::Cli::Formatting::PresenterSorter.new(presenters, sort_by) }

  context "#sorted_data" do
    subject { sorter.sorted_presenters }

    it { should == sorted_presenters }
  end
end
