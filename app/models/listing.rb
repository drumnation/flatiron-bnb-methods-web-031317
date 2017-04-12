class Listing < ActiveRecord::Base

  # associations

  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"

  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  # validations

  validates :address, :listing_type, :title, :description, :price, :neighborhood_id, presence: true
  validates_associated :neighborhood
  after_create :user_becomes_host
  after_destroy :if_last_listing_host_becomes_user

  # callback methods

  def user_becomes_host
    host.update(host: true)
  end

  def if_last_listing_host_becomes_user
    if host.listings.empty?
      host.host = false
      host.save
    end
  end

  # instance methods

  def available_inbetween?(start_date,end_date)
    status = reservations.map do |r|
      (r.checkin <= Date.parse(end_date)) and (r.checkout >= Date.parse(start_date))
    end
    status.include?(true) ? false : true
  end

  def average_review_rating
    reviews.average(:rating)
    # knows its average ratings from its reviews
  end

end
