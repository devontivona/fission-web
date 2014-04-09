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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140328174336) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apps", force: true do |t|
    t.string   "name"
    t.string   "access_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assignments", force: true do |t|
    t.integer  "client_id"
    t.integer  "variation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clients", force: true do |t|
    t.string   "library"
    t.string   "version"
    t.string   "manufacturer"
    t.string   "os"
    t.string   "os_version"
    t.string   "model"
    t.string   "carrier"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "app_id"
  end

  create_table "experiments", force: true do |t|
    t.string   "name"
    t.integer  "app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active",            default: true
    t.integer  "best_variation_id"
    t.integer  "base_variation_id"
    t.integer  "worst_variation_id"
    t.integer  "choice_variation_id"
    t.integer  "outcome_variation_id"
  end

  create_table "variations", force: true do |t|
    t.string   "name"
    t.integer  "experiment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "z_score"
    t.decimal  "probability"
    t.decimal  "difference"
  end

end
