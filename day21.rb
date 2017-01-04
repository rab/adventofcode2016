# --- Day 21: Scrambled Letters and Hash ---
#
# The computer system you're breaking into uses a weird scrambling function to store its passwords. It
# shouldn't be much trouble to create your own scrambled password so you can add it to the system;
# you just have to implement the scrambler.
#
# The scrambling function is a series of operations (the exact list is provided in your puzzle
# input). Starting with the password to be scrambled, apply each operation in succession to the
# string. The individual operations behave as follows:
#
#
# swap position X with position Y means that the letters at indexes X and Y (counting from 0)
# should be swapped.
# swap letter X with letter Y means that the letters X and Y should be swapped (regardless of
# where they appear in the string).
# rotate left/right X steps means that the whole string should be rotated; for example, one right
# rotation would turn abcd into dabc.
# rotate based on position of letter X means that the whole string should be rotated to the right
# based on the index of letter X (counting from 0) as determined before this instruction does any
# rotations.  Once the index is determined, rotate the string to the right one time, plus a number
# of times equal to that index, plus one additional time if the index was at least 4.
# reverse positions X through Y means that the span of letters at indexes X through Y (including
# the letters at X and Y) should be reversed in order.
# move position X to position Y means that the letter which is at index X should be removed from
# the string, then inserted such that it ends up at index Y.
#
# For example, suppose you start with abcde and perform the following operations:
#
# - swap position 4 with position 0 swaps the first and last letters, producing the input for the
#   next step, ebcda.
# - swap letter d with letter b swaps the positions of d and b: edcba.
# - reverse positions 0 through 4 causes the entire string to be reversed, producing abcde.
# - rotate left 1 step shifts all letters left one position, causing the first letter to wrap to
#   the end of the string: bcdea.
# - move position 1 to position 4 removes the letter at position 1 (c), then inserts it at
#   position 4 (the end of the string): bdeac.
# - move position 3 to position 0 removes the letter at position 3 (a), then inserts it at
#   position 0 (the front of the string): abdec.
# - rotate based on position of letter b finds the index of letter b (1), then rotates the string
#   right once plus a number of times equal to that index (2): ecabd.
# - rotate based on position of letter d finds the index of letter d (4), then rotates the string
#   right once, plus a number of times equal to that index, plus an additional time because the
#   index was at least 4, for a total of 6 right rotations: decab.
#
# After these steps, the resulting scrambled password is decab.
#
# Now, you just need to generate a new scrambled password and you can access the system. Given the
# list of scrambling operations in your puzzle input, what is the result of scrambling abcdefgh?
#
# --- Part Two ---
#
# You scrambled the password correctly, but you discover that you can't actually modify the
# password file on the system. You'll need to un-scramble one of the existing passwords by
# reversing the scrambling process.
#
# What is the un-scrambled version of the scrambled password fbgdceah?

require_relative 'input'

day = __FILE__[/\d+/].to_i(10)
input = Input.for_day(day)

# puts "solving day #{day} from input:\n#{input}"

class Password
  def initialize(starting="abcdefgh")
    @pw = starting
  end

  def perform(command)
    case command
    when /move position (\d+) to position (\d+)/
      from = $1.to_i
      to = $2.to_i
      c = @pw.slice!(from,1)
      @pw[to,0] = c

    when /reverse positions (\d+) through (\d+)/
      from = $1.to_i
      to = $2.to_i
      @pw[from..to] = @pw[from..to].reverse

    when /rotate based on position of letter (.)/
      c = $1
      p = @pw.index(c)
      i = 1 + p
      i += 1 if p >= 4
      i = i % @pw.length
      @pw[0,0] = @pw.slice!(-i,i)

    when /rotate left (\d+) steps?/
      i = $1.to_i
      @pw << @pw.slice!(0,i)

    when /rotate right (\d+) steps?/
      i = $1.to_i
      @pw[0,0] = @pw.slice!(-i,i)

    when /swap letter (.) with letter (.)/
      from = $1
      to = $2
      @pw.tr!("#{from}#{to}", "#{to}#{from}")

    when /swap position (\d+) with position (\d+)/
      from = $1.to_i
      to = $2.to_i
      @pw[to,1], @pw[from,1] = @pw[from,1], @pw[to,1]

    else
      fail "Unrecognized: #{command}"
    end

    @pw
  end

  def to_s
    @pw.dup
  end

  def unperform(command)
    case command
    when /move position (\d+) to position (\d+)/
      from = $1.to_i
      to = $2.to_i
      c = @pw.slice!(from,1)
      @pw[to,0] = c

    when /reverse positions (\d+) through (\d+)/
      from = $1.to_i
      to = $2.to_i
      @pw[from..to] = @pw[from..to].reverse

    when /rotate based on position of letter (.)/
      # FIXME: eval pos of c
      #  0 1 2 3
      # --------
      #  6 7 4 5
      c = $1
      p = @pw.index(c)
      if p.even?
        :bad
      else
        i = { 1 => [0,6],
              3 => [1,7],
              5 => [2,4],
              7 => [3,5],
            }[p]
        # rotate right by: .all? i-p
      end

      i = 1 + p
      i += 1 if p >= 4
      i = i % @pw.length
      @pw[0,0] = @pw.slice!(-i,i)

    when /rotate left (\d+) steps?/
      i = $1.to_i
      @pw[0,0] = @pw.slice!(-i,i)

    when /rotate right (\d+) steps?/
      i = $1.to_i
      @pw << @pw.slice!(0,i)

    when /swap letter (.) with letter (.)/
      from = $1
      to = $2
      @pw.tr!("#{from}#{to}", "#{to}#{from}")

    when /swap position (\d+) with position (\d+)/
      from = $1.to_i
      to = $2.to_i
      @pw[to,1], @pw[from,1] = @pw[from,1], @pw[to,1]

    else
      fail "Unrecognized: #{command}"
    end

    @pw
  end

end

# input = <<-EOL
# swap position 4 with position 0
# swap letter d with letter b
# reverse positions 0 through 4
# rotate left 1 step
# move position 1 to position 4
# move position 3 to position 0
# rotate based on position of letter b
# rotate based on position of letter d
# EOL
# expected = 'decab'

pw = Password.new               # ('abcde')
input.each_line do |command|
  command.chomp!
  print "#{pw} -> #{command} = "
  puts pw.perform(command)
end

# fail "expected #{expected}" unless expected == pw.to_s

# Your puzzle answer was baecdfgh.

# --- Part Two ---

final = 'fbgdceah'

sc = Password.new(final)

input.each_line.reverse_each do |command|
  command.chomp!
  print "#{sc} = #{command} <- "
  puts sc.unperform(command)
end
