# Setup
require 'active_record'
ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

# Schema
ActiveRecord::Schema.define do
  self.verbose = false
  create_table(:users) { |t| t.string :name }
  create_table :posts do |t|
    t.string  :name
    t.integer :user_id
  end
end

# Models
User = Class.new(ActiveRecord::Base) { has_many   :posts }
Post = Class.new(ActiveRecord::Base) { belongs_to :user  }

# Data
User.create! name: 'Josh',  posts: [Post.new(name: 'yo ho ho'), Post.new(name: 'and a bottle of rum')]
User.create! name: 'Marlo', posts: [Post.new(name: 'I should post more')]

# Formatting (see examples at https://github.com/arches/table_print and http://tableprintgem.com)
# You'll have to `gem install table_print` in the Ruby you use for SiB
require 'table_print'
tp Post.all

  # Some other ones to try:
  #   tp User.all, :id, :name, {num_posts: -> u { u.posts.count }}, 'posts.name'
  #   tp Post.all, except: :user_id, include: 'user.name'

  # You can set up configuration options so that you don't have to repeatedly format it
  #   tp.set Post, :id, :name, user: -> post { post.user.name }
  #   tp Post.all

# >> ID | NAME                | USER_ID
# >> ---|---------------------|--------
# >> 1  | yo ho ho            | 1
# >> 2  | and a bottle of rum | 1
# >> 3  | I should post more  | 2
