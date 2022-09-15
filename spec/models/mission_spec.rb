# frozen_string_literal: true

describe Mission, type: :model do
  it { is_expected.to belong_to(:listing) }

  it { is_expected.to validate_presence_of(:date) }
  it { is_expected.to validate_presence_of(:mission_type) }
  it { is_expected.to validate_presence_of(:price) }

  it do
    expect(subject).to define_enum_for(:mission_type)
      .with_values(described_class.mission_types.keys)
  end
end
