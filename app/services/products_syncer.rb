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
        new_product = Product.new(product_mirror.mapping)
        new_product.save
        product_mirror.inner_id = new_product.id
        product_mirror.save
      # В противном случае, просто обновляем значения полей
      else
        product.update(product_mirror.mapping)
      end
    end

    [true, nil, nil]
  end

end
