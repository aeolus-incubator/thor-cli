require 'aeolus_cli/formatting/machine_format'

describe AeolusCli::Formatting::MachineFormat do

  let(:shell) { double('shell') }
  let(:format) { AeolusCli::Formatting::MachineFormat.new(shell, ';') }

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
      format.stub_chain("presenter_for.list_item")
        .and_return(['list', 'item'])
    end

    it "prints the data" do
      format.should_receive(:print).with("list;item").twice

      format.list(['a', 'b'])
    end
  end

end
