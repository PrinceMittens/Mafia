# Mafia
The goal of this project: build a website that streamlines the forum-mafia experience both for users and for game mods.
#Update Log
##11-07-2016
* Bootstrap for CSS styling
```
```
* Devise for user authentication
```
```

##07-07-2016
* Gemfiles updated
```
in the file 'Gemfile' at root directory.
for compatibility, make sure to run 'bundle update' and 'bundle install' after cloning
```
* User, Topic, Post tables added
```
the word 'Thread' is a reserved word in Rails, so changed it to 'Topic'
after running 'rails db:migrate', you can download the file db/development.sqlite3
and open it with 'DB Browser for SQLite' for more details
also look at:
db/migrate/...
app/models/*.rb
```
* Temporary html pages
```
made some very basic example html pages to start working with:
app/views/example_pages/...
app/views/layouts/_example_header.html.erb
```
* 'Admin' page
```
added mainly for testing DB functionalities but also to show basic Ruby on Rails coding:
app/views/admin/manage.html.erb (the View)
app/controllers/admin_controller.rb (the Controller)
```