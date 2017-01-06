# --- Day 17: Two Steps Forward ---
#
# You're trying to access a secure vault protected by a 4x4 grid of small rooms connected by
# doors. You start in the top-left room (marked S), and you can access the vault (marked V) once
# you reach the bottom-right room:
#
# #########
# #S| | | #
# #-#-#-#-#
# # | | | #
# #-#-#-#-#
# # | | | #
# #-#-#-#-#
# # | | |
# ####### V
#
# Fixed walls are marked with #, and doors are marked with - or |.
#
# The doors in your current room are either open or closed (and locked) based on the hexadecimal
# MD5 hash of a passcode (your puzzle input) followed by a sequence of uppercase characters
# representing the path you have taken so far (U for up, D for down, L for left, and R for right).
#
# Only the first four characters of the hash are used; they represent, respectively, the doors up,
# down, left, and right from your current position. Any b, c, d, e, or f means that the
# corresponding door is open; any other character (any number or a) means that the corresponding
# door is closed and locked.
#
# To access the vault, all you need to do is reach the bottom-right room; reaching this room opens
# the vault and all doors in the maze.
#
# For example, suppose the passcode is hijkl. Initially, you have taken no steps, and so your path
# is empty: you simply find the MD5 hash of hijkl alone. The first four characters of this hash
# are ced9, which indicate that up is open (c), down is open (e), left is open (d), and right is
# closed and locked (9). Because you start in the top-left corner, there are no "up" or "left"
# doors to be open, so your only choice is down.
#
# Next, having gone only one step (down, or D), you find the hash of hijklD. This produces f2bc,
# which indicates that you can go back up, left (but that's a wall), or right. Going right means
# hashing hijklDR to get 5745 - all doors closed and locked. However, going up instead is
# worthwhile: even though it returns you to the room you started in, your path would then be DU,
# opening a different set of doors.
#
# After going DU (and then hashing hijklDU to get 528e), only the right door is open; after going
# DUR, all doors lock. (Fortunately, your actual passcode is not hijkl).
#
# Passcodes actually used by Easter Bunny Vault Security do allow access to the vault if you know
# the right path.  For example:
#
# - If your passcode were ihgpwlah, the shortest path would be DDRRRD.
# - With kglvqrro, the shortest path would be DDUDRLRRUDRD.
# - With ulqzkmiv, the shortest would be DRURDRUDDLLDLUURRDULRLDUUDDDRR.
#
# Given your vault's passcode, what is the shortest path (the actual path, not just the length) to
# reach the vault?
#
# Your puzzle input is dmypynyp.
#
# --- Part Two ---
#
# You're curious how robust this security solution really is, and so you decide to find longer and
# longer paths which still provide access to the vault. You remember that paths always end the
# first time they reach the bottom-right room (that is, they can never pass through it, only end
# in it).
#
# For example:
#
# If your passcode were ihgpwlah, the longest path would take 370 steps.
# With kglvqrro, the longest path would be 492 steps long.
# With ulqzkmiv, the longest path would be 830 steps long.
#
# What is the length of the longest path that reaches the vault?


require_relative 'input'

require 'digest/md5'

day = __FILE__[/\d+/].to_i(10)
input = 'dmypynyp' # Input.for_day(day)


class Position
  attr_accessor :x, :y
  def initialize(x=0, y=0)
    @x = x
    @y = y
  end
  def valid?
    (0..3).cover?(@x) && (0..3).cover?(@y)
  end
  def +(other)
    fail unless self.class === other
    self.class.new(@x+other.x, @y+other.y)
  end
  def vault?
    @x==3 && @y==3
  end
end

class Path
  # Idea: Path has_a Position
  #       and  has_a route (string /[UDLR]*/)
  attr_reader :position, :route

  def initialize(passcode, route, position=Position.new)
    @passcode = passcode
    @route = route
    @position = position
  end

  # #options => Array[Path]
  def options
    md5 = Digest::MD5.hexdigest("#{@passcode}#{route}")
    doors_open = Hash[ %w[U D L R].zip(md5[0,4].split(//).map {|c| /[bcdef]/.match?(c) }) ]
    doors_open.map {|direction,unlocked|
      next unless unlocked
      move(direction)
    }.compact
  end

  MOVE = { 'U' => Position.new( 0,-1),
           'D' => Position.new( 0, 1),
           'L' => Position.new(-1, 0),
           'R' => Position.new( 1, 0),
         }.freeze
  # #move(direction) => returns new Path if valid? else nil
  def move(direction)
    fail "direction to move must be one of 'U', 'D', 'L', or 'R'" unless /[UDLR]/.match(direction)
    new_position = position + MOVE[direction]
    if new_position.valid?
      self.class.new(@passcode, route + direction, new_position)
    end
  end

  def valid?
    position.valid?
  end

  def length
    route.length
  end

  def complete?
    position.vault?
  end
end

def shortest_for(passcode, route="", position=Position.new)
  attempts = [Path.new(passcode, route, position)]
  until (vault = attempts.detect {|path| path.complete? })
    from = attempts.shift
    attempts.concat from.options
  end
  # puts "%s%s %s"%[passcode, vault.route, vault.length]
  vault.route
end

def longest_for(passcode, route="", position=Position.new)
  attempts = [Path.new(passcode, route, position)]
  longest_so_far = nil
  until attempts.empty?
    completes, incompletes = attempts.partition {|path| path.complete? }
    unless completes.empty?
      candidate = completes.max_by {|complete| complete.length }
      if longest_so_far.nil? || candidate.length > longest_so_far.length
        longest_so_far = candidate
      end
    end
    attempts = incompletes.map(&:options).flatten
  end
  # puts "%s%s %s"%[passcode, vault.route, vault.length]
  longest_so_far.route
end

if ARGV.shift == 'sample'
  aok = true
  [
    [ 'ihgpwlah', 'DDRRRD', 370 ],
    [ 'kglvqrro', 'DDUDRLRRUDRD', 492 ],
    [ 'ulqzkmiv', 'DRURDRUDDLLDLUURRDULRLDUUDDDRR', 830 ],
  ].each do |sample, expected_shortest, length_longest|
    unless (actual = shortest_for sample) == expected_shortest
      puts "For #{sample},"
      puts "expected #{expected_shortest}"
      puts "but gave #{actual}"
      aok = false
    end
    unless (length = longest_for(sample).length) == length_longest
      puts "For #{sample},"
      puts "expected #{length_longest}"
      puts "but gave #{length}"
      aok = false
    end
  end
  exit unless aok
end

puts "solving day #{day} from input:\n#{input}"

print "Shortest route: "
puts shortest_for(input)

print "Longest route has #{longest_for(input).length} moves"
