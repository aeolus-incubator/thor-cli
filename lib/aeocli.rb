require "aeocli/version"

module Aeocli
end

class Aeocli::Error < StandardError
  attr_reader :message

  def initialize(message)
    @message  = message
  end
end

class Aeocli::ConfigError < Aeocli::Error; end


