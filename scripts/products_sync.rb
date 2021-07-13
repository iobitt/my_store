require_relative '../app/services/products_puller'
require_relative '../app/services/products_sinker'

while true
  begin
  ProductsPuller.new.call
  ProductsSinker.new.call
  rescue
    puts "Ошибка!"
  end
  sleep(10)
end
