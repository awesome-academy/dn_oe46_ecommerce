User.create!(full_name: "Tran Bao",
            email: "tranvanbao2201@gmail.com",
            password: "123456",
            password_confirmation: "123456",
            address: "60 Ngo Si Lien, Lien Chieu",
            role: :admin,
            phone: "0877654121")


women = Category.create(name: "Women")
men = Category.create(name: "Men")
children = Category.create(name: "Children")
Category.create(name: "Bags", parent: women)
Category.create(name: "Clothes", parent: women)
Category.create(name: "Watchs", parent: women)
Category.create(name: "Bags", parent: men)
Category.create(name: "Clothes", parent: men)
Category.create(name: "Watchs", parent: men)
Category.create(name: "Bags", parent: children)
Category.create(name: "Clothes", parent: children)
Category.create(name: "Watchs", parent: children)

50.times do
  name = Faker::Commerce.product_name
  price = rand(10.0..50.0)
  quantity = rand(10..50)
  description = "Biti’s là thương hiệu giày nổi tiếng tại Việt Nam. Làm nên dấu ấn của thương hiệu
                 này phải kể đến dòng giày thể thao cao cấp Biti’s Hunter. Cửa hàng Biti’s Hunter
                 Independent có mặt ở 5 chi nhánh tại 3 thành phố Hà Nội, Sài Gòn, Đà Nẵng. Đến với
                 cửa hàng, bạn sẽ bị thu hút bởi những đôi giày được bày biện rất đẹp mắt.
                 Biti’s Hunter mang đến những đôi giày cực ư là chất lượng. Những thiết kế ở đây luôn
                 làm nổi bật lên đường sự thời thượng, phá cách những không kém phần tinh tế. Nếu là nam
                 thì bạn không phải lo lắng không có size. Tại Biti’s luôn có những size giày “cỡ đại”
                 giày bạn để phục vụ nhu cầu của bạn."
  category_id = rand(1..3)
  Product.create!(
    name: name,
    price: price,
    quantity: quantity,
    description: description,
    category_id: category_id)
end
