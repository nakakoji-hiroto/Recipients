class CreateRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes do |t|
      t.integer :user_id, null: false
      t.integer :genre_id, null: false
      t.string :title, null: false
      t.text :catch_copy
      t.string :difficulty
      t.boolean :is_release, null: false, default: true
      t.timestamps
    end
  end
end
