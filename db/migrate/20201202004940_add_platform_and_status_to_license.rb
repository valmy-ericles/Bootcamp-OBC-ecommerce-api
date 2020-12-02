class AddPlatformAndStatusToLicense < ActiveRecord::Migration[6.0]
  def change
    add_column :licenses, :platform, :integer
    add_column :licenses, :status, :integer
  end
end
