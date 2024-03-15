include Comparable

class Nodes
  attr_accessor :value, :left, :right

  def initialize(value, left = nil, right = nil)
    @value = value
    @left = left
    @right = right
  end
  # def <=>(other_name)
  #   value <=> other_name.value
  # end
end

class Tree
  attr_accessor :arr, :root

  def initialize(arr = [])
    @arr = arr.sort.uniq
    @root = build_tree(@arr, 0, arr.length - 1)
  end

  def build_tree(arr, start, final)
    mid = (start + final) / 2
    return if start > final

    root = Nodes.new(arr[mid])
    root.left = build_tree(arr, start, mid - 1)
    root.right = build_tree(arr, mid + 1, final)
    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(values, nodes = @root)
    insert_values(values, nodes)
    self
  end

  def insert_values(values, nodes = @root)
    if nodes.nil?
      self.root = Nodes.new(values)
      arr.push(values)
    elsif nodes.value < values
      if nodes.right.nil?
        arr.push(values)
        nodes.right = Nodes.new(values)
      else
        nodes.right = insert_values(values, nodes.right)
      end
    elsif nodes.value > values
      if nodes.left.nil?
        arr.push(values)
        nodes.left = Nodes.new(values)
      else
        nodes.left = insert_values(values, nodes.left)
      end
    end
    nodes
  end

  def delete(values, _nodes = @root)
    self.root = delete_at(values, nodes = @root)
    self
  end

  def delete_at(values, nodes = @root)
    if nodes.value == values
      if !nodes.right.nil? and !nodes.left.nil?
        nodes.value = delete_two_children(values, nodes.right).value
        nodes.right = delete_at(nodes.value, nodes.right)
        return nodes
      elsif !nodes.right.nil?
        return delete_one_children(values, nodes.right)
      elsif !nodes.left.nil?
        return delete_one_children(values, nodes.left)
      else
        arr.pop
        nodes = nil
        return nodes
      end
    elsif nodes.value < values
      nodes.right = delete_at(values, nodes.right)
    elsif nodes.value > values
      nodes.left = delete_at(values, nodes.left)
    end
    nodes
  end

  def delete_one_children(_values, nodes)
    nodes
  end

  def delete_two_children(_values, nodes)
    return nodes if nodes.left.nil? and nodes.right.nil?

    nodes = nodes.left unless nodes.left.nil?
    if nodes.left.nil?
      nodes
    else
      nodes.left
    end
  end
end

n = Nodes.new(5)
nn = Nodes.new(6)

t = Tree.new([1, 2, 3, 4, 10, 13, 5])
t.pretty_print
t.insert(6)
t.insert(15)
t.insert(12)
t.insert(11)
t.insert(14)
t.insert(16)
t.pretty_print
t.delete(13)
t.pretty_print
