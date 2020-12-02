class AddUniqueIndexToLicenses < ActiveRecord::Migration[6.0]
  def change
    add_index :licenses, [:key, :platform], unique: true
  end
end
