class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)

    self.listings.joins(:reservations).where("? <= checkin AND ? <= checkin OR ? >= checkout", start_date, end_date, start_date)
  end

  def ratio_res_to_listings
    reservations.count / listings.count
  end

  def self.highest_ratio_res_to_listings
    reservations_count = joins(:listings => :reservations).group("cities.name").count
    listings_count = joins(:listings).group("cities.name").count

    valid_cities = self.all.collect do |city|
      city if reservations_count[city.name] && listings_count[city.name]
    end.compact

    valid_cities.max_by do |city|
      reservations_count[city.name] / listings_count[city.name]
    end
  end

  def self.most_res
    joins(:listings => :reservations).group("cities.name").order("count (*) desc").first
  end

end

