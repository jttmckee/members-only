class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.references :author, index: true

      t.timestamps
    end
    add_foreign_key :posts, :users, column: :author_id
  end
end
