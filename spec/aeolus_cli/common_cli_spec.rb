require 'aeolus_cli/common_cli'

describe AeolusCli::CommonCli do
  let(:common_cli) { AeolusCli::CommonCli.new() }

  context "#resource_fields" do
    subject { common_cli.send(:resource_fields, "name,status,is_cool") }
    it { should == [:name, :status, :is_cool] }
  end
end
