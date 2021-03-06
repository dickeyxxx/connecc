class AddAdminUsers < ActiveRecord::Migration
  def self.up
    user = User.new(:email => "jeff@conne.cc", :password => "password")
    user.first_name = "Jeff"
    user.last_name = "Dickey"
    user.admin = true
    user.save
    user = User.new(:email => "wyatt@conne.cc", :password => "password")
    user.first_name = "Wyatt"
    user.last_name = "Allen"
    user.admin = true
    user.save
  end

  def self.down
    User.find_by_email("jeff@conne.cc").destroy
    User.find_by_email("wyatt@conne.cc").destroy
  end
end
