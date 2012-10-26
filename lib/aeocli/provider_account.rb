require 'aeocli/common_cli'

class Aeocli::ProviderAccount < Aeocli::CommonCLI

  desc "list", "list provider accounts"
  # TODO maybe an optional variable for provider_type
  def list
    puts "Placeholder to list provider accounts"
  end

  desc "add PROVIDER_ACCOUNT_LABEL", "Add a provider account"
  method_option :provider_name, :type => :string, :required => true,
    :aliases => "-n", :desc => "(already existing) provider name"
  method_option :credentials_file, :type => :string, :required => true,
    :desc => "path to credentials xml file"
  method_option :quota, :type => :string, :aliases => "-q",
    :default => "unlimited", :desc => "maximum running instances"
  def add(label)
    puts "Placeholder to add provider account with label "+label
    [:provider_name,:credentials_file,:quota].each do |o|
      puts 'Parameter '+o.to_s+ ' is '+options[o]
    end
  end
end
