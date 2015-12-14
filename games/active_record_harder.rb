require 'active_record'
ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
ActiveRecord::Schema.define do
  self.verbose = false
  create_table(:users) { |t| t.string :name }
  create_table :posts do |t|
    t.string :name
    t.integer :user_id
  end
end

User = Class.new(ActiveRecord::Base) { has_many :posts  }
Post = Class.new(ActiveRecord::Base) { belongs_to :user }
User.create! name: 'Josh',
             posts: [ {name: 'yo ho ho'},
                      {name: 'and a bottle of rum'},
             ].map(&Post.method(:new))

User.first             # => #<User id: 1, name: "Josh">
    .posts             # => #<ActiveRecord::Associatio...
    .first             # => #<Post id: 1, name: "yo ho...
    .user              # => #<User id: 1, name: "Josh">
    .name              # => "Josh"
    .upcase            # => "JOSH"
    .+(' <3s you ^_^') # => "JOSH <3s you ^_^"
