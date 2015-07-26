require 'rest-client'
require 'json'

class Beer

  attr_accessor :brewery, :name, :abv, :ibu, :style, :id, :hash

end

base_url = "http://api.brewerydb.com/v2/"
token = "4f7bf24d4106c5da74ca6a05b276a883"

chosen_ones = []
class Beer
    attr_accessor :id, :first_name, :last_name
end

page = 901
while page <= 915
  response = RestClient.get base_url + "/beers?p=#{page}&key=#{token}&withBreweries=Y"
  response = JSON.parse(response)
  response["data"].each do |hash|
    beer_in = Beer.new
    beer_in.id = hash["id"]
    beer_in.name = hash["name"]
    beer_in.abv = hash["abv"]
    beer_in.ibu = hash["ibu"]
    style = hash["style"]
    unless style.nil?
      beer_in.style = style["name"]
    end
    brewery = hash["breweries"]
    unless brewery.nil?
      beer_in.brewery = brewery[0].to_h["name"]
    end
    chosen_ones.push(beer_in)
  end
  page += 1
end

filename = "breweries.csv"
target = open(filename, 'a')
chosen_ones.each do |beer|
  unless beer.brewery.nil?
    beer.brewery.delete! ','
  end
  unless beer.name.nil?
    beer.name.delete! ','
  end
  target.write("#{beer.brewery},#{beer.name},#{beer.id},#{beer.style},#{beer.abv},#{beer.ibu}\n")
end
target.close



