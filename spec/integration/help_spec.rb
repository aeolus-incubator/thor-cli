require 'spec_helper'
require 'aeolus/cli/main'

describe "display help" do

  variants = [
    { :command => 'help', :params => '' },
    { :command => '', :params => '-h' },
    { :command => '', :params => '--help' },
    { :command => '', :params => '' },
  ]

  variants.each do |variant|
    variant_name = variant.values.select{|v| !v.empty?}.join(' ')
    variant_name = "no command and no parameters" if variant_name.empty?

    describe variant_name do
      let(:command) { variant[:command] }
      let(:params) { variant[:params] }
      context "stdout" do
        it { should include_all("provider", "provider_account", "help [TASK]") }
      end

      describe "stderr" do
        it { should be_empty }
      end
    end
  end


end
