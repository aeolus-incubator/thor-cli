require 'active_resource'
require 'aeolus_cli'
require 'logger'

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
      if array.size >= 1 && array[0].is_a?(Hash) &&
        array[0].has_key?('message')
        array.map! {|error| error['message']}
      end
      from_array array, save_cache
    end
  end
end

# declaring the namespace but for style reasons not including the Base
# class definition within the block (saving as much excessive
# indentation as possible)
module AeolusCli::Model
end

class AeolusCli::Model::Base < ActiveResource::Base
  self.timeout = 600
  self.format = :xml
end
