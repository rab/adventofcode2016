# --- Day 13: A Maze of Twisty Little Cubicles ---
#
# You arrive at the first floor of this new building to discover a much less welcoming environment
# than the shiny atrium of the last one.  Instead, you are in a maze of twisty little cubicles,
# all alike.
#
# Every location in this area is addressed by a pair of non-negative integers (x,y). Each such
# coordinate is either a wall or an open space. You can't move diagonally. The cube maze starts at
# 0,0 and seems to extend infinitely toward positive x and y; negative values are invalid, as they
# represent a location outside the building. You are in a small waiting area at 1,1.
#
# While it seems chaotic, a nearby morale-boosting poster explains, the layout is actually quite
# logical. You can determine whether a given x,y coordinate will be a wall or an open space using
# a simple system:
#
#
# Find x*x + 3*x + 2*x*y + y + y*y.
# Add the office designer's favorite number (your puzzle input).
# Find the binary representation of that sum; count the number of bits that are 1.
#
# If the number of bits that are 1 is even, it's an open space.
# If the number of bits that are 1 is odd, it's a wall.
#
#
# For example, if the office designer's favorite number were 10, drawing walls as # and open
# spaces as ., the corner of the building containing 0,0 would look like this:
#
#   0123456789
# 0 .#.####.##
# 1 ..#..#...#
# 2 #....##...
# 3 ###.#.###.
# 4 .##..#..#.
# 5 ..##....#.
# 6 #...##.###
#
# Now, suppose you wanted to reach 7,4. The shortest route you could take is marked as O:
#
#   0123456789
# 0 .#.####.##
# 1 .O#..#...#
# 2 #OOO.##...
# 3 ###O#.###.
# 4 .##OO#OO#.
# 5 ..##OOO.#.
# 6 #...##.###
#
# Thus, reaching 7,4 would take a minimum of 11 steps (starting from your current location, 1,1).
#
# What is the fewest number of steps required for you to reach 31,39?
#

require_relative 'input'

day = __FILE__[/\d+/].to_i(10)
# input = Input.for_day(day)

# puts "solving day #{day} from input\n#{input.inspect}"

input = 1362

class Maze
  def initialize(favorite, x=40, y=40)
    @favorite = favorite
    @x_size = x
    @y_size = y
    # nil = unknown
    # false = wall
    # true = open
    @maze = Array.new(@y_size) { Array.new(@x_size) }
    fill
  end

  def fill
    @x_size.times do |x|
      @y_size.times do |y|
        ans = x*x + 3*x + 2*x*y + y + y*y + @favorite
        @maze[y][x] = ans.to_s(2).count('1').even?
      end
    end
  end

  def to_s
    str = ''.dup
    str << ' '*3
    @x_size.times {|x| str << ("%2d"%x)[0] }
    str << "\n"
    str << ' '*3
    @x_size.times {|x| str << ("%2d"%x)[1] }
    str << "\n"
    @y_size.times {|y|
      str << '%2d '%y
      str << @maze[y].map{|pos| pos ? ' ' : pos.nil? ? '?' : '#' }.join
      str << "\n"
    }
    str
  end

  # Oh, the best-laid plans...
  ARROWS = {
    w: "\u21D0",                # left
    n: "\u21D1",                # up
    e: "\u21D2",                # right
    s: "\u21D3",                # down
    me: "\u2656",               # white chess rook
  }
  DELTAS = {
    -1 => { -1 => :nw, 0 => :w, 1 => :sw },
    0  => { -1 => :n, 0 => :me, 1 => :s },
    +1 => { -1 => :ne, 0 => :e, 1 => :se },
  }
end

maze = Maze.new(input)

puts maze                       # Just solved it by hand!

#              111111111122222222223333333333
#    0123456789012345678901234567890123456789
#  0 #  ### #   #  #    ## #   #    #    #  #
#  1 #v#  # ## ####### # # #### ## ###   ## #
#  2 #>v# # ## #    ##   #  # #### ####   #  
#  3 ##>v## ## #  #   ### #     #     ## ####
#  4   #v##  ######## # #####   #  ## ## #   
#  5 #  >>>>>>>>v ###     ##### #####    #  #
#  6 ### ## ####v  # ##    #  # #  # ## #### 
#  7 # #  # ## #v# ######  # ##  # ####  # ##
#  8  ###      #>v#  #  #### ###  #  # # ##  
#  9  ####  ### #v## # #   #  # # ## ##      
# 10   ###### ###v ###  ## #  ###  ## #  ## #
# 11 #  ##  # v<<<  ### #  ###      # #####  
# 12        ##v## #     #    # ## # ###  # # 
# 13 ##### # #v##   ### ##   ## #  #  ## ##  
# 14    ##  ##v# ###  # ### # ## #  #  ## #  
# 15  # ### #v<#   # ##   #  # #  #       ## 
# 16 ##  #  #v###### ##### #  ###  ## ### ###
# 17     ## #v##  #   ## # ## ####  # ###    
# 18 ##   #  >>>v #      #     # ###   ######
# 19 ### #######v######## ## # ### ##   ##  #
# 20  ## #   ###v##>>v# ## #  #     ##    # #
# 21  ## #     #>>>^#>v# ## # #### # # ##  # 
# 22    ### ## # ### #v## ###   ##  ## # #   
# 23  #  ## #  ##  ## v #     #  ## #  #  ## 
# 24 ###    #   ### # v ## ##### #  #  ## ###
# 25  # ## ### #  # ##v# ###  #  ## #####    
# 26  ####  ##  # # ##>v#>>>>v#   # #  ##### 
# 27    # #   #  ##  ##>>^###v## ##  #  ## # 
# 28 #  ## ##  # ### # #### #v## ### #     # 
# 29 ##  #######  #  #     ##>>>>v#  ###### #
# 30  ###  #      #  ### # # ### v#     # ## 
# 31 #  ## #  ######## ### ### ##v##  # #  ##
# 32  #   ####    #       #   # #v##### # #  
# 33    #    #  # # ##  # ###  ##v##   ## ###
# 34 ############ # #####    # # >>>v# ##    
# 35 #  ##  #    ##  #    ## # #  ##v#    ## 
# 36 #    # ## # # # # ### #  ######v# ### # 
# 37 ## #  # # # ##  ##  ## #     #v<### ##  
# 38  ## #   # ## #   # # ######  #v#  ## # #
# 39 # #  ###   # ## ## ##  ## #  #>X   # #  

