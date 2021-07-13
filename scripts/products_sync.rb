require_relative '../app/services/products_puller'
require_relative '../app/services/products_syncer'
require_relative '../app/models/user'


while true
  User.where.not(external_token: nil).each do |user|
    begin
      ProductsPuller.new(user.external_token).call
      ProductsSyncer.new.call
    rescue
      puts "Ошибка!"
    end
  end
  sleep(10)
end
