users = 5.times.map do
  avatar = "http://robohash.org/#{Faker::Lorem.words.join}.png?size=400x400&set=set2"
  User.create!(
    email:       Faker::Internet.email,
    zipcode:     Faker::Address.zip_code,
    name:        Faker::Name.name,
    wishlist_id: "579KNEDD72QR",
    story:       Faker::Lorem.sentences(5).join(" "),
    avatar:      avatar
  )
end

2.times do
  Collection.create! do |c|
    c.title       = Faker::Lorem.words.map(&:capitalize).join(' ')
    c.description = Faker::Lorem.sentence
    c.user_id     = users.sample.id
    c.image       = 'http://lorempixel.com/400/200/abstract/?Y=400&X=400'

    8.times do
      c.pieces.build name:  Faker::Company.name,
                     image: 'http://lorempixel.com/400/200/abstract/?Y=400&X=400'
    end
  end
end
