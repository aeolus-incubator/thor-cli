require 'aeolus_cli/formatting/format'

describe AeolusCli::Formatting::Format do

  let(:shell) { double('shell') }
  let(:format) { AeolusCli::Formatting::Format.new(shell) }

  context "with a presenter" do
    let(:presenter) { double('presenter') }
    let(:presenter_class) { double('presenter_class', :new => presenter) }

    before do
      format.register("String", presenter_class)
    end

    context "looking up for non-registered class" do
      subject { format.presenter_for(10.0) }

      it do
        expect { subject }
          .to raise_error AeolusCli::Formatting::PresenterMissingError
      end
    end

    context "looking up for a registered class" do
      subject { format.presenter_for('awesome', [:field1, :field2]) }

      it "constructs pesenter class using passed params" do
        presenter_class.should_receive(:new)
          .with('awesome', [:field1, :field2]).and_return(presenter)

        subject.should == presenter
      end
    end

    context "#presenters_for" do
      let(:sorted_presenters) { double('sorted_presenters') }
      let(:sorter) { double('sorter', :sorted_presenters => sorted_presenters) }
      before do
        AeolusCli::Formatting::PresenterSorter
          .should_receive(:new)
          .with([presenter, presenter], [:name, :asc])
          .and_return(sorter)
      end

      subject { format.presenters_for(['one', 'two'], nil, [:name, :asc]) }
      it { should == sorted_presenters }
    end
  end

  context "printing methods" do
    let(:data) do
      [
        ['1', 'first', 'A'],
        ['21', 'second', 'B'],
      ]
    end

    context "printing a line" do
      it "calls shell.say" do
        shell.should_receive(:say).with("passed param", nil, true)
        format.print("passed param")
      end
    end

    context "printing a table" do
      it "calls shell.print_table with correct params" do
        shell.should_receive(:print_table).with(data)
        format.print_table(data)
      end
    end

    context "printing a list" do
      it "calls shell.say with correct params" do
        shell.should_receive(:say).with("1;first;A", nil, true).ordered
        shell.should_receive(:say).with("21;second;B", nil, true).ordered
        format.print_list(data, ';')
      end
    end
  end

end
