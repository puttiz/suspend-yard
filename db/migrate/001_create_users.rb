class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username, :nickname
      t.string :password_salt, :password_hash, :limit => 40
      t.string :email
      t.text :biography

      t.datetime :last_login_at, :last_seen_at
      t.string :token
      t.datetime :token_expires_at
      t.boolean :admin, :activated, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
