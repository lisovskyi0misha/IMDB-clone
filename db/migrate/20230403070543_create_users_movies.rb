class CreateUsersMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :ratings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true
      t.integer :points
      t.index [:user_id, :movie_id]

      t.timestamps
    end
  end
end
