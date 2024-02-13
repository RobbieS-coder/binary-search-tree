class Node
  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end

class Tree
  def initialize(arr)
    @root = build_tree(arr.uniq.sort)
  end

  def build_tree(arr)
    return nil if arr.empty?
    return Node.new(arr[0]) if arr.length == 1

    mid = arr.length / 2
    root = Node.new(arr[mid])

    root.left = build_tree(arr[0...mid])
    root.right = build_tree(arr[mid + 1..-1])

    root
  end

  def insert(value, node = @root)
    return nil if contains?(value)

    return Node.new(value) if node.nil?

    node.left = insert(value, node.left) if value < node.value
    node.right = insert(value, node.right) if value > node.value

    node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private

  def contains?(value, node = @root)
    return false if node.nil?
    return true if value == node.value

    contains?(value, node.left) || contains?(value, node.right)
  end
end