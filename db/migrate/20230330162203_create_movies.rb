class CreateMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.string :title, null: false
      t.text :text
      t.float :rating, default: 0
      t.integer :category

      t.timestamps
    end
  end
end
