class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, :through => :listings

  def city_openings(start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)

    self.listings.joins(:reservations).where("? <= checkin AND ? <= checkin OR ? >= checkout", start_date, end_date, start_date)
  end

  def ratio_res_to_listings
    reservations.count / listings.count
  end

  def self.highest_ratio_res_to_listings
    City.all.max_by {|city| city.ratio_res_to_listings}
  end

  def self.most_res
    City.all.max_by {|city| city.reservations.count}
  end

end

