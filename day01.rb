# --- Day 1: No Time for a Taxicab ---
#
# Santa's sleigh uses a very high-precision clock to guide its movements, and the clock's
# oscillator is regulated by stars. Unfortunately, the stars have been stolen... by the Easter
# Bunny. To save Christmas, Santa needs you to retrieve all fifty stars by December 25th.
#
# Collect stars by solving puzzles. Two puzzles will be made available on each day in the advent
# calendar; the second puzzle is unlocked when you complete the first. Each puzzle grants one
# star. Good luck!
#
# You're airdropped near Easter Bunny Headquarters in a city somewhere. "Near", unfortunately, is
# as close as you can get - the instructions on the Easter Bunny Recruiting Document the Elves
# intercepted start here, and nobody had time to work them out further.
#
# The Document indicates that you should start at the given coordinates (where you just landed)
# and face North. Then, follow the provided sequence: either turn left (L) or right (R) 90
# degrees, then walk forward the given number of blocks, ending at a new intersection.
#
# There's no time to follow such ridiculous instructions on foot, though, so you take a moment and
# work out the destination. Given that you can only walk on the street grid of the city, how far
# is the shortest path to the destination?
#
# For example:
#
# Following R2, L3 leaves you 2 blocks East and 3 blocks North, or 5 blocks away.
# R2, R2, R2 leaves you 2 blocks due South of your starting position, which is 2 blocks away.
# R5, L5, R5, R3 leaves you 12 blocks away.
# How many blocks away is Easter Bunny HQ?
#
# --- Part Two ---
#
# Then, you notice the instructions continue on the back of the Recruiting Document. Easter Bunny
# HQ is actually at the first location you visit twice.
#
# For example, if your instructions are R8, R4, R4, R8, the first location you visit twice is 4
# blocks away, due East.
#
# How many blocks away is the first location you visit twice?

require_relative 'input'

day = __FILE__[/\d+/].to_i(10)
input = Input.for_day(day)

# puts "solving day #{day} from input\n#{input.inspect}"

position = [0,0]
direction = 'N'
turn = {
  'N' => { 'R' => 'E', 'L' => 'W' },
  'E' => { 'R' => 'S', 'L' => 'N' },
  'S' => { 'R' => 'W', 'L' => 'E' },
  'W' => { 'R' => 'N', 'L' => 'S' },
}
shift = {
  'N' => [ 0,+1],
  'E' => [+1, 0],
  'S' => [ 0,-1],
  'W' => [-1, 0],
}

turns = input.scan(/([LR])(\d+)/)

module NyDist
  def blocks
    map(&:abs).reduce(:+)
  end
end
Array.send(:include, NyDist)

visited = []
visited << position
revisits = nil
turns.each do |t,d|
  direction = turn[direction][t]
  d.to_i.times do
    position = position.zip(shift[direction]).map{|pos,delta| pos+delta}
    unless revisits
      if visited.include?(position)
        puts "Revisiting #{position.inspect} at #{position.blocks} blocks"
        revisits = position
      end
      visited << position
    end
  end
end
puts "Ending #{position.inspect} at #{position.blocks}"
