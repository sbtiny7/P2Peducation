#!/bin/env ruby
puts "usage './setup development'"
if ['development', 'production'].include? ARGV
  env = ARGV
else
  env = 'development'
  puts "use development evn as default"
end

puts "import cities"
system "rake region:import"
