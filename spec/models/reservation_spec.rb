# frozen_string_literal: true

describe Reservation, type: :model do
  it { is_expected.to belong_to(:listing) }

  it { is_expected.to validate_presence_of(:start_date) }
  it { is_expected.to validate_presence_of(:end_date) }

  describe 'is after start' do
    context 'when the start_date is before the end_date' do
      let(:reservation) { build(:reservation, start_date: '2021-01-01', end_date: '2021-01-10') }

      it 'is valid' do
        reservation.validate
        expect(reservation.errors.details).to be_blank
      end
    end

    context 'when the start_date is after the end_date' do
      let(:reservation) { build(:reservation, start_date: '2021-01-10', end_date: '2021-01-01') }

      it 'is not valid' do
        reservation.validate
        expect(reservation.errors.details)
          .to eq({ start_date: [{ error: :greater_than_end_date }] })
      end
    end
  end

  context 'when there is already a reservation on these dates' do
    let!(:listing) { create(:listing) }
    let(:reservation_2) do
      build(:reservation, start_date: 3.days.from_now, end_date: 4.days.from_now, listing: listing)
    end

    before do
      create(:reservation, start_date: 2.days.from_now, end_date: 7.days.from_now, listing: listing)
    end

    it 'adds errors for overlapping other reservation' do
      reservation_2.validate
      expect(reservation_2.errors.details)
        .to eq({ start_date: [{ error: :overlap }], end_date: [{ error: :overlap }] })
    end
  end

  context 'when an other reservation has the same start_date and last_date on the listing' do
    let!(:listing) { create(:listing) }
    let(:reservation_2) do
      build(:reservation, start_date: 2.days.from_now, end_date: 4.days.from_now, listing: listing)
    end

    before do
      create(:reservation, start_date: 2.days.from_now, end_date: 4.days.from_now, listing: listing)
    end

    it 'adds errors uniquess of listing index' do
      reservation_2.validate
      expect(reservation_2.errors.details)
        .to eq({ listing_id: [{ error: :taken, value: 1 }],
                 start_date: [{ error: :overlap }], end_date: [{ error: :overlap }] })
    end
  end

  describe '#callbacks' do
    describe 'after_create_commit' do
      let!(:listing) { create(:listing) }
      let(:reservation) do
        build(:reservation, start_date: 3.days.from_now, end_date: 4.days.from_now,
                            listing: listing)
      end

      describe 'create_checkout_checkin_mission' do
        it 'creates the checkout_checkin_mission' do
          expect { reservation.save }.to change(
            Mission.where(listing_id: reservation.listing_id,
                          date: reservation.end_date,
                          price: 10 * listing.num_rooms,
                          mission_type: :checkout_checkin), :count
          ).by(1)
        end

        context 'when a last_checkout_mission is already present the same day' do
          let!(:mission) do
            create(:mission, date: reservation.end_date, mission_type: :last_checkout,
                             listing: listing)
          end

          it 'does not create the checkout_checkin_mission' do
            expect { reservation.save }.to change(
              Mission.where(listing_id: reservation.listing_id,
                            date: reservation.end_date,
                            price: 10 * listing.num_rooms,
                            mission_type: :checkout_checkin), :count
            ).by(0)
          end
        end
      end
    end

    describe 'before_destroy' do
      let!(:listing) { create(:listing) }
      let!(:reservation) do
        create(:reservation, start_date: 3.days.from_now, end_date: 6.days.from_now,
                             listing: listing)
      end

      it 'destroys the associated missions' do
        expect { reservation.destroy }.to change(
          Mission.where(listing_id: reservation.listing_id), :count
        ).by(-1)
      end
    end
  end
end
