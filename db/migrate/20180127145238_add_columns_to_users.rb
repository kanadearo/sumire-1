class AddColumnsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :name, :string, default: "anonymous"
    add_column :users, :image, :string
    add_column :users, :picture, :string
    add_column :users, :user_access_token, :text
    add_column :users, :facebook_url, :string
    add_column :users, :twitter_url, :string
    add_column :users, :own_url, :string
  end
end
