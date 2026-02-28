class CreateContents < ActiveRecord::Migration[8.1]
  def change
    create_table :contents do |t|
      t.references :creator, null: false, foreign_key: true
      t.string :title
      t.string :social_media_url
      t.integer :social_media_provider

      t.timestamps
    end
  end
end
