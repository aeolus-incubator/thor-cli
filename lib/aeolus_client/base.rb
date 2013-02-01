require 'aeolus_client'
require 'logger'

# FIXME: get rid of these when refactoring config loading:
ActiveResource::Base.logger = Logger.new(STDOUT)
ActiveResource::Base.logger.level = Logger::INFO

class AeolusClient::Base < ActiveResource::Base
  self.timeout = 600
  self.format = :xml
end
