class Administrator < ActiveRecord::Base

  validates_presence_of   :username, :password
  validates_uniqueness_of :username

  def admin?
    true
  end

  def carrier?
    false
  end

  def self.authenticate!(username, password)
    where(:username => username, :password => password).first 
  end

end


# == Schema Info
#
# Table name: administrators
#
#  id         :integer(4)      not null, primary key
#  password   :string(255)
#  username   :string(255)
#  created_at :datetime
#  updated_at :datetime
