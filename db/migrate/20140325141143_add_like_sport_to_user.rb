class AddLikeSportToUser < ActiveRecord::Migration
  def change
    add_column :users, :aimeSport, :boolean
  end
end
