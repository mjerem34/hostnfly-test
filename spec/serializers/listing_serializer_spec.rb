# frozen_string_literal: true

describe ListingSerializer do
  subject(:serializer) { described_class.new(listing) }

  let(:listing) { create(:listing) }

  it 'returns the serialized listing' do
    expect(serializer.serializable_hash[:data]).to eq(
      id: listing.id.to_s,
      type: :listing,
      attributes: {
        numRooms: listing.num_rooms
      }
    )
  end
end
