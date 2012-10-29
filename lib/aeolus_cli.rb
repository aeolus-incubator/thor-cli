require "aeolus_cli/version"

module AeolusCli
end

class AeolusCli::Error < StandardError
  attr_reader :message

  def initialize(message)
    @message  = message
  end
end

class AeolusCli::ConfigError < AeolusCli::Error; end
