# --- Day 20: Firewall Rules ---
#
# You'd like to set up a small hidden computer here so you can use it to get back into the network
# later. However, the corporate firewall only allows communication with certain external IP
# addresses.
#
# You've retrieved the list of blocked IPs from the firewall, but the list seems to be messy and
# poorly maintained, and it's not clear which IPs are allowed. Also, rather than being written in
# dot-decimal notation, they are written as plain 32-bit integers, which can have any value from 0
# through 4294967295, inclusive.
#
# For example, suppose only the values 0 through 9 were valid, and that you retrieved the
# following blacklist:
#
# 5-8
# 0-2
# 4-7
#
# The blacklist specifies ranges of IPs (inclusive of both the start and end value) that are not
# allowed. Then, the only IPs that this firewall allows are 3 and 9, since those are the only
# numbers not in any range.
#
# Given the list of blocked IPs you retrieved from the firewall (your puzzle input), what is the
# lowest-valued IP that is not blocked?
#
# --- Part Two ---
#
# How many IPs are allowed by the blacklist?

require_relative 'input'

day = __FILE__[/\d+/].to_i(10)
input = Input.for_day(day)

# input = <<-EOL
# 5-8
# 0-2
# 4-7
# EOL

# puts "solving day #{day} from input:\n#{input}"

class Range
  def <=>(other)
    (self.begin <=> other.begin).nonzero? || self.end <=> other.end
  end
  def join(other)
    self.class.new(*[self.begin, other.begin, self.end, other.end].minmax)
  end
  def can_join?(other)
    cover?(other.begin) || cover?(other.end) ||                   # other's inside me
      other.cover?(self.begin) || other.cover?(self.end) ||       # I'm inside other
      self.begin < other.begin && self.end.succ == other.begin || # other abuts my end
      other.begin < self.begin && other.end.succ == self.begin    # I abut other's begin
  end
end

blocked = []                    # Array of ranges
input.each_line do |line|
  # puts '-'*80, blocked.inspect, line
  from, to = /^(\d+)-(\d+)$/.match(line).captures.map(&:to_i)
  blocked = (blocked << (from..to)).sort.reduce([]) {|ans, rng|
    if ans.last && ans.last.can_join?(rng)
      ans.push ans.pop.join(rng)
    else
      ans << rng
    end
  }
end

print "First unblocked IP is: "
if blocked.first.begin.zero?
  puts blocked.first.end.succ
else
  puts 0
end

puts "There are #{blocked.size} blocked IP ranges"

available_ips = 2 ** 32
blocked.each do |rng|
  available_ips -= (rng.end - rng.begin + 1)
end
puts "Total available IPs: #{available_ips}"
