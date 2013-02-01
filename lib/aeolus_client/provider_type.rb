require 'aeolus_client/base'

class AeolusClient::ProviderTypeXMLFormat
  include ActiveResource::Formats::XmlFormat

  def decode(xml)
    ActiveResource::Formats::XmlFormat.decode(xml)['provider_type']
  end
end

class AeolusClient::ProviderType < AeolusClient::Base
  self.format = AeolusClient::ProviderTypeXMLFormat.new
end
