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

ActiveRecord::Schema.define(version: 20141030135852) do

  create_table "agreements", force: true do |t|
    t.text     "detail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bookmarks", force: true do |t|
    t.integer  "user_id"
    t.integer  "bookmarkable_id"
    t.string   "bookmarkable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.string   "title",            limit: 50, default: ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.string   "role",                        default: "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "courses", force: true, comment: "课程" do |t|
    t.integer  "user_id",                                 comment: "所属用户id"
    t.integer  "teacher_id",                              comment: "教师id"
    t.string   "title",                                   comment: "标题"
    t.string   "token"
    t.string   "image",                                   comment: "图标"
    t.string   "tmp_image"
    t.string   "category",                                comment: "分类"
    t.string   "address",                                 comment: "所开地址"
    t.string   "course_type",                             comment: "类型"
    t.datetime "start_time",                              comment: "开始时间"
    t.datetime "end_time",                                comment: "结束时间"
    t.integer  "students_count",                          comment: "学生数量"
    t.integer  "students_max",                            comment: "最大学生数量"
    t.decimal  "price",          precision: 15, scale: 3, comment: "价格"
    t.integer  "mark_count"
    t.text     "detail",                                  comment: "详细"
    t.integer  "status",                                  comment: "课程状态"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "courses", ["token"], name: "index_courses_on_token", unique: true, using: :btree

  create_table "learnships", force: true do |t|
    t.integer  "student_id"
    t.integer  "lesson_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lessons", force: true do |t|
    t.integer  "user_id"
    t.integer  "course_id"
    t.string   "title"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lessons", ["token"], name: "index_lessons_on_token", unique: true, using: :btree

  create_table "orders", force: true, comment: "订单" do |t|
    t.integer  "user_id",                                                  null: false, comment: "订单所属用户id"
    t.integer  "goods_id",                                                 null: false, comment: "商品id"
    t.integer  "quantity",                            default: 1,          null: false, comment: "数量"
    t.decimal  "price",      precision: 16, scale: 2, default: 0.0,        null: false, comment: "价格(元)"
    t.decimal  "discount",   precision: 16, scale: 2, default: 0.0,        null: false, comment: "打折后的价格(元)"
    t.string   "trade_no",                                                 null: false, comment: "交易号"
    t.string   "status",                              default: "pendding", null: false, comment: "订单状态"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["trade_no"], name: "index_orders_on_trade_no", unique: true, using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "studyships", force: true do |t|
    t.integer  "student_id"
    t.integer  "course_id"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "studyships", ["token"], name: "index_studyships_on_token", unique: true, using: :btree

  create_table "teachers", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "sex"
    t.string   "phone"
    t.string   "email"
    t.string   "organ_name"
    t.text     "organ_detail"
    t.integer  "agreement_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "username",               default: "", null: false
    t.string   "phone",                  default: "", null: false
    t.string   "avatar"
    t.string   "tmp_avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "videos", force: true do |t|
    t.string   "stream_name"
    t.integer  "videoable_id"
    t.string   "videoable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
