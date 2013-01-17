require 'aeolus_cli/formatting/presenter'

describe AeolusCli::Formatting::Presenter do
  let(:presenter_class) do
    Class.new(AeolusCli::Formatting::Presenter) do
      default_detail_fields(:name, :status, :is_cool)
      default_list_item_fields(:name, :is_cool)
    end
  end
  let(:presented_object) do
    double('presented object').tap do |presented_object|
      presented_object.stub(:name).and_return('Joe the Virtual Machine')
      presented_object.stub(:status).and_return('crashed')
      presented_object.stub(:is_cool).and_return(true)
    end
  end

  context "with default fields" do
    let(:presenter) { presenter_class.new(presented_object) }

    context "detail" do
      subject { presenter.detail }
      it { should == [
                       ['name', 'Joe the Virtual Machine'],
                       ['status', 'crashed'],
                       ['is_cool', 'true'],
                     ] }
    end

    context "list item" do
      subject { presenter.list_item }
      it { should == ['Joe the Virtual Machine', 'true'] }
    end

    context "aliased field hiding the old field" do
      before do
        presenter_class.alias_field(:new_field, :old_field)
        presented_object.should_not_receive(:new_field)
        presented_object.stub(:old_field).and_return('field value')
      end

      context "getting new field" do
        subject { presenter.field(:new_field) }

        it { should == 'field value' }
      end

      context "getting old field" do
        subject { presenter.field(:old_field) }
        it do
          expect { subject }
            .to raise_error AeolusCli::Formatting::UnknownFieldError
        end
      end
    end

    context "aliased field *not* hiding the old field" do
      before do
        presenter_class.alias_field(:new_field, :old_field, false)
        presented_object.should_not_receive(:new_field)
        presented_object.stub(:old_field).and_return('field value')
      end

      context "getting new field" do
        subject { presenter.field(:new_field) }
        it { should == 'field value' }
      end

      context "getting old field" do
        subject { presenter.field(:old_field) }
        it { should == 'field value' }
      end
    end

    context "accessing unknown field" do
      subject { presenter.field(:some_unknown_field) }
      it do
        expect { subject }
          .to raise_error AeolusCli::Formatting::UnknownFieldError
      end
    end

    context "custom defined field" do
      subject { presenter.field(:custom_field) }
      before do
        presenter_class.field_definition(:custom_field) do
          'this is custom field'
        end
      end

      it { should == 'this is custom field' }
    end

    context "detail fields" do
      subject { presenter.detail_fields }
      it { should == [:name, :status, :is_cool] }
    end

    context "list item fields" do
      subject { presenter.list_item_fields }
      it { should == [:name, :is_cool] }
    end
  end

  context "with overriden fields" do
    let(:presenter) { presenter_class.new(presented_object, [:status]) }

    context "detail" do
      subject { presenter.detail }
      it { should == [
                       ['status', 'crashed'],
                     ] }
    end

    context "list item" do
      subject { presenter.list_item }
      it { should == ['crashed'] }
    end

    context "detail fields" do
      subject { presenter.detail_fields }
      it { should == [:status] }
    end

    context "list item fields" do
      subject { presenter.list_item_fields }
      it { should == [:status] }
    end
  end

end
