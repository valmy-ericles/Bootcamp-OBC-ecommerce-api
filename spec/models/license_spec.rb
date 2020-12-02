require 'rails_helper'

RSpec.describe License, type: :model do
  it { is_expected.to validate_presence_of(:key) }
  it { is_expected.to validate_presence_of(:platform) }
  it { is_expected.to validate_presence_of(:status) }

  it { is_expected.to define_enum_for(:platform).with_values({ steam: 1, battle_net: 2, origin: 3 }) }
  it { is_expected.to define_enum_for(:status).with_values({ available: 1, currently_using: 2, inactive: 3 }) }

  context 'validate uniqueness of :key' do
    before :each do
      create(:license)
    end

    it { is_expected.to validate_uniqueness_of(:key).case_insensitive }
  end

  it { is_expected.to belong_to :game }

  it_behaves_like 'paginatable concern', :license
end
