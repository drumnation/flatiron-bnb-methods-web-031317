class Review < ActiveRecord::Base

  # associations

  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  # validations

  validates :rating, :description, :reservation, presence: true
  validate :reservation_valid, if: [:reservation]

  private # custom validations

  def reservation_valid
    if reservation.checkout > Date.today || reservation.status == "pending"
      errors.add(:reservation, "The reservation is not over or approved")
    end
    # is invalid without an associated reservation, has been accepted, and checkout has happened
  end

end
