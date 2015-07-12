class ReservationValidator < ActiveModel::Validator

  def listing_available(record)
    Reservation.all.each do |reservation|
      unless record.checkin <= reservation.checkin && record.checkout <= reservation.checkin || record.checkin >= reservation.checkout
        binding.pry
        errors.add(:availability_error, "Sorry, this room is not available during the selected dates!")
      end
    end
  end

end
 