# --- Part Two ---
#
# How many locations (distinct x,y coordinates, including your starting location) can you reach in
# at most 50 steps?

maze = Maze.new(input, 52, 52)  # make the maze big enough
puts maze                       # Just solved it by hand!

#  #12###e#   #  #    ## #   #    #    #  # # ##   ## #
#  #0#  #d## ####### # # #### ## ###   ## #  # ###   # 
#  #12# #c## #    ##   #  # #### ####   #  #  #  # #   
#  ##34##b## #  #   ### #     #     ## ######    #  ###
#  a9#5##ab######## # #####   #  ## ## #     ## ### #  
#  #876789abcdef###     ##### #####    #  ##  # ###    
#  ###h##a####fgh# ##    #  # #  # ## #### ##    #### #
#  # #gf#b##g#g#i######  # ##  # ####  # #######  ###  
#  O###edcdef#hi#  #xy#### ###  #  # # ##  #       ### 
#  N####ed### #j## #w#   #  # # ## ##      #  ####  # #
#  ML######q###kl###vu## #  ###  ## #  ## ####   #  ## 
#  #KJ##GH#ponmlmn###t#  ###      # #####  # #   #   # 
#  KJIHGFG##p##s#opqrs#    # ## # ###  # # ####  ## ###
#  #####E# #q##rqp###t##   ## #  #  ## ##   #######    
#     ##DC##r# ###  #u### # ## #  #  ## #     #  ##### 
#   # ###B#ts#   # ##vwx#  # #  #       ##  # ##  ## # 
#  ##  #BA#u###### ##### #  ###  ## ### ####   #     # 
#      ##z#v##AB#   ## # ## ####  # ###    #   #  ###  
#  ##   #yxwxyzA#      #     # ###   ######## ##### #  
#  ### #######A######## ## # ### ##   ##  # # ##  # ###
#   ## #   ###B##GHI# ## #  #     ##    # ##      # #  
#   ## #     #CDEF#JK# ## # #### # # ##  # ##### ## #  
#     ### ## #D### #L## ###   ##  ## # #      ## #  # #
#   #  ## #  ##  ##NMN#     #  ## #  #  ##  # ## # ##  
#  ###    #   ### #ONO## ##### #  #  ## #####  ### # # 
#   # ## ### #  # ##O# ###  #  ## #####          # ##  
#   ####  ##  # # ##  #     #   # #  ##### ## ## ## #  
#     # #   #  ##  ##   ### ## ##  #  ## # ## #   # ## 
#  #  ## ##  # ### # #### # ## ### #     #    # # #####
#  ##  #######  #  #     ##     #  ###### ##  #  #     
#   ###  #      #  ### # # ###  #     # ## ### #  #####
#  #  ## #  ######## ### ### ## ##  # #  ### #  # ##  #
#   #   ####    #       #   # # ##### # #   ###     #  
#     #    #  # # ##  # ###  ## ##   ## ### #### ##    
#  ############ # #####    # #     # ##      # # # ## #
#  #  ##  #    ##  #    ## # #  ## #    ## # ##  # ## #
#  #    # ## # # # # ### #  ###### # ### # ## #  #    #
#  ## #  # # # ##  ##  ## #     #  ### ##   # ### ##   
#   ## #   # ## #   # # ######  # #  ## # # # # #####  
#  # #  ###   # ## ## ##  ## #  #     # #  ##     #### 
#   ### # # # #### ##  #     ##  ##   #  # ####    ####
#   ###  ##  #   #     #  ######  ## ####   ######  ## 
#    # # # #  ## # ## #####  # ## ## ## #    #   #     
#  # ##  #  # #  ## # ##  #  #### ##   ##### #   # ### 
#   # # ###   #   ##      ###  ##    # ##  ####  #  ## 
#   # # #### ### # ##### #   #    ## #       #### #  ##
#   #    ###  ##      ##  ##   ### # # ##  # ## ####   
#  ### #  # #   ##  # ### # ## # ##  ## ###   #   # ###
#  # # #  ## ## #####  #  ## # ## #   # # #   ##  ##   
#  ##  ##  #### ##     ##  ##   #### ## # ## # # # #  #
#   #   ###  #     ##   ### #     ## ## # ##  ##  #### 
#  ### #   # #  ## ### #    ##  #      ##  ## # #    ##
