# frozen_string_literal: true

# https://www.codewars.com/kata/57ba58d68dcd97e98c00012b/ruby
require 'prime'
def prime_primes(n)
  primes = []
  results = []
  Prime.each(n-1) {|x| primes << x}
  primes.each_with_index do |v,i|
    primes[i+1..].each{|x| results << Rational(v,x)}
  end
  [results.size, results.sum.to_i]
end
#
prime_primes(6)
prime_primes(4)
prime_primes(10)
prime_primes(65)
prime_primes(0)
prime_primes(1000)
prime_primes(666)
prime_primes(937)