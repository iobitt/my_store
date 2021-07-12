require 'active_record'
require_relative '../app/models/application_record'
require_relative '../app/models/product_mirror'
require_relative '../app/models/product'
require_relative 'db_connection'


products = Product.all
products_mirror = ProductMirror.all

intersection = products.ids & products_mirror.ids
new_products = products_mirror.ids - products.ids
delete_products = products.ids - products_mirror.ids

new_products.sort
new_products.each do |i|
  mi = products_mirror.find{ |a| a.id == i}
  Product.create(id: mi.id, name: mi.name, price: mi.price, quantity: mi.quantity, user_id: mi.user_id, created_at: mi.created_at, updated_at: mi.updated_at)
end

intersection.each do |i|
  mi = products_mirror.find{ |a| a.id == i}
  pi = products .find{ |a| a.id == i}

  if mi.updated_at != pi.updated_at
    pi.update(name: mi.name, price: mi.price, quantity: mi.quantity, user_id: mi.user_id, created_at: mi.created_at, updated_at: mi.updated_at)
    pi.save!
  end
end

delete_products.each do |i|
  mi = products.find{ |a| a.id == i}
  mi.destroy
end

ProductMirror.delete_all
