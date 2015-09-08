module BlockScore
  class Collection < Array
    attr_reader :default_params
    protected :default_params

    attr_reader :parent, :target, :data

    def initialize(params)
      @parent = params.fetch :parent
      @target = params.fetch :target
      register_parent_data
    end

    def default_params
      {
        :"#{parent_name}_id" => parent.id
      }
    end

    def all
      self
    end

    def new(params = {})
      item = target.new(params.merge(default_params))
      ctxt = self
      item.define_singleton_method(:save) do
        ctxt.parent.save unless ctxt.parent.id
        send :"#{ctxt.parent_name}_id=", ctxt.parent.id
        super()
      end
      self << item
      item
    end

    def refresh
      clear
      register_parent_data
      self
    end

    def parent_name
      parent.class.resource
    end

    def target_name
      target.resource
    end

    def create(params = {})
      fail Error, 'Create parent first' unless parent.id
      assoc_params = default_params.merge(params)
      item = target.create assoc_params
      @data << item.id
      self << item
      item
    end

    def retrieve(id)
      return self[data.index(id)] if data.include? id
      item = target.retrieve(id)
      register_to_parent(item)
    end

    private

    def parent_id?(item)
      parent.id && item.send(:"#{parent_name}_id") == parent.id
    end

    def register_to_parent(item)
      fail Error, 'None belonging' unless parent_id?(item)
      data << item.id
      self << item
      item
    end

    def register_parent_data
      @data = parent.attributes.fetch(:"#{ Util.to_plural(target_name) }", [])

      @data.each do |id|
        item = target.retrieve(id)
        self << item
      end
    end
  end
end
