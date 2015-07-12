class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  
  validates :address, :listing_type, :title, :description, :price, :neighborhood, presence: true

  after_create :update_user_to_host

  after_destroy :update_user_if_no_listings

  def average_review_rating
    total_ratings = self.reviews.inject(0) { |sum, review|sum + review.rating }
    (total_ratings / self.reviews.size.to_f)
  end

  private

    def update_user_to_host
      self.host.host = true
      self.host.save 
    end

    def update_user_if_no_listings
      if self.host.listings.size == 0
        self.host.host = false
        self.host.save
      end
    end

end
