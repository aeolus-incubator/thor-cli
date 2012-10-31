class ProviderTypeXMLFormat
  include ActiveResource::Formats::XmlFormat

  def decode(xml)
    ActiveResource::Formats::XmlFormat.decode(xml)['provider_type']
  end
end

class AeolusCli::Model::ProviderType < AeolusCli::Model::Base
  self.format = ProviderTypeXMLFormat.new
end
