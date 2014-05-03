class AddAssetToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :asset, :string
  end
end
