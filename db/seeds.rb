User.create!(full_name: "Tran Bao",
  email: "tranvanbao2201@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  address: "60 ngo si lien",
  role: :admin,
  phone: "0877654121")

  women = Category.create(name: 'Women')
  women_bags = Category.create(name: 'Bags', parent: women)
  women_clothes = Category.create(name: 'Clothes', parent: women)
