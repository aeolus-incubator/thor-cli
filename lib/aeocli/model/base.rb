require 'active_resource'
require 'active_support'
require 'aeocli'
require 'aeocli/model'

ActiveResource::Base.logger = Logger.new(STDOUT)
ActiveResource::Base.logger.level = Logger::DEBUG
module ActiveResource
  class LogSubscriber < ActiveSupport::LogSubscriber
    def request(event)
      result = event.payload[:result]
      color_info :green, "#{event.payload[:method].to_s.upcase} "+
        "#{event.payload[:request_uri]}"
      color_info :green, "--> %d %s %d (%.1fms)" % [result.code, result.message,
                                        result.body.to_s.length, event.duration]
      color_info :yellow, result.body.to_s
    end
    def color_info(color, msg)
      info(msg.respond_to?(color) ? msg.send(color) : msg)
    end
  end

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

class Aeocli::Model::Base < ActiveResource::Base
  self.timeout = 600
  self.format = :xml
  class << self
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

    def headers
      if !ENV['LANG'].nil? && ENV['LANG'].size >= 2
        {'ACCEPT_LANGUAGE' => ENV['LANG'][0,2]}
      else
        {}
      end
    end
  end

  # Active Resrouce Uses dashes instead of underscores, this method overrides to use underscore
  def to_xml(options={})
    options[:dasherize] ||= false
    super({ :root => self.class.element_name }.merge(options))
  end

  # Instance Methods
  def to_s
    id
  end

end
