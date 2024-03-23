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
    @root = build_tree(@arr, 0, @arr.length - 1)
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
    arr.delete(values)
    self
  end

  def delete_at(values, nodes = @root)
    if nodes.value == values
      if !nodes.right.nil? and !nodes.left.nil?
        nodes.value = delete_two_children(values, nodes.right).value
        nodes.right = delete_at(nodes.value, nodes.right)
        return nodes
      elsif !nodes.right.nil?
        return delete_one_children(values, nodes.right) if nodes.right.left.nil?

        nodes.value = delete_two_children(values, nodes.right).value

        nodes.right = delete_at(nodes.value, nodes.right)

        return nodes

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

  def find(values, _nodes = @root)
    find_at(values, nodes = @root)
  end

  def find_at(values, nodes = @root)
    if nodes.value == values
      return nodes
    elsif nodes.value < values
      return find_at(values, nodes.right)
    elsif nodes.value > values
      return find_at(values, nodes.left)
    end

    nodes
  end

  def level_order(nodes = @root, arr = [])
        if nodes == nil
          return
        end
        result=[]
        arr.push(nodes)
        while arr.length!=0
          result.push(arr[0].value)
          if arr[0].left!=nil
          arr.push(arr[0].left)
          end
          if arr[0].right!=nil
          arr.push(arr[0].right)
          end
          arr.shift()
        end
      return result
  end

  def in_order()
    newArr = in_order_by(nodes=@root)
    return newArr
  end

  def in_order_by(nodes=@root,arr =[])
    temp = nodes
    if temp == nil
      return
    elsif temp.left==nil and temp.right == nil
      arr.push(temp.value)
      return temp
    else

      in_order_by(temp.left,arr)
      arr.push(temp.value)

      in_order_by(temp.right,arr)

    end
    return arr
  end

  def pre_order()
      pre_order_by(nodes=@root)
  end

  def pre_order_by(nodes=@root,arr=[])
    temp = nodes
      if temp == nil
        return nil
      elsif temp.left==nil and temp.right == nil
        arr.push(temp.value)
        return temp
      else
        arr.push(temp.value)
        pre_order_by(temp.left,arr)
        pre_order_by(temp.right,arr)
      end
    return arr
  end

  def post_order()
      post_order_by(nodes=@root)
  end

  def post_order_by(nodes=@root,arr=[])
      if nodes == nil
        return
      elsif nodes.left==nil and nodes.right == nil
        arr.push(nodes.value)
        return nodes
      else
        post_order_by(nodes.left,arr)
        post_order_by(nodes.right,arr)
        arr.push(nodes.value)
      end
    return arr
  end

  def height(value=nil)
      if value == nil
        return height_of(nodes=@root) - 1
      else
      newNode = self.find(value)
      return height_of(nodes=newNode) - 1
      end
  end

  def height_of(nodes)
      if nodes == nil
        return 0
      else
        leftHeight = height_of(nodes.left)
        rightHeight = height_of(nodes.right)
        if leftHeight > rightHeight
          return leftHeight + 1
        else
          return rightHeight + 1
        end
      end
  end

  def depth(values=nil,nodes=@root)
    if values == nil
      return 0
    else
    depth_of(values,nodes=@root)
    end
  end

  def depth_of(values,nodes=@root)
    if values == nodes.value
        return 0
    else
      if(values>nodes.value)
          return depth_of(values,nodes.right) + 1
      elsif(values<nodes.value)
         return  depth_of(values,nodes.left)  + 1
      end
    end
  end

  def balanced(nodes=@root)
    if nodes.left == nil or nodes.right == nil
      p "balanced"
      return
    end
    if (height(nodes.left.value)==height(nodes.right.value))
      p " balanced"
    else
      p "not balanced"
    end
  end

  def rebalance
    self.root.value = inorder_array
    self.root = build_tree(arr,0,inorder_array.length - 1)
  end

  def inorder_array(node = @root, array = [])
    unless node.nil?
      inorder_array(node.left, array)
      array << node.value
      inorder_array(node.right, array)
    end
    array
  end

end

t = Tree.new((Array.new(15) {rand(1..100) }))
 t.pretty_print
 t.balanced()
p t.level_order
p  t.pre_order
p t.post_order
  p t.in_order

  t.insert(117)
 t.pretty_print
t.balanced()
 t.rebalance()
 t.pretty_print
t.balanced()
p t.level_order
p  t.pre_order
p t.post_order
  p t.in_order
