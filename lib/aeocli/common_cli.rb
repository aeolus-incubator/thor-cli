#require 'rest_client'
require 'active_resource'
require 'active_support'
require 'nokogiri'
require 'logger'
require 'thor'
require 'aeocli/model/base'
require 'aeocli/model/provider_type'

class Aeocli::CommonCLI < Thor
#  def initialize(opts={}, logger=nil)
  def initialize(*args)
    super
    begin
      logger(logger)
      @config_location = "~/.aeolus-cli"
      @config = load_config
      configure_active_resource
    rescue => e
      handle_exception(e)
    end
  end

  protected

  def provider_type_hash
    deltacloud_driver_to_provider_type_id = Hash.new
    provider_types = Aeocli::Model::ProviderType.all
    if provider_types.size == 0
      raise "Retrieved zero provider types from Conductor"
    end
    provider_types.each do |pt|
      deltacloud_driver_to_provider_type_id[pt.deltacloud_driver] = pt.id
    end
    deltacloud_driver_to_provider_type_id
  end

  def provider_type_id(type_s)
    begin
      @provider_type_hash ||= provider_type_hash
    rescue => e
      handle_exception(e)
    end
  end

  # All of the methods below borrowed from aeolus-cli
  def logger(logger=nil)
    @logger ||= logger
    unless @logger
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::DEBUG
      @logger.datetime_format = "%Y-%m-%d %H:%M:%S"
    end
    return @logger
  end

  private
  def handle_exception(e)
    if e.is_a?(Errno::ECONNREFUSED)
      code = "Connection Refused"
      message = "Could not connect to aeolus-conductor please make sure it is running and that ~/.aeolus-cli points to the conductor API URL"

    elsif e.is_a?(ActiveResource::UnauthorizedAccess)
      code = "Unauthorized"
      message = "Invalid Credentials, please check ~/.aeolus-cli"

    elsif e.is_a?(ActiveResource::Redirection)
      code = "Found"
      message = "Server tried to redirect to #{e.response.header['location']}, please check ~/.aeolus-cli"

    elsif e.is_a?(ActiveResource::ServerError)
      code = "Service Temporarily Unavailable"
      if e.response.code == "503" && /Imagefactory/.match(e.response.body)
        message = "Please check that Imagefactory is running."
      else
        message = "Please check that Conductor is running."
      end

    elsif e.is_a?(SocketError)
      code = "Name Or Service Not Found"
      message = "Please check your ~/.aeolus-cli"

    elsif e.is_a?(TypeError)
      code = "Internal Error (TypeError)"
      message = e.message

    elsif e.is_a?(ArgumentError)
      code = "Argument Error"
      message = e.message

    elsif e.is_a?(Aeocli::ConfigError)
      code = "Config Error"
      message = e.message + "; please check ~/.aeolus-cli"

    elsif e.respond_to?(:response)
      doc = Nokogiri::XML e.response.body
      code = doc.xpath("/error/code").text
      message = doc.xpath("/error/message").text

      if message.to_s.empty?
        case code
          when "BuildDeleteFailure"
            message = "An error occured when deleting the Build from the Image Warehouse"
          when "BuildNotFound"
            message = "Could not find the specified Build"
          when "ImageDeleteFailure"
            message = "An error occured when deleting the Image from the Image Warehouse"
          when "ImageNotFound"
            message = "Could not find the specified Image"
          when "InsufficientParametersSupplied"
            message = "There were insufficient parameters provided in the request"
          when "ParameterDataIncorrect"
            message = "The given parameters are incorrect"
          when "PushError"
            message = "An error occured the Image Factory when trying to push"
          when "ProviderAccountNotFound"
            message = "Could not find the specified account"
          when "ProviderImageDeleteFailure"
            message = "An error occurd when deleting the Provider Image from Image Warehouse"
          when "ProviderImageNotFound"
            message = "Could not find the specified Provider Image"
          when "ProviderImageStatusNotFound"
            message = "There was no status supplied in the Provider Image"
          when "TargetImageDeleteFailure"
            message = "An error occured when deleting the Target Image from the Image Warehouse"
          when "TargetImageNotFound"
            message = "Could not locate the specified Target Image"
          when "TargetImageStatusNotFound"
            message = "There was no status supplied in the Target Image"
          when "TargetNotFound"
            message = "Could not locate the specified Target"
          else
            message = e.message
        end
      end
    else
      message = e.message + "\n" + (e.backtrace * "\n")
      code = 'Unknown Error'
    end

    puts ""
    puts "ERROR:  " + code + " => " + message
    exit(1)
  end

  def configure_active_resource
    if @config.has_key?(:conductor)
      [:url, :password, :username].each do |key|
        raise Aeocli::ConfigError.new(
         "Error in configuration file: #{key} is missing") \
          unless @config[:conductor].has_key?(key)
      end
      Aeocli::Model::Base.site = @config[:conductor][:url]
      Aeocli::Model::Base.user = @config[:conductor][:username]
      Aeocli::Model::Base.password = @config[:conductor][:password]
    else
      raise Aeocli::ConfigError.new("Error in configuration file")
    end
  end

  def load_config
    begin
      file_str = read_file(@config_location)
      if is_file?(@config_location) && !file_str.include?(":url")
        lines = File.readlines(File.expand_path(@config_location)).map do |line|
          "#" + line
        end
        File.open(File.expand_path(@config_location), 'w') do |file|
          file.puts lines
        end
        write_file
      end
      write_file unless is_file?(@config_location)
      YAML::load(File.open(File.expand_path(@config_location)))
    rescue Errno::ENOENT
      #TODO: Create a custom exception to wrap CLI Exceptions
      raise "Unable to locate or write configuration file: \"" +
        @config_location + "\""
    end
  end

  def read_file(path)
    begin
      full_path = File.expand_path(path)
      if is_file?(path)
        File.read(full_path)
      else
        return nil
      end
    rescue
      nil
    end
  end

  # TODO: Consider ripping all this file-related stuff into a module or
  # class for better encapsulation and testability
  def is_file?(path)
    full_path = File.expand_path(path)
    if File.exist?(full_path) && !File.directory?(full_path)
      return true
    end
    false
  end

  def write_file
    example = File.read(File.expand_path(File.dirname(__FILE__) +
                                         "/../../../examples/aeolus-cli"))
    File.open(File.expand_path(@config_location), 'a+', 0600) do |f|
      f.write(example)
    end
  end

  # Print Collection to STDOUT in a column layout
  def print_collection(collection, headers)
    widths = column_widths(collection, headers)

    # Print Headers
    widths.each_pair do |header, width|
      printf("%-#{width + 5}s", headers[header])
    end
    puts ""

    # Print Underlines
    widths.each_pair do |header, width|
      printf("%-#{width + 5}s", "-" * width)
    end
    puts ""

    # Print collection information
    collection.each do |resource|
      widths.each_pair do |attr, width|
        printf("%-#{width + 5}s", resource.attributes.include?(attr) ? resource.attributes[attr].to_s : "")
      end
      puts ""
    end
    puts ""
  end

  def column_widths(collection, headers)
    widths = ActiveSupport::OrderedHash.new
    headers.each_pair do |attr, header|
      widths[attr] = header.length
    end

    collection.each do |resource|
      headers.keys.each do |attr|
        widths[attr] = widths[attr] > resource.attributes[attr].to_s.length ? widths[attr] : resource.attributes[attr].to_s.length
      end
    end
    widths
  end

end
