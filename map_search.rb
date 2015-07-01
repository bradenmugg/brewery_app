require 'httparty'

response = HTTParty.get("https://api.untappd.com/v4/dib?=")

puts response