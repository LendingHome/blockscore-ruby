module BlockScore
  # Collection is a proxy between the parent and the associated members
  # where parent is some instance of a resource
  #
  class Collection < Array
    # @!attribute [r] parent
    # resource which owns a collection of other resources
    #
    # @example
    #   person.question_sets.parent # => person
    #
    # @return [BlockScore::Base] a resource
    #
    # @api private
    attr_reader :parent

    # Sets parent and member_class then registers embedded ids
    #
    # @param [BlockScore::Base] parent
    # @param [Class] member_class of collection members
    #
    # @return [undefined]
    #
    # @api private
    def initialize(parent, member_class)
      @parent       = parent
      @member_class = member_class
      register_parent_data
    end

    # Syntactic sugar method for returning collection
    #
    # @example
    #   all # returns collection
    #
    # @return [self]
    #
    # @api public
    def all
      self
    end

    # Initializes new {member_class} with `params`
    #
    # - Ensures a parent id is merged into `params` (see #default_params).
    # - Defines method `#save` on new collection member
    # - Adds new item to collection
    #
    # @example usage
    #
    #   >> person = BlockScore::Person.retrieve('55de4af7643735000300000f')
    #   >> person.question_sets.new
    #   => #<BlockScore::QuestionSet:0x3fc67902f1b4 JSON:{
    #     "person_id": "55de4af7643735000300000f"
    #   }>
    #
    # @param params [Hash] initial params for member
    #
    # @return instance of {member_class}
    #
    # @api public
    def new(params = {})
      attributes = params.merge(default_params)
      instance   = member_class.new(attributes)

      new_member(instance) do |member|
        self << member
      end
    end

    # Reload the contents of the collection
    #
    # @example usage
    #   person.question_sets.refresh # => [#<BlockScore::QuestionSet...]
    #
    # @return [self]
    #
    # @api public
    def refresh
      clear
      register_parent_data
      self
    end

    # Name of parent resource
    #
    # @example
    #   self.parent_name # => 'person'
    #
    # @return [String]
    #
    # @api semipublic
    def parent_name
      parent.class.resource
    end

    # Initialize a collection member and save it
    #
    # @example
    #   >> person.question_sets.create
    #   => #<BlockScore::QuestionSet:0x3fc67a6007f4 JSON:{
    #     "object": "question_set",
    #     "id": "55ef5d5b62386200030001b3",
    #     "created_at": 1441750363,
    #     ...
    #     }
    #
    # @param params [Hash] params
    #
    # @return new saved instance of {member_class}
    #
    # @api public
    def create(params = {})
      fail Error, 'Create parent first' unless parent.id
      assoc_params = default_params.merge(params)

      add_instance(member_class.create(assoc_params))
    end

    # Retrieve a collection member by its id
    #
    # @example usage
    #   person.question_sets.retrieve('55ef5b4e3532630003000178')
    #           => instance of QuestionSet
    #
    # @param id [String] resource id
    #
    # @return instance of {member_class} if found
    # @raise [BlockScore::NotFoundError] otherwise
    #
    # @api public
    def retrieve(id)
      each do |item|
        return item if item.id.eql?(id)
      end

      add_instance(member_class.retrieve(id))
    end

    private

    def add_instance(instance)
      new_member(instance, &method(:register_to_parent))
    end

    # @!attribute [r] member_class
    # class which will be used for the embedded
    # resources in the collection
    #
    # @return [Class]
    #
    # @api private
    attr_reader :member_class

    # Default params for making an instance of {member_class}
    #
    # @return [Hash]
    #
    # @api private
    def default_params
      {
        foreign_key => parent.id
      }
    end

    # Generate foreign key name for parent resource
    #
    # @return [Symbol] resource name as id
    #
    # @api private
    def foreign_key
      :"#{parent_name}_id"
    end

    # Initialize a new collection member
    #
    # @param instance [BlockScore::Base] collection member instance
    # @yield [Member] initialized member
    #
    # @return [Member] new member
    #
    # @api private
    def new_member(instance, &blk)
      Member.new(parent, instance).tap(&blk)
    end

    # Check if `parent_id` is defined on `item`
    #
    # @param item [BlockScore::Base] any resource
    #
    # @return [Boolean]
    #
    # @api private
    def parent_id?(item)
      parent.id && item.send(foreign_key).eql?(parent.id)
    end

    # Register a resource in collection
    #
    # @param item [BlockScore::Base] a resource
    #
    # @raise [BlockScore::Error] if no `parent_id`
    # @return [BlockScore::Base] otherwise
    #
    # @api private
    def register_to_parent(item)
      fail Error, 'None belonging' unless parent_id?(item)
      ids << item.id
      self << item
      item
    end

    # Fetches embedded ids from parent and adds to self
    #
    # @return [undefined]
    #
    # @api private
    def register_parent_data
      ids.each do |id|
        self << member_class.retrieve(id)
      end
    end

    # ids that belong to the collection
    #
    # @return [Array<String>]
    #
    # @api private
    def ids
      parent.attributes.fetch(:"#{Util.to_plural(member_class.resource)}", [])
    end
  end
end
