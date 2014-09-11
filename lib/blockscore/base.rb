module BlockScore
  class Base
    def initialize(options = {})
      @error_handler = BlockScore::ErrorHandler.new
      
      options.each do |k,v|
        self.class.send k, v
      end
    end
    
    
    # Public: Populates a hash that contains version and language
    # information for identification purposes.
    #
    # A hash with user agent information of the current client lib
    def user_agent
      lang_version = build_lang_version_string

      {
        :lang => 'ruby',
        :lang_version => lang_version,
        :platform => RUBY_PLATFORM,
        :publisher => 'blockscore'
      }
    end

    # Public: Creates a generic HTTP request including all
    # necessary authentication and parameters.
    #
    # verb - The HTTP very that you would like to form the request
    # path - The path after the main API URL you would like to hit
    # options = {} - Any additional options such as pagination
    #
    # Returns a marshaled object with the JSON structure.
    # def req(verb, path, options = {})
    #   options = { :body => options, :basic_auth => @auth }

    #   response = self.class.send(verb, path, options)
    #   marshaled_object = Hashie::Mash.new(JSON.parse(response.body))

    #   begin
    #     result = @error_handler.check_error(response)
    #   rescue BlockScore::BlockscoreError => e
    #     raise
    #   end

    #   marshaled_object
    # end
  end

  private
  
  # Private: Creates an informative string containing the user's ruby
  # information.
  #
  # A string with user ruby information.
  def build_lang_version_string
    "#{RUBY_VERSION} p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE})"
  end
end