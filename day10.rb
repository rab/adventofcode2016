# --- Day 10: Balance Bots ---
#
# You come upon a factory in which many robots are zooming around handing small microchips to each other.
#
# Upon closer examination, you notice that each bot only proceeds when it has two microchips, and
# once it does, it gives each one to a different bot or puts it in a marked "output"
# bin. Sometimes, bots take microchips from "input" bins, too.
#
# Inspecting one of the microchips, it seems like they each contain a single number; the bots must
# use some logic to decide what to do with each chip. You access the local control computer and
# download the bots' instructions (your puzzle input).
#
# Some of the instructions specify that a specific-valued microchip should be given to a specific
# bot; the rest of the instructions indicate what a given bot should do with its lower-value or
# higher-value chip.
#
# For example, consider the following instructions:
#
# value 5 goes to bot 2
# bot 2 gives low to bot 1 and high to bot 0
# value 3 goes to bot 1
# bot 1 gives low to output 1 and high to bot 0
# bot 0 gives low to output 2 and high to output 0
# value 2 goes to bot 2
#
#
# Initially, bot 1 starts with a value-3 chip, and bot 2 starts with a value-2 chip and a value-5 chip.
# Because bot 2 has two microchips, it gives its lower one (2) to bot 1 and its higher one (5) to bot 0.
# Then, bot 1 has two microchips; it puts the value-2 chip in output 1 and gives the value-3 chip to bot 0.
# Finally, bot 0 has two microchips; it puts the 3 in output 2 and the 5 in output 0.
#
# In the end, output bin 0 contains a value-5 microchip, output bin 1 contains a value-2
# microchip, and output bin 2 contains a value-3 microchip. In this configuration, bot number 2 is
# responsible for comparing value-5 microchips with value-2 microchips.
#
# Based on your instructions, what is the number of the bot that is responsible for comparing
# value-61 microchips with value-17 microchips?
#
# --- Part Two ---
#
# What do you get if you multiply together the values of one chip in each of outputs 0, 1, and 2?

require_relative 'input'

day = __FILE__[/\d+/].to_i(10)
input = Input.for_day(day)

# puts "solving day #{day} from input\n#{input}"

# input = <<-EOL
# value 5 goes to bot 2
# bot 2 gives low to bot 1 and high to bot 0
# value 3 goes to bot 1
# bot 1 gives low to output 1 and high to bot 0
# bot 0 gives low to output 2 and high to output 0
# value 2 goes to bot 2
# EOL

class Output
  def initialize(number)
    @number = number
    @holding = []
  end
  def to_s(full: nil)
    str = "output #{@number}"
    str << @holding.inspect if full && ! @holding.empty?
    str
  end
  def gets(value)
    $stderr.puts "#{self} receiving #{value}"
    @holding << value
  end
end

class Bot
  def initialize(bots, outputs, number)
    @bots = bots
    @outputs = outputs
    @number = number
    @holding = []
    @low_to  = nil
    @high_to = nil
  end
  def to_s(full: nil)
    str = "bot #{@number}"
    if full && (@low_to || @high_to)
      str << { low_to: (@low_to || 'nil').to_s, high_to: (@high_to || 'nil').to_s }.to_s
    end
    str << " #{@holding.inspect}" unless @holding.empty?
    str
  end

  def gets(value)
    $stderr.puts "-> #{self.to_s(full: true)} receiving #{value}"
    @holding << value
    distribute if full?
  end

  def connect(low_to: nil, high_to: nil)
    @low_to  = low_to  unless low_to.nil?
    @high_to = high_to unless high_to.nil?
    distribute if full?
    self
  end

  def full?
    @low_to && @high_to && @holding.size == 2
  end

  def distribute
    $stderr.puts "#{self.to_s(full: true)} DISTRIBUTING"
    @holding.sort!
    low  = @holding.shift
    high = @holding.shift

    puts "*** Hey, I'm #{self} and I've got #{low} and #{high}" if low == 17 && high == 61 # || low == 2 && high == 5

    if @low_to
       puts "  giving low (#{low}) to #{@low_to}"
      @low_to.gets  low
    else
      fail "#{self.to_s(full: true)} can't give low (#{low})"
    end
    if @high_to
      $stderr.puts "  giving high (#{high}) to #{@high_to}"
      @high_to.gets high
    else
      fail "#{self.to_s(full: true)} can't give high (#{high})"
    end
  end
end

outputs = Hash.new {|h,k| h[k] = Output.new(k) }
bots = Hash.new {|h,k| h[k] = Bot.new(h, outputs, k) }

input.each_line do |line|
  # puts line
  case line
  when /value (\d+) goes to bot (\d+)/
    bots[$2.to_i].gets($1.to_i)
  when /bot (\d+) gives low to (bot|output) (\d+) and high to (bot|output) (\d+)/
    changed = bots[$1.to_i].connect(low_to: ($2 == 'bot' ? bots : outputs)[$3.to_i],
                                    high_to:($4 == 'bot' ? bots : outputs)[$5.to_i])
    $stderr.puts "-> #{changed.to_s(full: true)}"
  else
    fail "unrecognized: #{line}"
  end
end

$stderr.puts "-"*80, "defined"

while bots.any? {|n,b| b.full? }
  $stderr.puts "-"*40, "draining"
  bots.each do |bot|
    if bot.full?
      bot.distribute
    end
  end
end

outputs.each do |n,o|
  puts o.to_s(full: true)
end
