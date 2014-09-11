module BlockScore
  class WatchlistCandidate < Restful
    PATH = '/watchlist_candidates'

    # Public: Duplicate some text an arbitrary number of times.
    #
    # options = {} -
    #
    # Returns the duplicated String.
    def create(options = {})
      req :post, PATH, options
    end

    # Public: Duplicate some text an arbitrary number of times.
    #
    # options = {} -
    #
    # Returns the duplicated String.
    def edit(options = {})
      req :put, "#{PATH}/#{id.to_s}", options
    end

    # Public: Duplicate some text an arbitrary number of times.
    #
    # options = {} -
    #
    # Returns the duplicated String.
    def delete(options = {})
      req :delete, "#{PATH}/#{id.to_s}", options
    end

    # Public: Duplicate some text an arbitrary number of times.
    #
    # options = {} -
    #
    # Returns the duplicated String.
    def retrieve(options = {})
      req :get, "#{PATH}/#{id.to_s}", options
    end

    # Public: Duplicate some text an arbitrary number of times.
    #
    # options = {} -
    #
    # Returns the duplicated String.
    def all(options = {})
      req :get, PATH, options
    end

    # Public: Duplicate some text an arbitrary number of times.
    #
    # options = {} -
    #
    # Returns the duplicated String.
    def history(options = {})
      req :get, "#{PATH}/#{id.to_s}/history", options
    end

    # Public: Duplicate some text an arbitrary number of times.
    #
    # options = {} -
    #
    # Returns the duplicated String.
    def hits(options = {})
      req :get, "#{PATH}/#{id.to_s}/hits", options
    end
  end
end