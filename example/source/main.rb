puts 'Hello from ruby!'

puts 'Require gems specified in the Gemfile.'
require 'httparty'
response = HTTParty.get('https://raw.githubusercontent.com/kleaver/rumbda/master/example/source/main.rb')
puts response.body.split("\n").first

puts "Access environment variables via ENV: #{ENV['AWS_REGION']}"
puts "Access the event via JSON.parse(ARGV.first): #{JSON.parse(ARGV.first)}"

require_relative 'a_lib'
puts "You can also include other files:"
ALib.library_code
