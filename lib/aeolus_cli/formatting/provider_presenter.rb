require 'aeolus_cli/formatting/presenter'

module AeolusCli::Formatting
  class ProviderPresenter < Presenter
    default_list_item_fields(:name, :provider_type, :deltacloud_provider, :deltacloud_url)
    default_detail_fields(:id, :name, :provider_type, :deltacloud_provider, :deltacloud_url)
    alias_field(:deltacloud_url, :url)
  end
end
