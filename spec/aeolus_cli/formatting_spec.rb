require 'aeolus_cli/formatting'

describe AeolusCli::Formatting do
  let(:formatting) { AeolusCli::Formatting }
  let(:shell) { double('shell') }

  context ".create_format" do
    subject { formatting.create_format(shell, { :format => 'human' }) }
    let(:human_format) { double('human format') }
    let(:human_format_class) do
      double('human format class').tap do |clazz|
        clazz.stub(:new).with(shell).and_return(human_format)
      end
    end

    before do
      formatting.should_receive(:require).with("aeolus_cli/formatting/human_format").and_return(true)
      formatting.should_receive(:const_get).with("HumanFormat").and_return(human_format_class)
    end

    it { should == human_format }
  end
end
