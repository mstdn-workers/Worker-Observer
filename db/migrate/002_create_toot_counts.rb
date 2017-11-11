class CreateTootCounts < ActiveRecord::Migration[4.2]
  def self.up
    create_table :toot_counts do |t|
      t.belongs_to :account, index: true
      t.integer :toot_num_per_day
      t.integer :all_toot_num
      t.timestamps
    end
  end

  def self.down
    drop_table :toot_counts
  end
end
