require 'aeolus/cli/formatting/presenter'

module Aeolus::Cli::Formatting
  class ProviderAccountPresenter < Presenter
    default_list_item_fields(:name, :provider, :username, :quota)
    default_detail_fields(:name, :provider, :username, :quota)
    field_definition(:username) do |account|
      if (account.respond_to?(:credentials) && account.credentials.respond_to?(:username))
        account.credentials.username
      else
        ''
      end
    end
    field_definition(:quota) do |account|
      if (account.respond_to?(:quota) && account.quota.respond_to?(:maximum_running_instances))
        account.quota.maximum_running_instances
      else
        ''
      end
    end
  end
end
