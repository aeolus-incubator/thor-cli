require 'aeocli'
require 'thor'
require 'aeocli/provider'
require 'aeocli/provider_account'

class Aeocli::CLI < Thor

  desc 'provider', 'show provider subcommands'
  subcommand 'provider', Aeocli::Provider

  desc 'provider_account', 'show provider account subcommands'
  subcommand 'provider_account', Aeocli::ProviderAccount

end
