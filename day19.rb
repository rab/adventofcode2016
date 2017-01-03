# coding: utf-8
# --- Day 19: An Elephant Named Joseph ---
#
# The Elves contact you over a highly secure emergency channel. Back at the North Pole, the Elves
# are busy misunderstanding White Elephant parties.
#
# Each Elf brings a present. They all sit in a circle, numbered starting with position 1. Then,
# starting with the first Elf, they take turns stealing all the presents from the Elf to their
# left.  An Elf with no presents is removed from the circle and does not take turns.
#
# For example, with five Elves (numbered 1 to 5):
#
#   1
# 5   2
#  4 3
#
#
# Elf 1 takes Elf 2's present.
# Elf 2 has no presents and is skipped.
# Elf 3 takes Elf 4's present.
# Elf 4 has no presents and is also skipped.
# Elf 5 takes Elf 1's two presents.
# Neither Elf 1 nor Elf 2 have any presents, so both are skipped.
# Elf 3 takes Elf 5's three presents.
#
# So, with five Elves, the Elf that sits starting in position 3 gets all the presents.
#
# With the number of Elves given in your puzzle input, which Elf gets all the presents?
#

require_relative 'input'

# day = __FILE__[/\d+/].to_i(10)
# input = Input.for_day(day)
input = 3005290

# puts "solving day #{day} from input:\n#{input}"

# After a hint from Nate Denlinger that this
# was [The Josephus Problem](https://www.youtube.com/watch?v=uCsD3ZGzMgE) and using my naive, but
# correct code to explore the patterns of initial elves to the winning elf, I came up with the
# '1fast' and '2fast' solutions

winner = nil

which = ARGV.shift

case which
when '1naive'
  elves = Array.new(input) {|i| i+1 }
  until elves.count == 1
    elves.slice!(1,1)
    elves.push elves.shift
  end
  winner = elves.first
when '1fast', nil
  winner = input.to_s(2).split(//).rotate.join.to_i(2)
end

puts "With #{input} elves taking from left, elf #{winner} gets all" if winner

case which
when '2naive'
  # Part 2
  # just as naive
  elves = Array.new(input) {|i| i+1 }

  until (remaining = elves.count) == 1
    steal_from = remaining / 2
    elves.slice!(steal_from,1)
    elves.push elves.shift
  end
  winner = elves.first
when '2fast', nil
  # puts "  n |  b3    |  W(n) |  Wb3"
  # puts "----|--------|-------|--------"
  # 1.upto(ARGV.shift.to_i) do |j|
  #   elves = Array.new(j) {|i| i+1 }

  #   until (remaining = elves.count) == 1
  #     steal_from = remaining / 2
  #     elves.slice!(steal_from,1)
  #     elves.push elves.shift
  #   end
  #   winner = elves.first
  j = input
    digits = j.to_s(3).split(//)
    case digits.first
    when "1"
      predicted = digits[1..-1].join.to_i(3)
      predicted = j if predicted.zero?
    when "2"
      base = ("1" + "0"*(digits.size - 1)).to_i(3)
      predicted = 2 * j - 3 * base
    end
    # print "%3d | %5s | %3d | %5s"%[j, j.to_s(3), winner, winner.to_s(3)]
    # if predicted == winner
    #   puts " √"
    # else
    #   puts
    # end
  # end
    winner = predicted
end

puts "With #{input} elves taking from across, elf #{winner} gets all" if winner
