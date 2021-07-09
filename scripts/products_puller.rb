require 'uri' # подключение библиотеки для работы с адресами возможно в rails это не нужно
require 'net/http' # подключение библиотеки для отправки HTTP запросов
require 'json'
# require_relative '../spec/rails_helper'
require 'active_record'
require_relative '../app/models/application_record'
require_relative '../app/models/product_mirror'


uri = URI.parse('http://172.25.0.2:3000/products')
req = Net::HTTP::Get.new(uri.path)
req['Accept'] = 'application/json'
res = Net::HTTP.new(uri.host, uri.port).start do |http|
  http.request(req)
end

data = JSON.parse(res.body)
puts data

class PP_OTA_INFO < ActiveRecord::Base
  self.table_name = "pp_ota_info"
end

ActiveRecord::Base.establish_connection(
  adapter:  "postgresql",
  host:     "db",
  username: "postgres",
  password: "password",
  database: "myapp_development"
)

data["products"].each do |i|
  ProductMirror.create!(name: i["name"], price: i["price"], quantity: i["quantity"], user_id: i["user_id"], created_at: i["created_at"], updated_at: i["updated_at"])
end
