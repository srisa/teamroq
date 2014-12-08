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

ActiveRecord::Schema.define(version: 20141206105843) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "unaccent"
  enable_extension "fuzzystrmatch"
  enable_extension "hstore"

  create_table "activities", force: true do |t|
    t.integer  "user_id"
    t.string   "action"
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "affected_type"
    t.integer  "affected_id"
    t.string   "path"
    t.string   "actable_type"
    t.integer  "actable_id"
  end

  add_index "activities", ["affected_id", "affected_type"], name: "index_activities_on_affected_id_and_affected_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree
  add_index "activities", ["trackable_id"], name: "index_activities_on_trackable_id", using: :btree
  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "announcements", force: true do |t|
    t.text     "content"
    t.integer  "announcable_id"
    t.string   "announcable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "announcements", ["announcable_id"], name: "index_announcements_on_announcable_id", using: :btree

  create_table "answers", force: true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "question_id"
    t.integer  "user_id"
    t.boolean  "answer_mark"
    t.hstore   "store"
    t.integer  "up_votes",    default: [], array: true
    t.integer  "down_votes",  default: [], array: true
  end

  add_index "answers", ["down_votes"], name: "index_answers_on_down_votes", using: :gin
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["up_votes"], name: "index_answers_on_up_votes", using: :gin
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "badges", force: true do |t|
    t.string   "name"
    t.integer  "type_id"
    t.integer  "points"
    t.boolean  "default"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "badges", ["type_id"], name: "index_badges_on_type_id", using: :btree

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "discussions", force: true do |t|
    t.text     "content"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "discussable_type"
    t.integer  "discussable_id"
    t.hstore   "store"
    t.integer  "followers",        default: [], array: true
  end

  add_index "discussions", ["discussable_id"], name: "index_discussions_on_discussable_id", using: :btree
  add_index "discussions", ["followers"], name: "index_discussions_on_followers", using: :gin
  add_index "discussions", ["user_id"], name: "index_discussions_on_user_id", using: :btree

  create_table "document_versions", force: true do |t|
    t.integer  "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "release_note"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  add_index "document_versions", ["document_id"], name: "index_document_versions_on_document_id", using: :btree

  create_table "documents", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "attachable_type"
    t.integer  "attachable_id"
    t.integer  "referencable_id"
    t.string   "referencable_type"
  end

  add_index "documents", ["attachable_id", "attachable_type"], name: "index_documents_on_attachable_id_and_attachable_type", using: :btree
  add_index "documents", ["referencable_id"], name: "index_documents_on_referencable_id", using: :btree
  add_index "documents", ["referencable_type"], name: "index_documents_on_referencable_type", using: :btree
  add_index "documents", ["user_id"], name: "index_documents_on_user_id", using: :btree

  create_table "favorites", force: true do |t|
    t.integer  "favorable_id"
    t.string   "favorable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["favorable_id", "favorable_type"], name: "index_favorites_on_favorable_id_and_favorable_type", using: :btree
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "group_roles", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_roles", ["group_id"], name: "index_group_roles_on_group_id", using: :btree
  add_index "group_roles", ["user_id"], name: "index_group_roles_on_user_id", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "groups", ["slug"], name: "index_groups_on_slug", unique: true, using: :btree

  create_table "levels", force: true do |t|
    t.integer  "badge_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "levels", ["badge_id", "user_id"], name: "index_levels_on_badge_id_and_user_id", using: :btree
  add_index "levels", ["badge_id"], name: "index_levels_on_badge_id", using: :btree
  add_index "levels", ["user_id"], name: "index_levels_on_user_id", using: :btree

  create_table "points", force: true do |t|
    t.integer  "user_id"
    t.integer  "type_id"
    t.decimal  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "points", ["type_id"], name: "index_points_on_type_id", using: :btree
  add_index "points", ["user_id"], name: "index_points_on_user_id", using: :btree

  create_table "posts", force: true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "postable_id"
    t.string   "postable_type"
    t.string   "title"
    t.integer  "followers",     default: [], array: true
  end

  add_index "posts", ["followers"], name: "index_posts_on_followers", using: :gin
  add_index "posts", ["postable_id", "postable_type"], name: "index_posts_on_postable_id_and_postable_type", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "project_roles", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_roles", ["project_id"], name: "index_project_roles_on_project_id", using: :btree
  add_index "project_roles", ["user_id"], name: "index_project_roles_on_user_id", using: :btree

  create_table "projects", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "slug"
  end

  add_index "projects", ["slug"], name: "index_projects_on_slug", using: :btree

  create_table "questions", force: true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "askable_id"
    t.string   "askable_type"
    t.string   "title"
    t.string   "slug"
    t.integer  "answers_count"
    t.hstore   "store"
    t.integer  "followers",     default: [], array: true
    t.integer  "up_votes",      default: [], array: true
    t.integer  "down_votes",    default: [], array: true
    t.integer  "votes",         default: 0
  end

  add_index "questions", ["down_votes"], name: "index_questions_on_down_votes", using: :gin
  add_index "questions", ["followers"], name: "index_questions_on_followers", using: :gin
  add_index "questions", ["slug"], name: "index_questions_on_slug", using: :btree
  add_index "questions", ["up_votes"], name: "index_questions_on_up_votes", using: :gin
  add_index "questions", ["user_id"], name: "index_questions_on_user_id", using: :btree
  add_index "questions", ["votes"], name: "index_questions_on_votes", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
  add_index "taggings", ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.integer "followers",      default: [], array: true
  end

  add_index "tags", ["followers"], name: "index_tags_on_followers", using: :gin
  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "todo_lists", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.string   "slug"
  end

  add_index "todo_lists", ["project_id"], name: "index_todo_lists_on_project_id", using: :btree
  add_index "todo_lists", ["slug"], name: "index_todo_lists_on_slug", using: :btree

  create_table "todos", force: true do |t|
    t.string   "name"
    t.integer  "todo_list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.integer  "user_id"
    t.text     "details"
    t.datetime "closed_on"
    t.date     "target_date"
    t.string   "slug"
    t.hstore   "store"
    t.integer  "followers",    default: [], array: true
  end

  add_index "todos", ["followers"], name: "index_todos_on_followers", using: :gin
  add_index "todos", ["slug"], name: "index_todos_on_slug", using: :btree
  add_index "todos", ["todo_list_id"], name: "index_todos_on_todo_list_id", using: :btree
  add_index "todos", ["user_id"], name: "index_todos_on_user_id", using: :btree

  create_table "types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "profile_picture_file_name"
    t.string   "profile_picture_content_type"
    t.integer  "profile_picture_file_size"
    t.datetime "profile_picture_updated_at"
    t.string   "encrypted_password",           default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "slug"
    t.string   "desk"
    t.string   "designation"
    t.string   "skill"
    t.string   "detail"
    t.string   "time_zone"
    t.hstore   "store"
    t.integer  "followers",                    default: [],              array: true
    t.integer  "feed",                         default: [],              array: true
    t.integer  "notifications",                default: [],              array: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["feed"], name: "index_users_on_feed", using: :gin
  add_index "users", ["followers"], name: "index_users_on_followers", using: :gin
  add_index "users", ["notifications"], name: "index_users_on_notifications", using: :gin
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
