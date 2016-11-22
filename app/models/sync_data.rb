class SyncData
  attr_accessor :revision, :changes
  class TreeNode
    attr_accessor :parent, :value, :children

    def initialize(parent, value, children)
      @parent = parent
      @value = value
      @children = children
    end

    def values
      [@value, @children.map(&:values)].flatten
    end

    def flatten
      [self, @children.map(&:flatten)].flatten
    end

    def parents
      [@parent, @parent&.parents].flatten.compact
    end

    def inspect
      "TreeNode<value = #{@value.inspect}, parent = #{@parent&.value.inspect}, children = #{@children&.count}>"
    end

    def [](obj)
      @children.find { |x| x.value == obj }
    end
  end

  def self.from_sync(received)
    sent = SyncData.new
  end
  
  def self.after_revision(revision, scope_instance)
    db_tree = tree_from(class_hierarchy_from(scope_instance.class))
    date_time = DateTime.strptime("#{revision}", '%s')
    models = db_tree.flatten.map(&:value).uniq.map{|model| selectors_for(scope_instance, model).map{|selector| selector.where("\"#{model.to_s.underscore.pluralize}\".\"updated_at\" >= ?", date_time).to_a}}.flatten
  end

  def self.class_hierarchy_from(klass)
    {klass => klass.reflections.values.select do |r|
      r.klass != klass && !r.is_a?(ActiveRecord::Reflection::BelongsToReflection) && !r.is_a?(ActiveRecord::Reflection::ThroughReflection)
    end.map(&:klass).uniq.map do |c|
      class_hierarchy_from(c)
    end}
  end

  def self.tree_from(root, parent = nil)
    node = TreeNode.new(parent, root.keys[0], [])
    node.children = root.values[0].map do |child|
      tree_from(child, node)
    end
    node
  end

  def self.selectors_for(instance, klass)
    root = instance.class
    tree = tree_from(class_hierarchy_from(root))
    nodes = tree.flatten.select { |node| node.value == klass }
    nodes.map{ |node| selector_from_node(instance, node)}
  end

  def self.selector_from_node(instance, node)
    if instance.class == node.value
        node.value.where(id: instance.id)
    else
        raise "instância de entidade de escopo inválida! Esperada: #{node.parents.map(&:value)[-1]}, recebeu #{instance.class}" unless node.parents.map(&:value)[-1] == instance.class
        # Transfer.joins(credit: {account: :user}).where(credit: {accounts: {user_id: User.first}})
        parents = node.parents.map(&:value).map(&:to_s)
        joins = parents.map(&:underscore)
        joins = joins[0..-2].reverse.inject(joins[-1]) {|a,n| {n => a}}
        wheres = parents.map(&:underscore)
        wheres[-2] = wheres[-2].pluralize
        wheres[-1] << '_id'
        wheres = wheres.reverse.inject(instance.id) {|a,n| {n => a}}

        node.value.joins(joins).where(wheres)
    end
  end
end
