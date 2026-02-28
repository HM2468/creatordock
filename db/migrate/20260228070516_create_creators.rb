class CreateCreators < ActiveRecord::Migration[8.1]
  def change
    create_table :creators do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
    add_index :creators, :email
  end
end
