class Neighborhood < ActiveRecord::Base

  # associations

  belongs_to :city
  has_many :listings
  has_many :reservations, :through => :listings

  # class instance methods

  def neighborhood_openings(start_date,end_date)
    listings.select {|listing| listing.available_inbetween?(start_date, end_date)}
    # knows about all the available listings given a date range
  end

  # class methods

  def self.highest_ratio_res_to_listings
    find(joins(:reservations).group("neighborhood_id").order("COUNT(*) DESC").limit(1).pluck(:id).first)
    # knows the neighborhood with the highest ratio of reservations to listings
    # doesn't hardcode the neighborhood with the highest ratio
  end

  def self.most_res
    find(joins(:reservations).group("neighborhood_id").order("COUNT(*) DESC").limit(1).pluck(:id).first)
    # knows the neighborhood with the most reservations
    # doesn't hardcode the neighborhood with the most reservations
  end

end
