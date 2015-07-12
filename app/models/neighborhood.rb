class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings


  def neighborhood_openings(start_date, end_date)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)

    self.listings.joins(:reservations).where("? <= checkin AND ? <= checkin OR ? >= checkout", start_date, end_date, start_date)
  end

  def self.highest_ratio_res_to_listings
    reservations_count = joins(:listings => :reservations).group("neighborhoods.name").count
    listings_count = joins(:listings).group("neighborhoods.name").count

    valid_neighborhoods = self.all.collect do |neighborhood|
      neighborhood if reservations_count[neighborhood.name] && listings_count[neighborhood.name]
    end.compact

    valid_neighborhoods.max_by do |neighborhood|
      reservations_count[neighborhood.name] / listings_count[neighborhood.name]
    end

  end

  def self.most_res
    joins(:listings => :reservations).group("neighborhoods.name").order("count (*) desc").first
  end

end
