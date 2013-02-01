require 'aeolus/client/base'

class Aeolus::Client::ProviderTypeXMLFormat
  include ActiveResource::Formats::XmlFormat

  def decode(xml)
    ActiveResource::Formats::XmlFormat.decode(xml)['provider_type']
  end
end

class Aeolus::Client::ProviderType < Aeolus::Client::Base
  self.format = Aeolus::Client::ProviderTypeXMLFormat.new
end
