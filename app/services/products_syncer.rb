require 'active_record'
require_relative '../models/application_record'
require_relative '../models/product_mirror'
require_relative '../models/product'
require_relative 'db_connection'


class ProductsSyncer

  def call
    products = Product.all
    products_mirror = ProductMirror.all

    products_mirror.each do |product_mirror|
      product = products.find{ |a| a.id == product_mirror.inner_id}

      # Если заархивирован, то удаляем
      if product_mirror.is_archived
        if product
          product.destroy
        end
      # Если нет внутрнеего ID, значит товар новый - создаем
      elsif product_mirror.inner_id.nil?
        new_product = Product.new(name: product_mirror.name, price: product_mirror.price,
                                  quantity: product_mirror.quantity, user_id: product_mirror.user_id,
                                  created_at: product_mirror.created_at, updated_at: product_mirror.updated_at)
        new_product.save
        product_mirror.inner_id = new_product.id
        product_mirror.save
      # В противном случае, просто обновляем значения полей
      else
        product.update(name: product_mirror.name, price: product_mirror.price, quantity: product_mirror.quantity,
                       user_id: product_mirror.user_id, created_at: product_mirror.created_at,
                       updated_at: product_mirror.updated_at)
      end
    end

    [true, nil, nil]
  end

end
