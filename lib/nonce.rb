class Nonce < ActiveRecord::Base
  attr_accessible :server_url, :timestamp, :salt
  self.table_name =  'open_id_nonces'
end
