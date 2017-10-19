class CreateNames < ActiveRecord::Migration
  def self.up
    create_table :names do |t|
      t.references :accounts, index: true, foreign_key: true
      t.string :display_name
      t.integer :is_first
      t.timestamps
    end
  end

  def self.down
    drop_table :names
  end
end
