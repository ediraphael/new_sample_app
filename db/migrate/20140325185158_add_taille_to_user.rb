class AddTailleToUser < ActiveRecord::Migration
  def up
    add_column :users, :taille, :int
  end

  def down
    remove_column :users, :taille, :int
  end
end
