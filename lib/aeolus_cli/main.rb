require 'aeolus_cli'
require 'thor'
require 'aeolus_cli/provider'
require 'aeolus_cli/provider_account'

class AeolusCli::Main < Thor

  desc 'provider', 'show provider subcommands'
  subcommand 'provider', AeolusCli::Provider

  desc 'provider_account', 'show provider account subcommands'
  subcommand 'provider_account', AeolusCli::ProviderAccount

end
