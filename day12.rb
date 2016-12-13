# --- Day 12: Leonardo's Monorail ---
#
# You finally reach the top floor of this building: a garden with a slanted glass ceiling. Looks
# like there are no more stars to be had.
#
# While sitting on a nearby bench amidst some tiger lilies, you manage to decrypt some of the
# files you extracted from the servers downstairs.
#
# According to these documents, Easter Bunny HQ isn't just this building - it's a collection of
# buildings in the nearby area. They're all connected by a local monorail, and there's another
# building not far from here! Unfortunately, being night, the monorail is currently not operating.
#
# You remotely connect to the monorail control systems and discover that the boot sequence expects
# a password. The password-checking logic (your puzzle input) is easy to extract, but the code it
# uses is strange: it's assembunny code designed for the new computer you just assembled. You'll
# have to execute the code and get the password.
#
# The assembunny code you've extracted operates on four registers (a, b, c, and d) that start at 0
# and can hold any integer. However, it seems to make use of only a few instructions:
#
#
# cpy x y copies x (either an integer or the value of a register) into register y.
# inc x increases the value of register x by one.
# dec x decreases the value of register x by one.
# jnz x y jumps to an instruction y away (positive means forward; negative means backward), but only if x is not zero.
#
# The jnz instruction moves relative to itself: an offset of -1 would continue at the previous
# instruction, while an offset of 2 would skip over the next instruction.
#
# For example:
#
# cpy 41 a
# inc a
# inc a
# dec a
# jnz a 2
# dec a
#
# The above code would set register a to 41, increase its value by 2, decrease its value by 1, and
# then skip the last dec a (because a is not zero, so the jnz a 2 skips it), leaving register a at
# 42. When you move past the last instruction, the program halts.
#
# After executing the assembunny code in your puzzle input, what value is left in register a?
#

require_relative 'input'

day = __FILE__[/\d+/].to_i(10)
input = Input.for_day(day)

# input = <<-EOL
# cpy 41 a
# inc a
# inc a
# dec a
# jnz a 2
# dec a
# EOL

# puts "solving day #{day} from input\n#{input.inspect}"

class Asm
  def initialize
    @stmts = []
    @pc = 0
    @a = @b = @c = @d = 0
  end

  def <<(stmt)
    @stmts << stmt
  end

  def perform(stmt)
    case stmt
    when /^cpy ([a-d]) ([a-d])$/
      src = "@#{$1}"
      dst = "@#{$2}"
      instance_variable_set(dst, instance_variable_get(src))
      @pc += 1

    when /^cpy (-?\d+) ([a-d])$/
      src = $1.to_i
      dst = "@#{$2}"
      instance_variable_set(dst, src)
      @pc += 1

    when /^inc ([a-d])$/
      src = dst = "@#{$1}"
      instance_variable_set(dst, instance_variable_get(src) + 1)
      @pc += 1

    when /^dec ([a-d])$/
      src = dst = "@#{$1}"
      instance_variable_set(dst, instance_variable_get(src) - 1)
      @pc += 1

    when /^jnz ([a-d]) (-?\d+)$/
      src = "@#{$1}"
      offset = $2.to_i
      @pc += instance_variable_get(src).nonzero? ? offset : 1

    when /^jnz (-?\d+) (-?\d+)$/
      src = $1.to_i
      offset = $2.to_i
      @pc += src.nonzero? ? offset : 1
    end
  end

  def run
    while @stmts[@pc]
      perform @stmts[@pc]
      # print " a: %9d  b: %9d  c: %9d  d: %9d   pc: %9d  next: %-40s \r"%[@a, @b, @c, @d, @pc, @stmts[@pc]]; sleep 0.1
    end
    @a
  end

  def reset(a,b,c,d)
    @a = a
    @b = b
    @c = c
    @d = d
    @pc = 0
    self
  end
end

machine = Asm.new
input.each_line do |stmt|
  machine << stmt
end

puts machine.run

# --- Part Two ---
#
# As you head down the fire escape to the monorail, you notice it didn't start; register c needs
# to be initialized to the position of the ignition key.
#
# If you instead initialize register c to be 1, what value is now left in register a?

puts machine.reset(0,0,1,0).run
