class License < ApplicationRecord
  belongs_to :game

  validates :key, presence: true, uniqueness: { case_sensitive: false, scope: :platform }
  validates :platform, presence: true
  validates :status, presence: true

  enum platform: { steam: 1, battle_net: 2, origin: 3 }
  enum status: { available: 1, currently_using: 2, inactive: 3 }

  include Paginatable
end
