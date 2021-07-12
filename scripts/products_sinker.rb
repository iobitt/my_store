require 'active_record'
require_relative '../app/models/application_record'
require_relative '../app/models/product_mirror'
require_relative '../app/models/product'
require_relative 'db_connection'


products_mirror = ProductMirror.all
products = Product.where(id: products_mirror.ids)

products_mirror.each do |i|
  pi = products.find{ |a| a.id == i.id}

  if pi.nil?
    Product.create(id: i.id, name: i.name, price: i.price, quantity: i.quantity, user_id: i.user_id, created_at: i.created_at, updated_at: i.updated_at)
  else
    pi.update(name: i.name, price: i.price, quantity: i.quantity, user_id: i.user_id, created_at: i.created_at, updated_at: i.updated_at)
    pi.save
  end
end

ProductMirror.delete_all
