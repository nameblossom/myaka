# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20130406224823) do

  create_table "akas", :force => true do |t|
    t.string   "subdomain",                         :null => false
    t.string   "email"
    t.string   "display_name"
    t.string   "password_digest"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "tent_server"
    t.boolean  "keep_me_updated", :default => true
  end

  add_index "akas", ["email"], :name => "index_akas_on_email"
  add_index "akas", ["subdomain"], :name => "index_akas_on_subdomain", :unique => true

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "open_id_associations", :force => true do |t|
    t.string  "server_url", :null => false
    t.string  "handle",     :null => false
    t.binary  "secret",     :null => false
    t.integer "issued",     :null => false
    t.integer "lifetime",   :null => false
    t.string  "assoc_type", :null => false
  end

  add_index "open_id_associations", ["server_url", "handle"], :name => "index_open_id_associations_on_server_url_and_handle"

  create_table "open_id_nonces", :force => true do |t|
    t.string  "server_url", :null => false
    t.integer "timestamp",  :null => false
    t.string  "salt",       :null => false
  end

  add_index "open_id_nonces", ["timestamp", "server_url", "salt"], :name => "index_open_id_nonces_on_timestamp_and_server_url_and_salt"

  create_table "openid_trust_roots", :force => true do |t|
    t.integer  "aka_id"
    t.string   "trust_root"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "openid_trust_roots", ["aka_id", "trust_root"], :name => "index_openid_trust_roots_on_aka_id_and_trust_root", :unique => true

  create_table "password_resets", :force => true do |t|
    t.integer  "aka_id"
    t.datetime "expiration"
    t.string   "key"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "password_resets", ["aka_id"], :name => "index_password_resets_on_aka_id"

  create_table "profile_links", :force => true do |t|
    t.string   "href"
    t.string   "title"
    t.boolean  "autofollow"
    t.integer  "aka_id"
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.string   "rel",         :default => "https://aka.nu/Profile"
    t.string   "external_id"
  end

  add_index "profile_links", ["aka_id"], :name => "index_profile_links_on_aka_id"

  create_table "profile_pages", :force => true do |t|
    t.integer  "aka_id"
    t.text     "profile_source"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "profile_pages", ["aka_id"], :name => "index_profile_pages_on_aka_id", :unique => true

  create_table "public_resources", :force => true do |t|
    t.integer  "aka_id"
    t.string   "path"
    t.text     "headers"
    t.string   "content_type"
    t.binary   "content"
    t.string   "etag"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "public_resources", ["aka_id", "path"], :name => "index_public_resources_on_aka_id_and_path"

end
