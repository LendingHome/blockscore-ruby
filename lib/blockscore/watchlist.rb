module BlockScore
  class Watchlist < Restful
    PATH = '/watchlists'

    # Public: Duplicate some text an arbitrary number of times.
    #
    # options = {} -
    #
    # Returns the duplicated String.
    def search(options = {})
      req :post, PATH, options
    end
  end
end