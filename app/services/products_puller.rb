require 'uri' # подключение библиотеки для работы с адресами возможно в rails это не нужно
require 'net/http' # подключение библиотеки для отправки HTTP запросов
require 'json'
require 'active_record'
require_relative '../models/application_record'
require_relative '../models/product_mirror'
require_relative '../models/sync_history'
require_relative 'db_connection'


EXTERNAL_SERVICE_HOST = "http://172.25.0.2"
EXTERNAL_SERVICE_PORT = "3000"


class ProductsPuller

  def initialize(token)
    @token = token
  end

  def call
    uri = URI.parse("#{EXTERNAL_SERVICE_HOST}:#{EXTERNAL_SERVICE_PORT}/products")
    req = Net::HTTP::Get.new(uri.path)
    req['Accept'] = 'application/json'
    req.set_form_data "external_token" => @token
    res = Net::HTTP.new(uri.host, uri.port).start do |http|
      http.request(req)
    end

    data = JSON.parse(res.body)
    data_ids = data["products"].map { |i| i["id"] }

    products = ProductMirror.all
    products_ids = products.map {|i| i.external_id}

    new_products_ids = data_ids - products_ids
    delete_products_ids = products_ids - data_ids

    data['products'].each do |product|
      if new_products_ids.include? product["id"]
        ProductMirror.create!(external_id: product['id'], name: product["name"], price: product["price"],
                              quantity: product["quantity"], user_id: product["user_id"],
                              external_created_at: product["created_at"], external_updated_at: product["updated_at"])
      else
        mirror_product = products.find{ |a| a.external_id == product["id"]}
        mirror_product.update(name: product["name"], price: product["price"], quantity: product["quantity"],
                              user_id: product["user_id"], external_updated_at: product["updated_at"])
      end
    end

    delete_products_ids.each do |delete_product_id|
      delete_product = products.find{ |a| a.external_id == delete_product_id}
      delete_product.is_archived = true
      delete_product.save
    end

    [true, data, nil]
  end

end
