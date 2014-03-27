class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :nom
      t.string :email
      t.string :dateNaissance
      t.float :poid
      t.float :poidIdeal
      t.boolean :sport

      t.timestamps
    end
  end
end
