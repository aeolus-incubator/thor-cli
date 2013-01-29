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
      format.stub("presenters_for").and_return([
        double('first', :list_item => ['list', 'item'], :list_table_header => ['table', 'header']),
        double('second', :list_item => ['list2', 'item2']),
      ])
    end

    it "prints the data" do
      format.should_receive(:print_table).with([
                                                 ["table", "header"],
                                                 ["list", "item"],
                                                 ["list2", "item2"],
                                               ])

      format.list(['a', 'b'])
    end
  end

end
