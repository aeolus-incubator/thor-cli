class Aeolus::Cli::Error < StandardError
  attr_reader :message

  def initialize(message)
    @message  = message
  end
end

class Aeolus::Cli::ConfigError < Aeolus::Cli::Error; end
