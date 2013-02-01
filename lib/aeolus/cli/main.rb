require 'aeolus/cli'
require 'thor'
require 'aeolus/cli/provider'
require 'aeolus/cli/provider_account'

class Aeolus::Cli::Main < Thor

  desc 'provider', 'show provider subcommands'
  subcommand 'provider', Aeolus::Cli::Provider

  desc 'provider_account', 'show provider account subcommands'
  subcommand 'provider_account', Aeolus::Cli::ProviderAccount

end
