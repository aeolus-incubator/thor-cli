require 'active_support'
require 'aeolus_cli/common_cli'
require 'aeolus_cli/model/provider'

class AeolusCli::Provider < AeolusCli::CommonCli

  desc "list", "List all providers"
  def list
    providers = AeolusCli::Model::Provider.all
    print_table( [[:name,"Name"],
                  [:provider_type, "Provider Type"],
                  [:deltacloud_provider, "Deltacloud Provider"],
                  [:url, "Deltacloud url"]],
                 providers )
  end

  desc "add PROVIDER_NAME", "Add a provider"
  method_option :provider_type, :type => :string, :required => true,
    :aliases => "-t", :desc => 'E.g. ec2, vsphere, mock, rhevm...'
  method_option :deltacloud_url, :type => :string
  method_option :deltacloud_provider, :type => :string
  def add(provider_name)
    # TODO: validation on provider_type (make sure exists)
    p = AeolusCli::Model::Provider.new(:name => provider_name,
         :url => options[:deltacloud_url],
         :provider_type => provider_type(options[:provider_type]),
         :deltacloud_provider => options[:deltacloud_provider])
    if !p.save
      self.shell.say "ERROR:  Conductor was unable to save the provider"
      self.shell.say p.errors.full_messages
      exit(1)
    else
      self.shell.say "Provider #{provider_name} added with id #{p.id}"
    end
  end

end
