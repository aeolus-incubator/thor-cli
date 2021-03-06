require 'aeolus/cli/common_cli'

describe Aeolus::Cli::CommonCli do
  let(:initialize_args) { [] }
  let(:common_cli) { Aeolus::Cli::CommonCli.new(*initialize_args) }

  context "#initialize" do
    subject { common_cli }

    context "config" do
      let(:config) do
        double('config').tap { |c| c.should_receive(:push) }
      end

      before do
        Aeolus::Cli::Config.should_receive(:new_from_hash).and_return(config)
      end

      its(:config) { should == config }

      context "when running non-help task" do
        let(:initialize_args) do
          [
            [],
            {},
            { :current_task => double('list task', :name => 'list') },
          ]
        end

        it "validates the config" do
          config.should_receive(:validate!)
          subject # run the constructor
        end
      end
    end
  end

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
