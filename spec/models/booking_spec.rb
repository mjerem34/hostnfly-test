# frozen_string_literal: true

describe Booking, type: :model do
  it { is_expected.to belong_to(:listing) }

  it { is_expected.to validate_presence_of(:start_date) }
  it { is_expected.to validate_presence_of(:end_date) }

  describe 'is after start' do
    context 'when the start_date is before the end_date' do
      let(:booking) do
        build(:booking, start_date: '2021-01-01', end_date: '2021-01-10')
      end

      it 'is valid' do
        booking.validate
        expect(booking.errors.details).to be_blank
      end
    end

    context 'when the start_date is after the end_date' do
      let(:booking) do
        build(:booking, start_date: '2021-01-10', end_date: '2021-01-01')
      end

      it 'is not valid' do
        I18n.with_locale(:en) do
          booking.validate

          expect(booking.errors.details).to eq({ start_date: [{ error: :greater_than_end_date }] })
        end
      end
    end
  end

  context 'when there is already a booking on these dates' do
    let!(:listing) { create(:listing) }
    let(:booking_2) do
      build(:booking, start_date: 2.days.from_now, end_date: 3.days.from_now,
                      listing: listing)
    end

    before do
      create(:booking, start_date: 2.days.from_now, end_date: 3.days.from_now,
                       listing: listing)
    end

    it 'adds errors for overlapping other booking' do
      I18n.with_locale(:en) do
        booking_2.validate

        expect(booking_2.errors.details)
          .to eq({ listing_id: [{ error: :taken, value: 1 }],
                   start_date: [{ error: :overlap }],
                   end_date: [{ error: :overlap }] })
      end
    end
  end
end
