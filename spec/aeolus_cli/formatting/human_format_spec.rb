require 'aeolus_cli/formatting/human_format'

describe AeolusCli::Formatting::HumanFormat do

  let(:shell) { double('shell') }
  let(:format) { AeolusCli::Formatting::HumanFormat.new(shell) }

  context "printing a detail" do
    before do
      format.stub_chain("presenter_for.detail")
        .and_return([
                      "first line",
                      ["table row", "1"],
                      ["table row", "2"],
                      "last line"
                    ])
    end

    it "prints the data" do
      format.should_receive(:print).with("first line").ordered
      format.should_receive(:print_table).with([
                                                 ["table row", "1"],
                                                 ["table row", "2"],
                                               ]).ordered
      format.should_receive(:print).with("last line").ordered

      format.detail('some object')
    end
  end

  context "printing a list" do
    before do
      format.stub_chain("presenter_for.list_item")
        .and_return(['list', 'item'])
      format.stub_chain("presenter_for.list_table_header")
        .and_return(['table', 'header'])
    end

    it "prints the data" do
      format.should_receive(:print_table).with([
                                                 ["table", "header"],
                                                 ["list", "item"],
                                                 ["list", "item"],
                                               ])

      format.list(['a', 'b'])
    end
  end

end
