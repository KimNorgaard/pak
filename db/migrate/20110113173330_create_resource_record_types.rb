class CreateResourceRecordTypes < ActiveRecord::Migration
  def self.up
    create_table :resource_record_types do |t|
      t.string :name,            :null => false
      t.string :description
      t.boolean :needs_priority, :default => 0

      t.timestamps
    end
    
    add_index :resource_record_types, :name
  end

  def self.down
    drop_table :resource_record_types
  end
end
