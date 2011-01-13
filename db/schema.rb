# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110113173330) do

  create_table "resource_record_types", :force => true do |t|
    t.string   "name",                              :null => false
    t.string   "description"
    t.boolean  "needs_priority", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resource_record_types", ["name"], :name => "index_resource_record_types_on_name"

  create_table "resource_records", :force => true do |t|
    t.string   "name",                                      :null => false
    t.string   "rdata",                                     :null => false
    t.integer  "ttl"
    t.integer  "priority"
    t.boolean  "active",                  :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "zone_id",                                   :null => false
    t.integer  "resource_record_type_id",                   :null => false
  end

  add_index "resource_records", ["name", "resource_record_type_id"], :name => "index_resource_records_on_name_and_resource_record_type_id"
  add_index "resource_records", ["name"], :name => "index_resource_records_on_name"
  add_index "resource_records", ["resource_record_type_id"], :name => "index_resource_records_on_resource_record_type_id"
  add_index "resource_records", ["zone_id"], :name => "index_resource_records_on_zone_id"

  create_table "zone_types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "zone_types", ["name"], :name => "index_zone_types_on_name"

  create_table "zones", :force => true do |t|
    t.string   "name",                             :null => false
    t.string   "master"
    t.string   "mname",                            :null => false
    t.string   "rname",                            :null => false
    t.integer  "serial",                           :null => false
    t.integer  "refresh",      :default => 10800,  :null => false
    t.integer  "retry",        :default => 3600,   :null => false
    t.integer  "expire",       :default => 604800, :null => false
    t.integer  "minimum",      :default => 3600,   :null => false
    t.boolean  "active",       :default => true,   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "zone_type_id", :default => 1,      :null => false
  end

  add_index "zones", ["name"], :name => "index_zones_on_name"

end
