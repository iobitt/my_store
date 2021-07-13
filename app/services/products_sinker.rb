require 'active_record'
require_relative '../models/application_record'
require_relative '../models/product_mirror'
require_relative '../models/product'
require_relative 'db_connection'


class ProductsSinker

  def call
    products = Product.all
    products_mirror = ProductMirror.all

    products_mirror.each do |i|
      pi = products.find{ |a| a.id == i.inner_id}

      # Если заархивирован, то удаляем
      if i.is_archived
        if pi
          pi.destroy
        end
      # Если нет внутрнеего ID, значит товар новый - создаем
      elsif i.inner_id.nil?
        new_p = Product.new(name: i.name, price: i.price, quantity: i.quantity, user_id: i.user_id, created_at: i.created_at, updated_at: i.updated_at)
        new_p.save
        i.inner_id = new_p.id
        i.save
      # В противном случае, просто обновляем значения полей
      else
        pi.update(name: i.name, price: i.price, quantity: i.quantity, user_id: i.user_id, created_at: i.created_at, updated_at: i.updated_at)
        pi.save
      end
    end

    [true, nil, nil]
  end

end
