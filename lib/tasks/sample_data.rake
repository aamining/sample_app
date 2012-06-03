namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
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
end