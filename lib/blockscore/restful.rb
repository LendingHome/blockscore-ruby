module BlockScore
  class Restful
    include HTTParty

    API_VERSION = "3"

    base_uri "https://api.blockscore.com"
    headers 'Accept' => BlockScore::Restful.build_header_string
    default_timeout 30
    
    # Public: Dynamically creates an HTTParty call using #{verb}
    # http method. Will then run the returned JSON through
    # hashie to create a usable object.
    #
    # verb - HTTP method you would like to call
    # path - The endpoint after BASE_URL that will be called
    # options = {} - Additional keys for pagination or filtering
    #
    # Returns a marshaled object if the request was successful
    # or nil if it was unsuccessful.
    def self.req(verb, path, options = {})
      raise "API key has not been set" if BlockScore.api_key.nil?

      @auth = { :username => BlockScore.api_key, :password => "" }
      options = { :body => options, :basic_auth => @auth }

      response = self.send(verb, path, options)
      object = self.marshal_response(response)

      # begin
      #   result = @error_handler.check_error(response)
      # rescue BlockScore::BlockscoreError => e
      #   raise
      # end

      object
    end

    # Private: Creates the ACCEPT header required to make API calls.
    #
    # Returns the fully formed header string.
    def self.build_header_string
      "application/vnd.blockscore+json;version=#{API_VERSION}"
    end
    
    private

    # Private: Takes in a JSON object which will then be processed
    # by Hashie to form proper nested Ruby objects.
    #
    # response - A raw JSON response from HTTParty. Can be either
    # an array of objects or a single object.
    #
    # Returns either an array of objects or a single object
    # based on what was passed in.
    def self.marshal_response(response)
      json = response.parsed_response
      json_collection = []

      # If the return is a
      if json.is_a? Array
        json.each do |item|
          json_collection << Hashie::Mash.new(item)
        end
        json_collection
      else
        Hashie::Mash.new(json)
      end
    end
  end
end