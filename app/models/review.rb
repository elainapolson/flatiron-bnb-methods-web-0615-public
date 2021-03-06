class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, :description, presence: true
  validate :valid_stay

  def valid_stay
    if !(self.reservation_id && self.reservation.status == "accepted")
      errors.add(:invalid_stay, "You didn't actually stay here")
    elsif created_at && !(created_at > self.reservation.checkout)
      errors.add(:invalid_stay, "You didn't actually stay here")
    end
  end
  
end