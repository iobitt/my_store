require 'uri' # подключение библиотеки для работы с адресами возможно в rails это не нужно
require 'net/http' # подключение библиотеки для отправки HTTP запросов
require 'json'
require 'active_record'
require_relative '../models/application_record'
require_relative '../models/product_mirror'
require_relative '../models/sync_history'
require_relative 'db_connection'


EXTERNAL_TOKEN = "UtdC6Hf0G1qtCvzAdlEaS5Q-KIZvDsNueniztVSZy98"
EXTERNAL_SERVICE_HOST = "http://172.25.0.2"
EXTERNAL_SERVICE_PORT = "3000"


class ProductsPuller

  def call
    uri = URI.parse("#{EXTERNAL_SERVICE_HOST}:#{EXTERNAL_SERVICE_PORT}/products")
    req = Net::HTTP::Get.new(uri.path)
    req['Accept'] = 'application/json'
    req.set_form_data "external_token" => EXTERNAL_TOKEN
    res = Net::HTTP.new(uri.host, uri.port).start do |http|
      http.request(req)
    end

    data = JSON.parse(res.body)
    data_ids = data["products"].map { |i| i["id"] }

    products = ProductMirror.all
    products_ids = products.map {|i| i.external_id}

    new_products = data_ids - products_ids
    delete_products = products_ids - data_ids

    data['products'].each do |i|
      if new_products.include? i["id"]
        ProductMirror.create!(external_id: i['id'], name: i["name"], price: i["price"], quantity: i["quantity"],
                              user_id: i["user_id"], external_created_at: i["created_at"],
                              external_updated_at: i["updated_at"])
      else
        pi = products.find{ |a| a.external_id == i["id"]}
        pi.update(name: i["name"], price: i["price"], quantity: i["quantity"], user_id: i["user_id"], external_updated_at: i["updated_at"])
      end
    end

    delete_products.each do |i|
      pi = products.find{ |a| a.external_id == i}
      pi.is_archived = true
      pi.save
    end

    [true, data, nil]
  end

end
