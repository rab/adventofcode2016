# --- Day 7: Internet Protocol Version 7 ---
#
# While snooping around the local network of EBHQ, you compile a list of IP addresses (they're
# IPv7, of course; IPv6 is much too limited). You'd like to figure out which IPs support TLS
# (transport-layer snooping).
#
# An IP supports TLS if it has an Autonomous Bridge Bypass Annotation, or ABBA.  An ABBA is any
# four-character sequence which consists of a pair of two different characters followed by the
# reverse of that pair, such as xyyx or abba.  However, the IP also must not have an ABBA within
# any hypernet sequences, which are contained by square brackets.
#
# For example:
#
# abba[mnop]qrst supports TLS (abba outside square brackets).
# abcd[bddb]xyyx does not support TLS (bddb is within square brackets, even though xyyx is outside square brackets).
# aaaa[qwer]tyui does not support TLS (aaaa is invalid; the interior characters must be different).
# ioxxoj[asdfgh]zxcvbn supports TLS (oxxo is outside square brackets, even though it's within a larger string).
#
# How many IPs in your puzzle input support TLS?
#
# --- Part Two ---
#
# You would also like to know which IPs support SSL (super-secret listening).
#
# An IP supports SSL if it has an Area-Broadcast Accessor, or ABA, anywhere in the supernet
# sequences (outside any square bracketed sections), and a corresponding Byte Allocation Block, or
# BAB, anywhere in the hypernet sequences. An ABA is any three-character sequence which consists
# of the same character twice with a different character between them, such as xyx or aba. A
# corresponding BAB is the same characters but in reversed positions: yxy and bab, respectively.
#
# For example:
#
# aba[bab]xyz supports SSL (aba outside square brackets with corresponding bab within square
#   brackets).
#
# xyx[xyx]xyx does not support SSL (xyx, but no corresponding yxy).
#
# aaa[kek]eke supports SSL (eke in supernet with corresponding kek in hypernet; the aaa sequence
#   is not related, because the interior character must be different).
#
# zazbz[bzb]cdb supports SSL (zaz has no corresponding aza, but zbz has a corresponding bzb, even
#   though zaz and zbz overlap).
#
# How many IPs in your puzzle input support SSL?

require_relative 'input'

day = __FILE__[/\d+/].to_i(10)
input = Input.for_day(day)

ABBA = /([a-z])([a-z])\2\1/
HYP = /(\[[a-z]*\])/
ABA = /([a-z])([a-z])\1/

tls = 0
ssl = 0

def ssl?(part, hyp)
  part.chars.each_cons(3) do |seq|
    sn = seq.join
    # print "#{sn}?"
    if ABA =~ sn && $1 != $2
      # print ":"
      bab = Regexp.new("#{$2}#{$1}#{$2}")
      # print "#{bab.inspect}?"
      if hyp.any? {|hn| bab =~ hn}
      #   print "Y "
        return true
      # else
      #   print "n "
      end
    # else
    #   print "N "
    end
  end
  # puts
  false
end

input.each_line do |line|
  # puts "-"*100, line
  hypernet, supernet = line.chomp.split(HYP).partition {|part| HYP =~ part }
  # puts "Supernet: #{supernet.inspect}"
  # puts "Hypernet: #{hypernet.inspect}"

  if hypernet.none? {|part| ABBA =~ part && $1 != $2 } &&
     supernet.any? {|part| ABBA =~ part && $1 != $2 }
    # puts "TLS"
    tls += 1
  end

  if supernet.any? {|part|
       # print "#{part}: "
       ssl?(part, hypernet)
     }
    # puts "SSL"
    ssl += 1
  end
end
puts "TLS: #{tls}"
puts "SSL: #{ssl}"
