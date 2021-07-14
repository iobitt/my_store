while true
  User.where.not(external_token: nil).each do |user|
    begin
      ProductsPuller.new(user).call
      ProductsSyncer.new.call
    rescue
      puts "Ошибка!"
    end
  end
  sleep(10)
end
