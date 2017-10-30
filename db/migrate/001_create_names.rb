class CreateNames < ActiveRecord::Migration[4.2]
  def self.up
    create_table :names do |t|
      t.belongs_to :account, index: true
      t.string :display_name
      t.integer :is_first
      t.timestamps
    end
  end

  def self.down
    drop_table :names
  end
end
