class ProductsSyncer

  def initialize(before_sync_datetime)
    @before_sync_datetime = before_sync_datetime
  end

  def call
    products_mirror = ProductMirror.joins("LEFT OUTER JOIN products ON product_mirrors.inner_id = products.id")
                            .where(["product_mirrors.updated_at > ?", @before_sync_datetime])
                            .select("product_mirrors.id, product_mirrors.name, product_mirrors.price, product_mirrors.quantity,
                                    product_mirrors.user_id, product_mirrors.updated_at, product_mirrors.created_at,
                                    product_mirrors.is_archived, product_mirrors.inner_id, products.name AS product_name")

    products_mirror.each do |product_mirror|
      # Если заархивирован, то удаляем
      if product_mirror.is_archived
        Product.destroy(product_mirror.inner_id)
      # Если нет внутрнеего ID, значит товар новый - создаем
      elsif product_mirror.inner_id.nil?
        new_product = Product.new(product_mirror.mapping)
        new_product.save!
        product_mirror.inner_id = new_product.id
        product_mirror.save!
      else
        Product.update(product_mirror.inner_id, product_mirror.mapping)
      end
    end
    [true, nil, nil]
  end

end
