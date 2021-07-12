require 'uri' # подключение библиотеки для работы с адресами возможно в rails это не нужно
require 'net/http' # подключение библиотеки для отправки HTTP запросов
require 'json'
require 'active_record'
require_relative '../app/models/application_record'
require_relative '../app/models/product_mirror'
require_relative '../app/models/sync_history'
require_relative 'db_connection'


last_sync = SyncHistory.last

if last_sync.nil?
  uri = URI.parse('http://172.25.0.2:3000/products')
else
  uri = URI.parse("http://172.25.0.2:3000/products?updated_after=#{last_sync.created_at.to_time.to_i}")
end

req = Net::HTTP::Get.new(uri.path)
req['Accept'] = 'application/json'
res = Net::HTTP.new(uri.host, uri.port).start do |http|
  http.request(req)
end

data = JSON.parse(res.body)
data["products"].each do |i|
  ProductMirror.create!(id: i['id'], name: i["name"], price: i["price"], quantity: i["quantity"], user_id: i["user_id"], created_at: i["created_at"], updated_at: i["updated_at"])
end

SyncHistory.create
