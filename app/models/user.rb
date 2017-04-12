class User < ActiveRecord::Base

  # associations

  has_many :listings, :foreign_key => 'host_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  # class instance methods

  def guests
   reservations.map {|reservation| reservation.guest}
   # as a guest, knows about the hosts its had
  end

  def hosts
   trips.map {|trip| trip.listing.host}
   # as a host, knows about the guests its had
  end

  def host_reviews
   reservations.map {|reservation| reservation.review}
   # as a host, knows about its reviews from guests
  end

end
