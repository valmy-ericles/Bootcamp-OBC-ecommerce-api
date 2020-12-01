require 'rails_helper'

RSpec.describe License, type: :model do
  it { is_expected.to validate_presence_of(:key) }

  context 'validate uniqueness of :key' do
    before :each do
      create(:license)
    end

    it { is_expected.to validate_uniqueness_of(:key).case_insensitive }
  end

  it { is_expected.to belong_to :game }
  it { is_expected.to belong_to :user }

  it_behaves_like 'paginatable concern', :license
end
