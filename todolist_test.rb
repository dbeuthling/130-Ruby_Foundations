require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!
require 'simplecov'
SimpleCov.start

require_relative 'todo_list'

class TodoListTest < MiniTest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  def test_to_a
    assert_equal(@todos, @list.to_a)
  end

  def test_size
    assert_equal(3, @list.size)
  end

  def test_first
    assert_equal(@todo1, @list.first)
  end

  def test_last
    assert_equal(@todo3, @list.last)
  end

  def test_shift
    todo = @list.shift
    assert_equal(@todo1, todo)
    assert_equal([@todo2, @todo3], @list.to_a)
  end

  def test_pop
    todo = @list.pop
    assert_equal(@todo3, todo)
    assert_equal([@todo1, @todo2], @list.to_a)
  end

  def test_done?
    assert_equal(false, @list.done?)
  end

  def test_raise_add
    assert_raises(TypeError) do
      todo = @list.add("Do Dishes")
    end
    assert_raises(TypeError) { @list.add(3) }
    assert_raises(TypeError) { @list.add([@todo1])}
  end

  def test_add_alias
    add = @list.add(@todo1)
    als = @list << @todo1
    assert_equal(add, als)
  end

  def test_item_at
    assert_raises(IndexError) { @list.item_at(6) }
    assert_equal(@todo1, @list.item_at(0))
    assert_equal(@todo3, @list.item_at(2))
  end

  def test_mark_done_at
    assert_raises(IndexError) { @list.mark_done_at(23) }
    @list.mark_done_at(0)
    assert_equal(true, @todo1.done?)
    assert_equal(false, @todo2.done?)
  end

  def test_mark_undone_at
    assert_raises(IndexError) { @list.mark_undone_at(43) }
    @todo1.done!
    @list.mark_undone_at(0)
    assert_equal(false, @todo1.done?)
  end

  def test_done!
    @list.done!
    assert_equal(true, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(true, @todo3.done?)
    assert_equal(true, @list.done?)
  end

  def test_remove_at
    assert_raises(IndexError) { @list.remove_at(33) }
    @list.remove_at(0)
    assert_equal(2, @list.size)
    assert_equal([@todo2, @todo3], @list.to_a)
  end

  def test_to_s
    output = <<-OUTPUT.chomp.gsub /^\s+/, ""
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT

    assert_equal(output, @list.to_s)
  end

  def test_to_s_one_done
    @todo2.done!
    output = <<-OUTPUT.chomp.gsub /^\s+/, ""
    ---- Today's Todos ----
    [ ] Buy milk
    [X] Clean room
    [ ] Go to gym
    OUTPUT

    assert_equal(output, @list.to_s)
  end

  def test_to_s_all_done
    @list.done!
    output = <<-OUTPUT.chomp.gsub /^\s+/, ""
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT

    assert_equal(output, @list.to_s)
  end

  def test_each
    @list.each { |todo| todo.done! }
    assert_equal(true, @todo1.done?)
    assert_equal(true, @todo2.done?)
    assert_equal(true, @todo3.done?)
  end

  def test_each_return_original_obj
    value = @list.each { |todo| todo }
    assert_equal(@list, value)
  end

  def test_select
    @todo1.done!
    done_list = @list.select { |todo| todo.done? }
    assert_equal(1, done_list.size)
    assert_equal([@todo1], done_list.to_a)
  end

  def test_find_by_title
    assert_equal(@todo1, @list.find_by_title("Buy milk"))
  end

  def test_all_done
    @todo1.done!
    @todo2.done!
    done_list = @list.all_done
    assert_equal(2, done_list.size)
  end

  def test_all_not_done
    @todo1.done!
    @todo2.done!
    not_done_list = @list.all_not_done
    assert_equal(1, not_done_list.size)
  end

  def test_mark_done_with_arg
    @list.mark_done("Buy milk")
    assert_equal(true, @todo1.done?)
  end

  def test_change_list_title
    @list.title = "Changed"
    assert_equal("Changed", @list.title)
  end

end
