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

ActiveRecord::Schema.define(:version => 20110113172627) do

  create_table "resource_records", :force => true do |t|
    t.string   "name",                                      :null => false
    t.string   "rdata",                                     :null => false
    t.string   "type",                                      :null => false
    t.integer  "ttl"
    t.integer  "priority"
    t.boolean  "active",                  :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "zone_id",                                   :null => false
  end

  add_index "resource_records", ["name", "type"], :name => "index_resource_records_on_name_and_type"
  add_index "resource_records", ["name"], :name => "index_resource_records_on_name"
  add_index "resource_records", ["type"], :name => "index_resource_records_on_type"
  add_index "resource_records", ["zone_id"], :name => "index_resource_records_on_zone_id"

  create_table "zones", :force => true do |t|
    t.string   "name",                             :null => false
    t.string   "type",       :default => "NATIVE", :null => false
    t.string   "master"
    t.string   "mname",                            :null => false
    t.string   "rname",                            :null => false
    t.integer  "serial",                           :null => false
    t.integer  "refresh",      :default => 10800,  :null => false
    t.integer  "retry",        :default => 3600,   :null => false
    t.integer  "expire",       :default => 604800, :null => false
    t.integer  "minimum",      :default => 3600,   :null => false
    t.boolean  "active",       :default => false,  :null => false
    t.boolean  "strict_validation",       :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "zones", ["name"], :name => "index_zones_on_name"
  add_index "zones", ["type"], :name => "index_zones_on_type"

end
