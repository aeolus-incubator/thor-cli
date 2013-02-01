require 'aeolus/cli/formatting/machine_format'

describe Aeolus::Cli::Formatting::MachineFormat do

  let(:shell) { double('shell') }
  let(:format) { Aeolus::Cli::Formatting::MachineFormat.new(shell, ';') }

  context "printing a detail" do
    before do
      format.stub_chain("presenter_for.detail")
        .and_return([
                      ['title1', 'value1'],
                      ['title2', 'value2'],
                    ])
    end

    it "prints the data" do
      format.should_receive(:print).with("title1;value1").ordered
      format.should_receive(:print).with("title2;value2").ordered

      format.detail('some object')
    end
  end

  context "printing a list" do
    before do
      format.stub("presenters_for").and_return([
        double('first', :list_item => ['list', 'item']),
        double('second', :list_item => ['list2', 'item2']),
      ])
    end

    it "prints the data" do
      format.should_receive(:print_list)
            .with([
                    ['list', 'item'],
                    ['list2', 'item2'],
                  ], ';')

      format.list(['a', 'b'])
    end
  end

end
