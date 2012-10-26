require 'active_support'
require 'aeocli/common_cli'
require 'aeocli/model/provider'

class Aeocli::Provider < Aeocli::CommonCLI

  desc "list", "List all providers"
  def list
    begin
      headers = ActiveSupport::OrderedHash.new
      headers[:name] = "Name"
      headers[:provider_type] = "Type"
      headers[:deltacloud_provider] = "Target Reference"
      print_collection(Aeocli::Model::Provider.all, headers)
    rescue => e
      handle_exception(e)
    end
  end

  desc "add PROVIDER_NAME", "Add a provider"
  method_option :provider_type, :type => :string, :required => true,
    :aliases => "-t", :desc => 'E.g. ec2, vsphere, mock, rhevm...'
  method_option :deltacloud_url, :type => :string
  method_option :deltacloud_provider, :type => :string
  def add(provider_name)
    begin
      p = Aeocli::Model::Provider.new(:name => provider_name,
         :provider_type_id => provider_type_id(options[:provider_type]),
         :url => options[:deltacloud_url],
         :deltacloud_provider => options[:deltacloud_provider])
      if !p.save
        puts "ERROR:  Conductor was unable to save the provider"
        puts p.errors.full_messages
        exit(1)
      else
        puts "Provider #{provider_name} added with id #{p.id}"
      end
    rescue => e
      handle_exception(e)
    end
  end
end
