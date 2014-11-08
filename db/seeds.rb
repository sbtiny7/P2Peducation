# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
u = User.create(username: '六十', email: 'chany229@sina.com', password: '000000', password_confirmation: '000000')
u.add_role(:admin, User)
u.add_role(:teacher, Teacher)