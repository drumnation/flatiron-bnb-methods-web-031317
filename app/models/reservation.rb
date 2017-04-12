class Reservation < ActiveRecord::Base

  # associations

  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  # validations

  validates :checkin, :checkout, presence: true
  validate :guest_is_not_the_host
  validate :listing_is_available, if: [:dates_have_been_set_available]
  validate :checkin_date_comes_before_checkout_date, if: [:dates_have_been_set_available]
  validate :checkin_date_different_from_checkout_date, if: [:dates_have_been_set_available]

  # class instance methods

  def duration
    checkout - checkin
    # knows about its duration based on checkin and checkout dates
  end

  def total_price
    listing.price * duration
    # knows about its total price
  end

  private

  # custom validations

  def guest_is_not_the_host
    if guest_id == listing.host_id
      errors.add(:guest, "As a host you cannot make a reservation on your listing. Universes might collide.")
    end
    # validates that you cannot make a reservation on your own listing
  end

  def listing_is_available
    unless listing.available_inbetween?(checkin.to_s,checkout.to_s)
      errors.add(:availability, "Unfortunately the listing is not available during those dates")
    end
    # validates that a listing is available at checkin before making reservation
  end

  def dates_have_been_set_available
    checkin != nil && checkout != nil
  end

  def checkin_date_comes_before_checkout_date
    if checkin >= checkout
      errors.add(:dates, "Checkin date must come before checkout date")
    end
  end

  def checkin_date_different_from_checkout_date
    if checkin == checkout
      errors.add(:dates, "Checkout date cannot be the same as the checkin date")
    end
  end

end
