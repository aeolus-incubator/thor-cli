require 'aeolus/cli/formatting/presenter'

describe Aeolus::Cli::Formatting::ProviderAccountPresenter do
  let(:presenter) { Aeolus::Cli::Formatting::ProviderAccountPresenter.new(presented_object) }

  context "with full resource details" do
    let(:presented_object) do
      double('presented object').tap do |object|
        object.stub_chain('quota.maximum_running_instances').and_return('5')
        object.stub_chain('credentials.username').and_return('someone')
      end
    end

    context "quota field" do
      subject { presenter.field(:quota) }
      it { should == '5' }
    end

    context "username field" do
      subject { presenter.field(:username) }
      it { should == 'someone' }
    end
  end

  context "with reduced resource details" do
    let(:presented_object) do
      double('presented object')
    end

    context "quota field" do
      subject { presenter.field(:quota) }
      it { should == '' }
    end

    context "username field" do
      subject { presenter.field(:username) }
      it { should == '' }
    end
  end

end
