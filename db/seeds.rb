# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(name: 'Jason', email: 'jason@asdf.com', password: 'asdfasdf')
User.create(name: 'Howard', email: 'hting@asdf.com', password: 'asdfasdf')
User.create(name: 'Tomy', email: 'tommy@asdf.com', password: 'asdfasdf')
User.create(name: 'Philip', email: 'ptoy@asdf.com', password: 'asdfasdf')
User.create(name: 'Orion', email: 'song@asdf.com', password: 'asdfasdf')
User.create(name: 'Test1', email: 'tester@asdf.com', password: 'asdfasdf')
User.create(name: 'Test2', email: 'testing@asdf.com', password: 'asdfasdf')
User.create(name: 'Test3', email: 'tested@asdf.com', password: 'asdfasdf')
User.create(name: 'Test4', email: 'test@asdf.com', password: 'asdfasdf')

Topic.create(user_id: 1, last_registered_player_id: 8, title: 'Test Game',
             content: 'For game logic functionality test purpose',
             category: 1, phase: 1, day_timelimit: 1, night_timelimit: 1,
             num_mafia: 2, num_town: 6, roster_count: 8, num_players_alive: 8,
             who_won: -1)

Player.create(user_id: 1, topic_id: 1, affiliation: 'mafia', is_dead: false, vote_count: 0, prev_player_id: -1)
Player.create(user_id: 2, topic_id: 1, affiliation: 'mafia', is_dead: false, vote_count: 0, prev_player_id: 1)
Player.create(user_id: 3, topic_id: 1, affiliation: 'town', is_dead: false, vote_count: 0, prev_player_id: 2)
Player.create(user_id: 4, topic_id: 1, affiliation: 'town', is_dead: false, vote_count: 0, prev_player_id: 3)
Player.create(user_id: 5, topic_id: 1, affiliation: 'town', is_dead: false, vote_count: 0, prev_player_id: 4)
Player.create(user_id: 6, topic_id: 1, affiliation: 'town', is_dead: false, vote_count: 0, prev_player_id: 5)
Player.create(user_id: 7, topic_id: 1, affiliation: 'town', is_dead: false, vote_count: 0, prev_player_id: 6)
Player.create(user_id: 8, topic_id: 1, affiliation: 'town', is_dead: false, vote_count: 0, prev_player_id: 7)