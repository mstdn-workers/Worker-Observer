class CreateAccounts < ActiveRecord::Migration[4.2]
  def self.up
    create_table :accounts do |t|
      t.string :username
      t.string :nickname
    end
  end

  def self.down
    drop_table :accounts
  end
end
