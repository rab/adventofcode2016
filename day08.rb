# --- Day 8: Two-Factor Authentication ---
#
# You come across a door implementing what you can only assume is an implementation of two-factor
# authentication after a long game of requirements telephone.
#
# To get past the door, you first swipe a keycard (no problem; there was one on a nearby
# desk). Then, it displays a code on a little screen, and you type that code on a keypad. Then,
# presumably, the door unlocks.
#
# Unfortunately, the screen has been smashed. After a few minutes, you've taken everything apart
# and figured out how it works. Now you just have to work out what the screen would have
# displayed.
#
# The magnetic strip on the card you swiped encodes a series of instructions for the screen; these
# instructions are your puzzle input. The screen is 50 pixels wide and 6 pixels tall, all of which
# start off, and is capable of three somewhat peculiar operations:
#
#
# rect AxB turns on all of the pixels in a rectangle at the top-left of the screen which is A wide
# and B tall.
#
# rotate row y=A by B shifts all of the pixels in row A (0 is the top row) right by B
# pixels. Pixels that would fall off the right end appear at the left end of the row.
#
# rotate column x=A by B shifts all of the pixels in column A (0 is the left column) down by B
# pixels. Pixels that would fall off the bottom appear at the top of the column.
#
# For example, here is a simple sequence on a smaller screen:
#
# rect 3x2 creates a small rectangle in the top-left corner:
# ###....
# ###....
# .......
#
# rotate column x=1 by 1 rotates the second column down by one pixel:
# #.#....
# ###....
# .#.....
#
# rotate row y=0 by 4 rotates the top row right by four pixels:
# ....#.#
# ###....
# .#.....
#
# rotate column x=1 by 1 again rotates the second column down by one pixel, causing the bottom pixel
# to wrap back to the top:
# .#..#.#
# #.#....
# .#.....
#
# As you can see, this display technology is extremely powerful, and will soon dominate the
# tiny-code-displaying-screen market.  That's what the advertisement on the back of the display
# tries to convince you, anyway.
#
# There seems to be an intermediate check of the voltage used by the display: after you swipe your
# card, if the screen did work, how many pixels should be lit?
#
# Your puzzle answer was 116.
#
# --- Part Two ---
#
# You notice that the screen is only capable of displaying capital letters; in the font it uses,
# each letter is 5 pixels wide and 6 tall.
#
# After you swipe your card, what code is the screen trying to display?
#
# Your puzzle answer was UPOJFLBCEZ.

require_relative 'input'

day = __FILE__[/\d+/].to_i(10)
input = Input.for_day(day)

# puts "solving day #{day} from input\n#{input.inspect}"

class Display
  def initialize(cols=50, rows=6)
    @display = Array.new(rows) { Array.new(cols, '.') }
  end

  # rect AxB
  # turns on all of the pixels in a rectangle at the top-left
  # of the screen which is A wide and B tall.
  def rect(wide, tall)
    tall.times do |row|
      wide.times do |col|
        @display[row][col] = '#'
      end
    end
    self
  end

  # rotate row y=A by B
  # shifts all of the pixels in row A (0 is the top row) right by B pixels.
  # Pixels that would fall off the right end appear at the left end of the row.
  def row(row, by)
    by.times { @display[row].unshift @display[row].pop }
    self
  end

  # rotate column x=A by B
  # shifts all of the pixels in column A (0 is the left column) down by B pixels.
  # Pixels that would fall off the bottom appear at the top of the column.
  def column(col, by)
    tmp = @display.map {|row| row[col] }.join
    by.times { tmp[0,0]= tmp[-1]; tmp.chop! }
    tmp.each_char.with_index {|c,i| @display[i][col] = c }
    self
  end

  def to_s
    @display.map {|row| row.join }.join("\n")
  end

  def count
    @display.map {|row| row.count('#') }.reduce(:+)
  end
end

# display = Display.new(7,3)
# input = <<-EOL
# rect 3x2
# rotate column x=1 by 1
# rotate row y=0 by 4
# rotate column x=1 by 1
# EOL

display = Display.new(50,6)

input.each_line do |line|
  case line
  when /^rect (\d+)x(\d+)$/
    display.rect($1.to_i,$2.to_i)
  when /^rotate column x=(\d+) by (\d+)$/
    display.column($1.to_i,$2.to_i)
  when /^rotate row y=(\d+) by (\d+)$/
    display.row($1.to_i,$2.to_i)
  else
    fail "Bad Command? #{line}"
  end

  # puts display, nil
end

puts display, display.count
