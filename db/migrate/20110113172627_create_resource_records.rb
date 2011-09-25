class CreateResourceRecords < ActiveRecord::Migration
  def self.up
    create_table :resource_records do |t|
      t.string :name,     :null => false
      t.string :rdata,    :null => false
      t.string :type, :null => false
      t.integer :ttl
      t.integer :priority
      t.boolean :active,  :null => false, :default => 1

      t.timestamps
      
      t.references :zone, :null => false
    end
    
    add_index :resource_records, :zone_id
    add_index :resource_records, :name
    add_index :resource_records, :type
    add_index :resource_records, [ :name, :type ]
  end

  def self.down
    drop_table :resource_records
  end
end
