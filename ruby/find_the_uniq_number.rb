# frozen_string_literal: true

# https://www.codewars.com/kata/585d7d5adb20cf33cb000235/ruby
# this complexity is o(n)
def find_uniq(arr)
  first, last, second = arr.first, arr.last, arr[1]
  if first == last
    arr.each do |x|
      next if first == x

      return x
    end
  else
    return first if last == second

    last
  end
end

pp find_uniq([1,1,1,1,0])
pp find_uniq([ 1, 1, 1, 2, 1, 1 ])
pp find_uniq([ 0, 0, 0.55, 0, 0 ])