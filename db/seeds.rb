# frozen_string_literal: true

require 'json'

filepath = File.join(Rails.root, 'db', 'input.json')
serialized_input = File.read(filepath)
input = JSON.parse(serialized_input)

input['listings'].each { |listing| Listing.create!(num_rooms: listing['num_rooms']) }

input['bookings'].each do |booking|
  Booking.create!(start_date: booking['start_date'], end_date: booking['end_date'],
                  listing_id: booking['listing_id'])
end

input['reservations'].each do |reservation|
  Reservation.create!(start_date: reservation['start_date'], end_date: reservation['end_date'],
                      listing_id: reservation['listing_id'])
end
