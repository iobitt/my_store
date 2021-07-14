require 'uri'
require 'net/http'
require 'json'


EXTERNAL_SERVICE_HOST = "http://172.25.0.2"
EXTERNAL_SERVICE_PORT = "3000"


class ProductsPuller

  def initialize(user)
    @user = user
  end

  def call
    res = get_request
    process_data JSON.parse(res.body)
    [true, nil, nil]
  end

  private

  def get_request
    uri = URI.parse("#{EXTERNAL_SERVICE_HOST}:#{EXTERNAL_SERVICE_PORT}/products")
    req = Net::HTTP::Get.new(uri.path)
    req['Accept'] = 'application/json'
    req.set_form_data "external_token" => @user.external_token
    Net::HTTP.new(uri.host, uri.port).start do |http|
      http.request(req)
    end
  end

  def process_data(data)
    data_ids = data["products"].map { |i| i["id"] }
    products = ProductMirror.where :user_id => @user.id
    products_ids = products.map {|i| i.external_id}

    new_products_ids = data_ids - products_ids
    delete_products_ids = products_ids - data_ids

    create_or_update_products(data, products, new_products_ids)
    delete_products(products, delete_products_ids)
  end

  def create_or_update_products(data, products, new_products_ids)
    data["products"].each do |product|
      if new_products_ids.include? product["id"]
        ProductMirror.create!(external_id: product['id'], name: product["name"], price: product["price"],
                              quantity: product["quantity"], user_id: @user.id,
                              external_created_at: product["created_at"], external_updated_at: product["updated_at"])
      else
        mirror_product = products.find{ |a| a.external_id == product["id"]}
        mirror_product.update(name: product["name"], price: product["price"], quantity: product["quantity"],
                              external_updated_at: product["updated_at"])
      end
    end
  end

  def delete_products(products, delete_products_ids)
    delete_products_ids.each do |delete_product_id|
      delete_product = products.find{ |a| a.external_id == delete_product_id}
      delete_product.is_archived = true
      delete_product.save!
    end
  end

end
