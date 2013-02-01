require 'aeolus/cli/formatting/human_presenter_filter'

describe Aeolus::Cli::Formatting::HumanPresenterFilter do
  let(:presenter) do
    bare_presenter = double('bare presenter')
    bare_presenter.stub('detail')
      .and_return([
                    ['name', 'Joe the Virtual Machine'],
                    ['status', 'crashed'],
                    ['is_cool', 'true'],
                  ])
    bare_presenter.stub('list_item')
      .and_return(['Joe the Virtual Machine', 'true'])
    bare_presenter.stub('list_item_fields')
      .and_return(['name', 'is_cool'])
    Aeolus::Cli::Formatting::HumanPresenterFilter.new(bare_presenter)
  end

  context "detail" do
    subject { presenter.detail }
    it { should == [
                     ['Name:', 'Joe the Virtual Machine'],
                     ['Status:', 'crashed'],
                     ['Is cool:', 'true'],
                   ] }
  end

  context "list item" do
    subject { presenter.list_item }
    it { should == ['Joe the Virtual Machine', 'true'] }
  end

  context "list table header" do
    subject { presenter.list_table_header }
    it { should == ['Name', 'Is cool'] }
  end

end
