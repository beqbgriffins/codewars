# frozen_string_literal: true

# https://www.codewars.com/kata/58acf6c20b3b251d6d00002d/ruby
def rocks(n)
  return n if n < 10

  n_length = n.to_s.length
  rank = n_length - 1
  # calculate symbols for the first n rank (10, 100, 1000, etc)
  syms_on_first_rank = ((rank * 10**(rank - 1) - ('1' * (rank - 1)).to_i).to_s + rank.to_s).to_i
  # calculate symbols between ranks (10-20, 100-200, 1000-2000, etc)
  syms_by_rank = (n_length * 10**rank)

  # and sum it with symbols for the first n rank
  first_digit = n.to_s[0].to_i
  syms_on_current_rank = (first_digit - 1) * syms_by_rank + syms_on_first_rank

  # calculate symbols needs by remainder of n
  remainder = n.to_s[1..].to_i * n_length

  syms_on_current_rank + remainder
end
