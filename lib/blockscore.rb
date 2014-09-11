require 'httparty'
require 'hashie'

require_relative 'blockscore/restful.rb'
require_relative 'blockscore/base.rb'
require_relative 'blockscore/company.rb'
require_relative 'blockscore/errors.rb'
require_relative 'blockscore/question_set.rb'
require_relative 'blockscore/verification.rb'
require_relative 'blockscore/watchlist.rb'
require_relative 'blockscore/watchlist_candidate.rb'

module BlockScore
  class << self
    attr_accessor :api_key
  end
end 