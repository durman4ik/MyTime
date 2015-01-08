class CreateHomes < ActiveRecord::Migration
  def change
    create_table :homes do |t|
      t.string :day
      t.string :time

      t.timestamps
    end
  end
end
