require 'active_support/concern'
require 'aruba/api'

module IntegrationExampleGroup
  extend ActiveSupport::Concern

  included do
    metadata[:type] = :integration

    let(:executable) { "aeolus" }
    let(:command) { "" }
    let(:params) { "" }
    let(:cmd) { [ executable, command, params ].select{|s| !s.empty?}.join(' ') }

    before(:each) do
      run_simple(unescape(cmd), false)
    end

    subject do
      groups = example.example_group.ancestors.clone
      groups << example.example_group
      if groups.find{|g| g.metadata[:example_group][:description] == "stdout"}
        all_stdout
      elsif groups.find{|g| g.metadata[:example_group][:description] == "stderr"}
        all_stderr
      end
    end
  end

  RSpec.configure do |config|
    config.include Aruba::Api
    config.include self,
      :type => :integration,
      :example_group => { :file_path => %r(spec/integration) }
  end
end
