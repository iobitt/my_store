while true
  User.where.not(external_token: nil).each do |user|
    begin
      before_sync_datetime = DateTime.now
      ProductsPuller.new(user).call
      ProductsSyncer.new(before_sync_datetime).call
    rescue => e
      puts "An error of type #{e.class} happened, message is #{e.message}"
    end
  end
  sleep(10)
end
