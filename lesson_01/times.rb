
# def times(number)
#   counter = 0
#   while counter < number do
#     yield(counter)
#     counter += 1
#   end

#   number
# end


# times(5) do |num|
#   puts num
# end


# p [1, 2, 3].each { |num| "do nothing" }.select{ |num| num.odd? }


# def each(array)
#   counter = 0

#   while counter < array.size
#     yield(array[counter])
#     counter += 1
#   end
#   array
# end

# arr = [1, 2, 3, 5]

# p each(arr) { |num| puts num.odd? }

# def select(array)
#   counter = 0
#   new_array = []

#   while counter < array.size
#     if yield(array[counter])
#       new_array << array[counter]
#     end
#     counter += 1
#   end
#   new_array
# end

# array = [1, 2, 3, 4, 5]

# p select(array) { |num| num.odd? }      # => [1, 3, 5]
# p select(array) { |num| puts num }      # => [], because "puts num" returns nil and evaluates to false
# p select(array) { |num| num + 1 }       # => [1, 2, 3, 4, 5], because "num + 1" evaluates to true

def reduce(array, total=0)
  counter = 0
  while counter < array.size
    total = yield(total, array[counter])
    counter += 1
  end
  total
end

array = [1, 2, 3, 4, 5]

p reduce(array) { |acc, num| acc + num }
p reduce(array, 10) { |acc, num| acc + num }
p reduce(array) { |acc, num| acc + num if num.odd? }