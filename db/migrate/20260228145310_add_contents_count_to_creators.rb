class AddContentsCountToCreators < ActiveRecord::Migration[8.1]
  def change
    add_column :creators, :contents_count, :integer, default: 0, null: false
  end
end
