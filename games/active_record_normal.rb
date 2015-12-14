require 'active_record'

# config
ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

# migrate the db
ActiveRecord::Schema.define do
  self.verbose = false
  create_table(:users) { |t| t.string :name }
  create_table :posts do |t|
    t.string :name
    t.integer :user_id
  end
end

# models
class User < ActiveRecord::Base
  has_many :posts
end

class Post < ActiveRecord::Base
  belongs_to :user
end

# seeds
User.create! name: 'Josh', posts: [
  Post.new(name: 'yo ho ho'),
  Post.new(name: 'and a bottle of rum')
]

# controller / tests / wherever
User.first   # => #<User id: 1, name: "Josh">
    .posts   # => #<ActiveRecord::Association...
    .first   # => #<Post id: 1, name: "yo ho ...
    .user    # => #<User id: 1, name: "Josh">
    .name    # => "Josh"
    .upcase  # => "JOSH"
