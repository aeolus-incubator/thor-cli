require 'active_resource'
require 'active_support'
require 'aeolus_cli'
require 'aeolus_cli/model'

ActiveResource::Base.logger = Logger.new(STDOUT)
ActiveResource::Base.logger.level = Logger::INFO

module ActiveResource
  class Errors
    # Grabs errors from an XML response.
    def from_xml(xml, save_cache = false)
      array = Array.wrap(Hash.from_xml(xml)['errors']['error'])
      # The below is added because the default behaviour (the above
      # line) only works fine if the error string is not buried in
      # another layer of xml.
      #
      # from_array (in this Errors class) is brittle and will blow up
      # if it doesn't get an array of strings.
      if array.size == 1 && array[0].is_a?(Hash) &&
        array[0].has_key?('message')
        array = Array.wrap(Hash.from_xml(xml)['errors']['error']['message'])
      end
      from_array array, save_cache
    end
  end
end

class AeolusCli::Model::Base < ActiveResource::Base
  self.timeout = 600
  class << self
    # get an error like   base.rb:885:in `instantiate_collection':
    # undefined method `collect!' for #<Hash:0x00000001b1a9d0> (NoMethodError)
    # without this method defined.
    def instantiate_collection(collection, prefix_options = {})
      if collection.is_a?(Hash) && collection.size == 1
        value = collection.values.first
        if value.is_a?(Array)
          value.collect! { |record| instantiate_record(record,prefix_options) }
        else
          [ instantiate_record(value, prefix_options) ]
        end
      elsif collection.is_a?(Hash)
        instantiate_record(collection, prefix_options)
      else
        begin
          collection.collect! { |record| instantiate_record(record, prefix_options) }
        rescue
          []
        end
      end
    end
  end
end
