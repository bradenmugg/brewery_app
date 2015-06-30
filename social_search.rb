require 'brewery_db'

class Beer

  attr_accessor :brewery, :name, :abv, :ibu, :style, :id, :hash, :social

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
    key = "*" + gets.chomp
    array = []
    beer_in = Beer.new
    first_fifty = brewery_db.breweries.all(name: "#{key}", withSocialAccounts: "Y").first(1)
    result = (first_fifty[0]).to_h
    
    puts result
  end
end

Finder = Find_Beers.new
Finder.get_data