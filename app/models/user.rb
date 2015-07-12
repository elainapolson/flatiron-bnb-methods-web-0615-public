class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'
  has_many :guests, :class_name => "User", :through => :reservations

#guest => trips => listing => host 

  def hosts
    self.trips.collect do |trip|
      trip.listing.host  
    end
  end

#host => listing => reviews

  def host_reviews

    self.listings.collect do |listing|
      listing.reviews
    end.flatten
  end

end
