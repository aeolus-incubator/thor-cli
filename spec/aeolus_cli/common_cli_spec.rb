require 'aeolus_cli/common_cli'

describe AeolusCli::CommonCli do
  let(:common_cli) { AeolusCli::CommonCli.new() }

  context "#resource_fields" do
    context "non-empty fields" do
      subject { common_cli.send(:resource_fields, "name,status,is_cool") }
      it { should == [:name, :status, :is_cool] }
    end

    context "empty fields" do
      subject { common_cli.send(:resource_fields, "") }
      it do
        expect { subject }.to raise_error Thor::MalformattedArgumentError
      end
    end

    context "nil fields" do
      subject { common_cli.send(:resource_fields, nil) }
      it { should == nil }
    end
  end
end
