require 'brewery_db'

class Beer

  attr_accessor :brewery, :name, :abv, :ibu, :style, :id, :hash

  def initialize
    @brewery =""
    @name = ""
    @abv = ""
    @ibu = ""
    @style = ""
    @id = ""
    @hash = Hash.new
  end

end

class Find_Beers

  attr_accessor :user_beer, :abvs, :ibus, :styles, :chosen_one

  def get_data
    brewery_db = BreweryDB::Client.new do |config|
        config.api_key = "4f7bf24d4106c5da74ca6a05b276a883"
    end
    puts "Enter the name of the beer you would like to use:"
    key = gets.chomp
    array = []
    beer_in = Beer.new
    first_fifty = brewery_db.beers.all(name: "#{key}").first(1)
    result = (first_fifty[0]).to_h
    beer_in.id = result["id"]
    beer_in.name = result["name"]
    beer_in.abv = result["abv"]
    beer_in.ibu = result["ibu"]
    beer_in.style = result["style"]["id"]
    self.user_beer = beer_in
    puts beer_in.style
  end

  def search_abv
    puts "ABV"
    brewery_db = BreweryDB::Client.new do |config|
        config.api_key = "4f7bf24d4106c5da74ca6a05b276a883"
    end
    self.abvs = []
    count = 0
    beers_abv = brewery_db.beers.all(abv: "#{self.user_beer.abv}", styleId: "#{self.user_beer.style}", withBreweries: "Y").first(100)
    beers_abv.each do |x|
      hash = x.to_h
      beer_in = Beer.new
      beer_in.id = hash["id"]
      beer_in.name = hash["name"]
      beer_in.abv = hash["abv"]
      beer_in.ibu = hash["ibu"]
      beer_in.style = hash["style"]["id"]
      beer_in.hash = hash
      brewery = hash["breweries"]
      unless brewery.nil?
        beer_in.brewery =brewery[0].to_h["name"]
      end
      self.abvs.push(beer_in)
      puts beer_in.name
    end
  end

def search_hops
  puts "IBU"
  brewery_db = BreweryDB::Client.new do |config|
      config.api_key = "4f7bf24d4106c5da74ca6a05b276a883"
  end
  self.ibus = []
  beers_ibu = []
  ibu_low = (self.user_beer.ibu.to_i - 3)
  ibu_high = (self.user_beer.ibu.to_i + 3)
  beers_ibu = brewery_db.beers.all(ibu: "#{ibu_low},#{ibu_high}", styleId: "#{self.user_beer.style}", withBreweries: "Y").first(100)
  beers_ibu.each do |x|
    hash = x.to_h
    beer_in = Beer.new
    beer_in.id = hash["id"]
    beer_in.name = hash["name"]
    beer_in.abv = hash["abv"]
    beer_in.ibu = hash["ibu"]
    beer_in.style = hash["style"]["id"]
    beer_in.hash = hash
    brewery = hash["breweries"]
    unless brewery.nil?
      beer_in.brewery =brewery[0].to_h["name"]
    end
    self.ibus.push(beer_in)
  end
end


  def search_ibu
    puts "IBU"
    brewery_db = BreweryDB::Client.new do |config|
        config.api_key = "4f7bf24d4106c5da74ca6a05b276a883"
    end
    self.ibus = []
    beers_ibu = []
    count = (-3)
    while count < 4
      ibu = (self.user_beer.ibu.to_i + count)
      test = brewery_db.beers.all(ibu: "#{ibu}", styleId: "#{self.user_beer.style}", withBreweries: "Y").first(50)
      test.each do |x|
        beers_ibu.push(x)
      end
      count += 1
    end
    beers_ibu.each do |x|
      hash = x.to_h
      beer_in = Beer.new
      beer_in.id = hash["id"]
      beer_in.name = hash["name"]
      beer_in.abv = hash["abv"]
      beer_in.ibu = hash["ibu"]
      beer_in.style = hash["style"]["id"]
      beer_in.brewery = hash["breweries"][0].to_h["name"]
      self.ibus.push(beer_in)
      puts beer_in.name
    end
  end

  def search_style
    self.styles = []
    beers_style = []

  def compare
    self.chosen_one = []
    ibu = self.ibus
    abv = self.abvs
    max = abv.size
    ibu.each do |x|
      count = 0
      while count < max
        if x.id == abv[count].id && x.id != self.user_beer.id
          self.chosen_one.push(x)
        end
        count += 1
      end
    end
    output = self.chosen_one
    output.each do |x|
      puts "#{x.brewery} #{x.name}"
    end
  end
end


finder = Find_Beers.new
finder.get_data
if finder.user_beer.ibu == "" && finder.user_beer.abv == ""

  finder.search_abv
elsif

finder.search_abv
finder.search_hops
finder.compare
