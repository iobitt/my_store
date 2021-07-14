require 'rails_helper'


describe ProductsPuller do

  before :each do
    @user = Manager.create!(name: "ivan", password: "12891289")
    @products_puller = ProductsPuller.new(@user)
  end

  it "проверяет создание товаров" do
    data = {
      "products": [
        {
          "id": 1,
          "name": "Телефон",
          "price": 3500,
          "quantity": 10,
          "created_at": DateTime.now,
          "updated_at": DateTime.now
        },
        {
          "id": 2,
          "name": "Мыло",
          "price": 30,
          "quantity": 180,
          "created_at": DateTime.now,
          "updated_at": DateTime.now
        },
        {
          "id": 3,
          "name": "Шоколад",
          "price": 80,
          "quantity": 300,
          "created_at": DateTime.now,
          "updated_at": DateTime.now
        }
      ]
    }
    products = ProductMirror.where :user_id => @user.id

    data = data.deep_transform_keys{ |key| key.to_s }
    @products_puller.send :create_or_update_products, data, products, [1, 2, 3]

    expect(ProductMirror.count).to eq(3)
  end

  it "проверяет удаление товаров" do
    ProductMirror.create!({external_id: 1, name: "Телефон", price: 3500, quantity: 10, user_id: @user.id})
    ProductMirror.create!({external_id: 2, name: "Телевизор", price: 3500, quantity: 10, user_id: @user.id})
    ProductMirror.create!({external_id: 3, name: "Планшет", price: 3500, quantity: 10, user_id: @user.id})

    products = ProductMirror.where :user_id => @user.id

    @products_puller.send :delete_products, products, [2]

    product = ProductMirror.find_by_external_id(2)
    expect(product.is_archived).to eq(true)
  end

  it "проверяет изменение товаров" do
    ProductMirror.create!({external_id: 1, name: "Телефон", price: 3500, quantity: 10, user_id: @user.id})
    ProductMirror.create!({external_id: 2, name: "Телевизор", price: 30, quantity: 180, user_id: @user.id})
    ProductMirror.create!({external_id: 3, name: "Планшет", price: 80, quantity: 300, user_id: @user.id})

    data = {
      "products": [
        {
          "id": 1,
          "name": "Телефон 2",
          "price": 1700,
          "quantity": 20,
          "created_at": DateTime.now,
          "updated_at": DateTime.now
        },
        {
          "id": 2,
          "name": "Телевизор",
          "price": 30,
          "quantity": 180,
          "created_at": DateTime.now,
          "updated_at": DateTime.now
        },
        {
          "id": 3,
          "name": "Планшет",
          "price": 80,
          "quantity": 300,
          "created_at": DateTime.now,
          "updated_at": DateTime.now
        }
      ]
    }

    products = ProductMirror.where :user_id => @user.id
    data = data.deep_transform_keys{ |key| key.to_s }

    @products_puller.send :create_or_update_products, data, products, []

    product = ProductMirror.find_by_external_id(1)
    expect(product.name).to eq("Телефон 2")
    expect(product.price).to eq(1700)
    expect(product.quantity).to eq(20)
  end

end


describe ProductsSyncer do

  before :each do
    @before_sync_datetime = DateTime.now
    Manager.create!(id: 5, name: "ivan", password: "12891289")
  end

  it "проверяет создание товаров" do
    ProductMirror.create!({external_id: 1, name: "Телефон", price: 3500, quantity: 10, user_id: 5,
                           external_created_at: DateTime.new(2021, 7, 14, 4, 5, 6),
                           external_updated_at: DateTime.new(2021, 7, 14, 4, 5, 6)
                          })
    ProductMirror.create!({external_id: 2, name: "Телевизор", price: 3500, quantity: 10, user_id: 5,
                           external_created_at: DateTime.new(2021, 7, 14, 4, 5, 7),
                           external_updated_at: DateTime.new(2021, 7, 14, 4, 5, 7)
                          })
    ProductMirror.create!({external_id: 3, name: "Планшет", price: 3500, quantity: 10, user_id: 5,
                           external_created_at: DateTime.new(2021, 7, 14, 4, 5, 8),
                           external_updated_at: DateTime.new(2021, 7, 14, 4, 5, 8)
                          })

    expect(ProductMirror.count).to eq(3)
    expect(Product.count).to eq(0)
    ProductsSyncer.new(@before_sync_datetime).call
    expect(Product.count).to eq(3)
  end

  it "проверяет изменение товаров" do
    Product.create!({id: 1, name: "Телефон", price: 3500, quantity: 10, user_id: 5 })
    Product.create!({id: 2, name: "Телевизор", price: 3500, quantity: 10, user_id: 5 })
    Product.create!({id: 3, name: "Планшет", price: 3500, quantity: 10, user_id: 5 })

    ProductMirror.create!({external_id: 1, name: "Телефон", price: 3500, quantity: 10, user_id: 5, inner_id: 1,
                           external_created_at: DateTime.new(2021, 7, 14, 4, 5, 6),
                           external_updated_at: DateTime.new(2021, 7, 14, 4, 5, 6)
                          })
    ProductMirror.create!({external_id: 2, name: "Телевизор", price: 3500, quantity: 10, user_id: 5, inner_id: 2,
                           external_created_at: DateTime.new(2021, 7, 14, 4, 5, 7),
                           external_updated_at: DateTime.new(2021, 7, 14, 4, 5, 7)
                          })
    ProductMirror.create!({external_id: 3, name: "Планшет большой", price: 5000, quantity: 20, user_id: 5, inner_id: 3,
                           external_created_at: DateTime.new(2021, 7, 14, 4, 5, 8),
                           external_updated_at: DateTime.new(2021, 7, 14, 4, 5, 8)
                          })

    ProductsSyncer.new(@before_sync_datetime).call

    product3 = Product.find(3)
    expect(product3.name).to eq("Планшет большой")
    expect(product3.price).to eq(5000)
    expect(product3.quantity).to eq(20)
  end

  it "проверяет удаление товаров" do
    Product.create!({id: 1, name: "Телефон", price: 3500, quantity: 10, user_id: 5 })
    Product.create!({id: 2, name: "Телевизор", price: 3500, quantity: 10, user_id: 5 })
    Product.create!({id: 3, name: "Планшет", price: 3500, quantity: 10, user_id: 5 })

    ProductMirror.create!({external_id: 1, name: "Телефон", price: 3500, quantity: 10, user_id: 5, inner_id: 1,
                           external_created_at: DateTime.new(2021, 7, 14, 4, 5, 6),
                           external_updated_at: DateTime.new(2021, 7, 14, 4, 5, 6)
                          })
    ProductMirror.create!({external_id: 2, name: "Телевизор", price: 3500, quantity: 10, user_id: 5, inner_id: 2,
                           external_created_at: DateTime.new(2021, 7, 14, 4, 5, 7),
                           external_updated_at: DateTime.new(2021, 7, 14, 4, 5, 7)
                          })
    ProductMirror.create!({external_id: 3, name: "Планшет", price: 3500, quantity: 10, user_id: 5, inner_id: 3,
                           external_created_at: DateTime.new(2021, 7, 14, 4, 5, 8),
                           external_updated_at: DateTime.new(2021, 7, 14, 4, 5, 8), is_archived: true
                          })

    ProductsSyncer.new(@before_sync_datetime).call
    expect(Product.exists?(3)).to eq(false)
  end
end
