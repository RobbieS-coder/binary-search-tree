module Deletable
  private

  def leaf_node?(node)
    !(node.left || node.right)
  end

  def single_child_node?(node)
    !!node.left ^ !!node.right
  end

  def double_child_node?(node)
    node.left && node.right
  end

  def delete_leaf_node(node, parent)
    node.value < parent.value ? parent.left = nil : parent.right = nil
  end

  def delete_single_child_node(node, parent)
    child = node.left || node.right

    node.value < parent.value ? parent.left = child : parent.right = child
  end

  def delete_double_child_node(node)
    successor, successor_parent = find_inorder_successor_and_parent(node.right)

    node.value = successor.value

    successor_parent.left = nil
  end

  def find_inorder_successor_and_parent(node)
    successor = node
    successor_parent = nil

    until successor.left.nil?
      successor_parent = successor
      successor = successor.left
    end

    [successor, successor_parent]
  end
end

class Node
  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end

class Tree
  include Deletable

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

  def delete(value)
    node = find(value)
    parent_node = find_parent(value)

    if leaf_node?(node)
      delete_leaf_node(node, parent_node)
    elsif single_child_node?(node)
      delete_single_child_node(node, parent_node)
    elsif double_child_node?(node)
      delete_double_child_node(node)
    else
      return nil
    end

    value
  end

  def find(value, node = @root)
    return if node.nil?
    return node if node.value == value

    node.value > value ? find(value, node.left) : find(value, node.right)
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

  def find_parent(value, node = @root, parent = nil)
    return nil if node.nil?
    return parent if node.value == value

    value < node.value ? find_parent(value, node.left, node) : find_parent(value, node.right, node)
  end
end