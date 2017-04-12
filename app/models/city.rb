class City < ActiveRecord::Base

  # associations

  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods
  has_many :reservations, through: :listings

  # instance methods

  def city_openings(start_date, end_date)
    listings.where.not(id: booked_listings(start_date, end_date).pluck(:id))
    # knows about all the available listings given a date range
  end

  def booked_listings(start_date, end_date)
    listings.joins(:reservations).where.not("reservations.checkin > ? OR reservations.checkout < ?", end_date, start_date)
    # helper: knows about all the available listings given a date range
  end

  # class methods

  def self.highest_ratio_res_to_listings
    find(joins(:reservations).group("neighborhoods.city_id").order("COUNT(*) DESC").pluck(:id).first)
    # knows the city with the highest ratio of reservations to listings
    # doesn't hardcode the city with the highest ratio of reservations to listings
  end

  def self.most_res
    find(joins(:reservations).group("neighborhoods.city_id").order("COUNT(*) DESC").pluck(:id).first)
    # knows the city with the most reservations
  end

end
