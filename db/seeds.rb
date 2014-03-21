# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

roles = Role.create([ { name: 'ceo', limit: 1000000000 }, # 1 billion
                      { name: 'manager', limit: 10000 }, # 10 K
                      { name: 'peon', limit: 100 }
                    ])

users = User.create([
                      { email: 'ceo@xxerox.com', password: 'password', role_id: Role.all.first.id },
                      { email: 'manager@xxerox.com', password: 'password', role_id: Role.all[1].id},
                      { email: 'loser@xxerox.com', password: 'password', role_id: Role.all.last.id }
                    ])