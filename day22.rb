# --- Day 22: Grid Computing ---
#
# You gain access to a massive storage cluster arranged in a grid; each storage node is only
# connected to the four nodes directly adjacent to it (three if the node is on an edge, two if
# it's in a corner).
#
# You can directly access data only on node /dev/grid/node-x0-y0, but you can perform some limited
# actions on the other nodes:
#
#
# You can get the disk usage of all nodes (via df). The result of doing this is in your puzzle
# input.
# You can instruct a node to move (not copy) all of its data to an adjacent node (if the
# destination node has enough space to receive the data). The sending node is left empty after
# this operation.
#
# Nodes are named by their position: the node named node-x10-y10 is adjacent to nodes node-x9-y10,
# node-x11-y10, node-x10-y9, and node-x10-y11.
#
# Before you begin, you need to understand the arrangement of data on these nodes. Even though you
# can only move data between directly connected nodes, you're going to need to rearrange a lot of
# the data to get access to the data you need.  Therefore, you need to work out how you might be
# able to shift data around.
#
# To do this, you'd like to count the number of viable pairs of nodes.  A viable pair is any two
# nodes (A,B), regardless of whether they are directly connected, such that:
#
# Node A is not empty (its Used is not zero).
# Nodes A and B are not the same node.
# The data on node A (its Used) would fit on node B (its Avail).
#
# How many viable pairs of nodes are there?

require_relative 'input'

day = __FILE__[/\d+/].to_i(10)
input = Input.for_day(day)

# puts "solving day #{day} from input:\n#{input}"

=begin
root@ebhq-gridcenter# df -h
Filesystem              Size  Used  Avail  Use%
/dev/grid/node-x0-y0     93T   68T    25T   73%
/dev/grid/node-x0-y1     91T   69T    22T   75%
/dev/grid/node-x0-y2     92T   68T    24T   73%
=end

class Node
  attr_accessor :x, :y, :size, :used, :avail, :perc
  PARTS = %r{/dev/grid/node-x(?<x>\d+)-y(?<y>\d+)\s+(?<size>\d+)T\s+(?<used>\d+)T\s+(?<avail>\d+)T\s+(?<perc>\d+)%}
  def initialize(line)
    m = PARTS.match(line)
    @x = m['x'].to_i
    @y = m['y'].to_i
    @size = m['size'].to_i
    @used = m['used'].to_i
    @avail = m['avail'].to_i
    @perc = m['perc'].to_i
  end

  def could_move_to?(other)
    @used.nonzero? && (@x != other.x || @y != other.y) &&  @used <= other.avail
  end

  def to_s
    "node-x%d-y%d\t%5dT %5dT %5dT %5d%%"%[@x, @y, @size, @used, @avail, @perc]
  end
end

nodes = []
input.each_line do |line|
  next unless line.start_with?('/dev/')
  nodes << Node.new(line.chomp)
end

viable_pairs = 0
nodes.each do |node|
  viable_pairs += nodes.count {|other| node.could_move_to?(other)}
end

puts viable_pairs
