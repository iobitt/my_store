class ProductMirror < ApplicationRecord

  def mapping
    {
      name: name,
      price: price,
      quantity: quantity,
      user_id: user_id,
      created_at: created_at,
      updated_at: updated_at
    }
  end

end
