# sets up ActiveRecord
require 'active_record'
require 'logger'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'
ActiveRecord::Base.logger = Logger.new $stdout
ActiveSupport::LogSubscriber.colorize_logging = false


# the schema of the database (migrations)
ActiveRecord::Schema.define do
  self.verbose = false
  create_table :articles do |t|
    t.string :title
    t.string :body
  end
  create_table :tags do |t|
    t.string :tag_name
  end
  create_table :article_tags do |t|
    t.integer :article_id
    t.integer :tag_id
  end
end


# Models (The "M" in "MVC")
class Article < ActiveRecord::Base
  has_many :article_tags
  has_many :tags, through: :article_tags
end

class Tag < ActiveRecord::Base
  has_many :article_tags
  has_many :articles, through: :article_tags
end

class ArticleTag < ActiveRecord::Base
  belongs_to :article
  belongs_to :tag
end


# How does it understand plural vs singular?!
require 'active_support/core_ext/string'
"tags"         # => "tags"
  .pluralize   # => "tags"
  .pluralize   # => "tags"
  .singularize # => "tag"


# Console / within a controller / test / model / seeds (basically this can go anywhere)
article = Article.create! title: 'oatmeal is delicious', body: 'insert text here'
article                     # => #<Article id: 1, title: "oatmeal is delicious", body: "insert text here">
  .tags                     # => #<ActiveRecord::Associations::CollectionProxy []>
  .create(tag_name: 'food') # => #<Tag id: 1, tag_name: "food">
  .articles                 # => #<ActiveRecord::Associations::CollectionProxy [#<Article id: 1, title: "oatmeal is delicious", body: "insert text here">]>
  .first                    # => #<Article id: 1, title: "oatmeal is delicious", body: "insert text here">
  .title                    # => "oatmeal is delicious"

# >> D, [2015-10-19T14:46:00.420119 #93322] DEBUG -- :    (0.3ms)  CREATE TABLE "articles" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar, "body" varchar)
# >> D, [2015-10-19T14:46:00.420479 #93322] DEBUG -- :    (0.1ms)  CREATE TABLE "tags" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "tag_name" varchar)
# >> D, [2015-10-19T14:46:00.420750 #93322] DEBUG -- :    (0.1ms)  CREATE TABLE "article_tags" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "article_id" integer, "tag_id" integer)
# >> D, [2015-10-19T14:46:00.478653 #93322] DEBUG -- :    (0.1ms)  begin transaction
# >> D, [2015-10-19T14:46:00.484243 #93322] DEBUG -- :   SQL (0.1ms)  INSERT INTO "articles" ("title", "body") VALUES (?, ?)  [["title", "oatmeal is delicious"], ["body", "insert text here"]]
# >> D, [2015-10-19T14:46:00.484597 #93322] DEBUG -- :    (0.0ms)  commit transaction
# >> D, [2015-10-19T14:46:00.505815 #93322] DEBUG -- :   Tag Load (0.1ms)  SELECT "tags".* FROM "tags" INNER JOIN "article_tags" ON "tags"."id" = "article_tags"."tag_id" WHERE "article_tags"."article_id" = ?  [["article_id", 1]]
# >> D, [2015-10-19T14:46:00.506304 #93322] DEBUG -- :    (0.1ms)  begin transaction
# >> D, [2015-10-19T14:46:00.508732 #93322] DEBUG -- :   SQL (0.1ms)  INSERT INTO "tags" ("tag_name") VALUES (?)  [["tag_name", "food"]]
# >> D, [2015-10-19T14:46:00.513995 #93322] DEBUG -- :   SQL (0.1ms)  INSERT INTO "article_tags" ("article_id", "tag_id") VALUES (?, ?)  [["article_id", 1], ["tag_id", 1]]
# >> D, [2015-10-19T14:46:00.514253 #93322] DEBUG -- :    (0.0ms)  commit transaction
# >> D, [2015-10-19T14:46:00.515935 #93322] DEBUG -- :   Article Load (0.1ms)  SELECT "articles".* FROM "articles" INNER JOIN "article_tags" ON "articles"."id" = "article_tags"."article_id" WHERE "article_tags"."tag_id" = ?  [["tag_id", 1]]
