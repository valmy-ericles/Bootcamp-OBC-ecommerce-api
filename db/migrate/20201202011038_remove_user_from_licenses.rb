class RemoveUserFromLicenses < ActiveRecord::Migration[6.0]
  def change
    remove_reference :licenses, :user, null: false, foreign_key: true
  end
end
