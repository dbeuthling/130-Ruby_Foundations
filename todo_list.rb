# This class represents a todo item and its associated
# data: name and description. There's also a "done" flag
# to show whether this todo item is done.

class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done?
    done
  end

  def done!
    self.done = true
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end
end

class TodoList
  attr_accessor :title

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(item)
    raise TypeError, 'can only add Todo objects' unless item.instance_of? Todo
    @todos << item
  end

  alias_method :<<, :add

  # def to_s
  #   p "---- #{@title} ----"
  #   @todos.each { |item| item.to_s }
  # end

  def to_s
    text = "---- #{title} ----\n"
    text << @todos.map(&:to_s).join("\n")
    text
  end

  def to_a
    @todos
  end

  def size
    @todos.length
  end

  def first
    @todos.first
  end

  def last
    @todos.last
  end

  def item_at(num)
    raise IndexError, "There in no number #{num} in the list" unless @todos[num] != nil
    @todos[num]
  end

  def mark_done_at(num)
    raise IndexError, "There in no number #{num} in the list" unless @todos[num] != nil
    @todos[num].done!
  end

  def mark_undone_at(num)
    raise IndexError, "There in no number #{num} in the list" unless @todos[num] != nil
    @todos[num].undone!
  end

  def shift
    @todos.shift
  end

  def pop
    @todos.pop
  end

  def done?
    @todos.all? { |todo| todo.done? }
  end

  def done!
    @todos.each_index do |idx|
      mark_done_at(idx)
    end
  end

  def remove_at(num)
    raise IndexError, "There in no number #{num} in the list" unless @todos[num] != nil
    @todos.delete_at(num)
  end

  def each
    counter = 0
    while counter < @todos.size do
      yield(@todos[counter])
      counter += 1
    end
    self
  end

#   def select
#     array = []
#     @todos.each do |todo|
#       if yield(todo)
#         array << todo
#       end
#     end
#     array.each { |obj| obj = TodoList.new(obj) }
#   end

  def select
    list = TodoList.new(title)
    each do |todo|
      list.add(todo) if yield(todo)
    end
    list
  end

  def find_by_title(str)
    select { |todo| todo.title == str}.first
  end

  def all_done
    select { |todo| todo.done? }
  end

  def all_not_done
    select { |todo| !todo.done? }
  end

  def mark_done(str)
    each { |todo| todo.done! if todo.title == str }
  end

  def mark_all_done
    each {|todo| todo.done!}
  end

  def mark_all_undone
    each {|todo| todo.undone!}
  end

  # def mark_done(str)
  #   find_by_title(str) && find_by_title(str).done!
  # end

end

# todo1 = Todo.new("Buy milk")
# todo2 = Todo.new("Clean room")
# todo3 = Todo.new("Go to gym")
# todo4 = Todo.new("Pay taxes")
# todo5 = Todo.new("Do Laundry")
# todo6 = Todo.new("Clean up blood")

# list = TodoList.new("Today's Todos")

# puts todo1
# puts todo2
# puts todo3

# list.add(todo1)
# list.add(todo2)
# list.add(todo3)
# list.add(todo4)
# list.add(todo5)
# list.add(todo6)
# list.add(1)
# p list.size
# p list.first
# p list.last
# p list.item_at                    # raises ArgumentError
# p list.item_at(1)                 # returns 2nd item in list (zero based index)
# p list.item_at(100)
# list.mark_done_at
# list.mark_done_at(1)
# list.mark_done_at(100)
# p list.shift
# p list.remove_at                  # raises ArgumentError
# p list.remove_at(1)
# p list.remove_at(100)
# puts list.to_s
# list.each do |todo|
#   todo.done!                   # calls Todo#to_s
# end
# todo1.done!
# results = list.select { |todo| todo.done? }    # you need to implement this method

# puts results.inspect
# puts list.to_s
# puts list.find_by_title("Pay taxes")
# todo6.done!
# puts list.all_done
# puts list.all_not_done
# list.mark_done("Pay taxes")
# puts list
# list.mark_all_undone
# puts list
# list.mark_all_done
# puts list