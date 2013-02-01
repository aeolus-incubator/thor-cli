require 'aeolus/client'
require 'logger'

# FIXME: get rid of these when refactoring config loading:
ActiveResource::Base.logger = Logger.new(STDOUT)
ActiveResource::Base.logger.level = Logger::INFO

class Aeolus::Client::Base < ActiveResource::Base
  self.timeout = 600
  self.format = :xml
end
