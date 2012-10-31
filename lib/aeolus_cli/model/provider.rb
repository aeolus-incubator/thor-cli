class ProviderXMLFormat
  include ActiveResource::Formats::XmlFormat

  def decode(xml)
    if xml == nil or xml.size == 0
      return nil
    end
    if xml.start_with?('<providers>')
      h = ActiveResource::Formats.remove_root(Hash.from_xml(xml))
      # h is a hash of 'provider' => array of provider hashes
      h['provider']
    elsif xml.start_with?('<provider ') or xml.start_with?('<provider>')
      Hash.from_xml(xml)
    else
      # TODO raise an appropriate error that we didn't get <providers>
      # or <provider> xml
      nil
    end
  end
end

class AeolusCli::Model::Provider < AeolusCli::Model::Base
  self.format = ProviderXMLFormat.new
end
