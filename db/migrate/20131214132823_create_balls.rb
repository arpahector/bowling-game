class CreateBalls < ActiveRecord::Migration
  def change
    create_table :balls do |t|
      t.integer :pins
      t.integer :score

      t.timestamps
    end
  end
end
