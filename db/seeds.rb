def make_users
  admin = User.create!(name: "Example User",
                       email: "example@railstutorial.org",
                       password: "foobar",
                       password_confirmation: "foobar")
  admin.toggle!(:admin)

  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_microposts
  users = User.all(limit: 6)
  users.each do |user|
    50.times do
      I18n.locale = :en
      content = Faker::Lorem.sentence(5)
      micropost = user.microposts.create!(content: content)
      LANGUAGES.transpose.last.each do |locale|
        next if locale == "en"
        I18n.locale = locale.to_sym
        translation = Faker::Lorem.sentence(5)
        micropost.translations.create!(locale: locale, content: translation)
      end
    end
  end
end

def make_relationships
  users = User.all
  user = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end

make_users
make_microposts
make_relationships