require 'aeolus/cli/common_cli'

describe Aeolus::Cli::CommonCli do
  let(:common_cli) { Aeolus::Cli::CommonCli.new() }

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

  context "#resource_fields" do
    context "non-empty fields" do
      subject { common_cli.send(:resource_sort_by, "name+,status-,is_cool") }
      it { should == [[:name, :asc], [:status, :desc], [:is_cool, :asc]] }
    end

    context "empty fields" do
      subject { common_cli.send(:resource_sort_by, "") }
      it do
        expect { subject }.to raise_error Thor::MalformattedArgumentError
      end
    end

    context "nil fields" do
      subject { common_cli.send(:resource_sort_by, nil) }
      it { should == nil }
    end
  end

end
