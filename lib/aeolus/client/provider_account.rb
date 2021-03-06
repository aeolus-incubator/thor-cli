require 'aeolus/client/base'

class Aeolus::Client::ProviderAccountXMLFormat
  include ActiveResource::Formats::XmlFormat

  def decode(xml)
    if xml == nil or xml.size == 0
      return nil
    end
    if xml.start_with?('<provider_accounts>')
      h = ActiveResource::Formats.remove_root(Hash.from_xml(xml))
      # h is a hash of 'provider_account' => array of provider_account
      # hashes
      if h['provider_account'].is_a?(Hash)
        # Having just one provider_account causes the value of
        # 'provider_account' to not exist in a array, so we wrap it in
        # an array to prevent an error like:
        # ...active_resource/base.rb:929:in `instantiate_collection':
        # undefined method `collect!' for #<Hash:0x0000000102e800>
        # (NoMethodError)
        [h['provider_account']]
      else
        # return value is an array of hashes
        h['provider_account']
      end
    elsif xml.start_with?('<provider_account ') or
          xml.start_with?('<provider_account>')
      Hash.from_xml(xml)
    else
      # TODO raise an appropriate error that we didn't get
      # <provider_accounts> or <provider_account> xml
      nil
    end
  end
end

class Aeolus::Client::ProviderAccount < Aeolus::Client::Base
  self.format = Aeolus::Client::ProviderAccountXMLFormat.new

  # FIXME: This should not be necessary when we update API to show full
  # representations in resource collections.
  def self.all_full_detail
    self.all.map! do |account|
      # getting a separate resource gives more details than collection
      Aeolus::Client::ProviderAccount.find(account.id)
    end
  end
end
