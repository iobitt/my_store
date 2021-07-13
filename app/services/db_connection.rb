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
