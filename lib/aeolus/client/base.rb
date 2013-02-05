require 'aeolus/client'
require 'logger'

class Aeolus::Client::Base < ActiveResource::Base
  self.timeout = 600
  self.format = :xml
end
