require_relative 'input'

day = __FILE__[/\d+/].to_i(10)
input = Input.for_day(day)

puts "solving day #{day} from input\n#{input.inspect}"
