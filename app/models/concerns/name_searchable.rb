module NameSearchable
  extend ActiveSupport::Concern

  included do
    scope :search_by_name, lambda { |value|
      where('name ILIKE ?', "%#{value}%")
    }
  end
end
