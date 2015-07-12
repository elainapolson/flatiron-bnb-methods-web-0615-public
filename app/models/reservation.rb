class Reservation < ActiveRecord::Base

  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, :checkout, presence: true
  validate :host_error, :listing_available, :checkin_before_checkout


  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.duration * self.listing.price
  end

  def host_error
    if self.guest_id == self.listing.host_id
      errors.add(:host_error, "You can't book your own room, silly!")
    end
  end

  def listing_available
    if !(self.listing.reservations.where(("? > reservations.checkin AND ? < reservations.checkout) OR (? > reservations.checkin AND ? < reservations.checkout"), checkin, checkin, checkout, checkout).empty?)
      errors.add(:availability_error, "We're sorry, this room is not available during the selected dates.")
    end
  end

  def checkin_before_checkout
    if checkin && checkout && checkin >= checkout
    errors.add(:availability_error, "Checkin must be before checkout.")
    end
  end

end

