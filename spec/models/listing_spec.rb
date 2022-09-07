# frozen_string_literal: true

describe Listing, type: :model do
  it { is_expected.to validate_presence_of(:num_rooms) }

  it do
    expect(subject).to validate_numericality_of(:num_rooms).is_greater_than_or_equal_to(1)
  end

end
