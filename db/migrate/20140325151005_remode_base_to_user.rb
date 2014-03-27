class RemodeBaseToUser < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.change :dateNaissance, :Date
    end
  end

  def down
    change_table :users do |t|
      t.change :dateNaissance, :String
    end
  end
end
