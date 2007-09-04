class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :username, :string
      t.column :nickname, :string
      t.column :password_salt, :string, :limit => 40
      t.column :password_hash, :string, :limit => 40
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :last_login_at, :datetime
      t.column :last_seen_at, :datetime
      t.column :token, :string
      t.column :token_expires_at, :datetime
      t.column :admin, :boolean, :default => false
      t.column :activated, :boolean, :default => false
      t.column :email, :string
      t.column :biography, :text
    end
  end

  def self.down
    drop_table :users
  end
end
