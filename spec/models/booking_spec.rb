# frozen_string_literal: true

describe Booking, mission_type: :model do
  it { is_expected.to belong_to(:listing) }

  it { is_expected.to validate_presence_of(:start_date) }
  it { is_expected.to validate_presence_of(:end_date) }

  describe 'is after start' do
    context 'when the start_date is before the end_date' do
      let(:booking) { build(:booking, start_date: '2021-01-01', end_date: '2021-01-10') }

      it 'is valid' do
        booking.validate
        expect(booking.errors.details).to be_blank
      end
    end

    context 'when the start_date is after the end_date' do
      let(:booking) { build(:booking, start_date: '2021-01-10', end_date: '2021-01-01') }

      it 'is not valid' do
        booking.validate
        expect(booking.errors.details)
          .to eq({ start_date: [{ error: :greater_than_end_date }] })
      end
    end
  end

  context 'when there is already a booking on these dates' do
    let!(:listing) { create(:listing) }
    let(:booking_2) do
      build(:booking, start_date: 3.days.from_now, end_date: 4.days.from_now, listing: listing)
    end

    before do
      create(:booking, start_date: 2.days.from_now, end_date: 7.days.from_now, listing: listing)
    end

    it 'adds errors for overlapping other booking' do
      booking_2.validate
      expect(booking_2.errors.details)
        .to eq({ start_date: [{ error: :overlap }], end_date: [{ error: :overlap }] })
    end
  end

  context 'when an other booking has the same start_date and last_date on the listing' do
    let!(:listing) { create(:listing) }
    let(:booking_2) do
      build(:booking, start_date: 2.days.from_now, end_date: 4.days.from_now, listing: listing)
    end

    before do
      create(:booking, start_date: 2.days.from_now, end_date: 4.days.from_now, listing: listing)
    end

    it 'adds errors uniquess of listing index' do
      booking_2.validate
      expect(booking_2.errors.details)
        .to eq({ listing_id: [{ error: :taken, value: 1 }],
                 start_date: [{ error: :overlap }], end_date: [{ error: :overlap }] })
    end
  end

  describe '#callbacks' do
    describe 'after_create_commit' do
      let!(:listing) { create(:listing) }
      let(:booking) do
        build(:booking, start_date: 3.days.from_now, end_date: 4.days.from_now, listing: listing)
      end

      it 'creates the first checkin_mission' do
        expect { booking.save }.to change(
          Mission.where(listing_id: booking.listing_id,
                        date: booking.start_date,
                        price: 10 * listing.num_rooms,
                        mission_type: :first_checkin), :count
        ).by(1)
      end

      it 'creates the last checkout_mission' do
        expect { booking.save }.to change(
          Mission.where(listing_id: booking.listing_id,
                        date: booking.end_date,
                        price: 5 * listing.num_rooms,
                        mission_type: :last_checkout), :count
        ).by(1)
      end
    end

    describe 'before_destroy' do
      let!(:listing) { create(:listing) }
      let!(:booking) do
        create(:booking, start_date: 3.days.from_now, end_date: 6.days.from_now, listing: listing)
      end

      it 'destroys the associated missions' do
        expect { booking.destroy }.to change(
          Mission.where(listing_id: booking.listing_id), :count
        ).by(-2)
      end
    end
  end
end
