class AeolusClient::ProviderXMLFormat
  include ActiveResource::Formats::XmlFormat

  def decode(xml)
    if xml == nil or xml.size == 0
      return nil
    end
    if xml.start_with?('<providers>')
      h = ActiveResource::Formats.remove_root(Hash.from_xml(xml))
      # h is a hash of 'provider' => array of provider hashes
      if h['provider'].is_a?(Hash)
        # Having just one provider causes the value of 'provider' to
        # not exist in a array, so we wrap it in an array to prevent
        # an error like:
        # ...active_resource/base.rb:929:in `instantiate_collection':
        #  undefined method `collect!' for #<Hash:0x0000000102e800> (NoMethodError)
        [h['provider']]
      else
        # return value is an array of hashes
        h['provider']
      end
    elsif xml.start_with?('<provider ') or xml.start_with?('<provider>')
      Hash.from_xml(xml)
    else
      # TODO raise an appropriate error that we didn't get <providers>
      # or <provider> xml
      nil
    end
  end
end

class AeolusClient::Provider < AeolusClient::Base
  self.format = AeolusClient::ProviderXMLFormat.new
end
