class Carrier < ActiveRecord::Base

  has_many :packages
  has_many :customers, :through => :packages

  validates_presence_of   :name, :identifier, :address, :password
  validates_length_of     :address,    :maximum => 100
  validates_length_of     :name,       :maximum => 50
  validates_length_of     :identifier, :maximum => 4
  validates_uniqueness_of :identifier, :name

  def self.authenticate!(username, password)
    where(:identifier => username.to_s.upcase, :password => password).first
  end

  def self.from_serial_number(serial_number)
    if serial_number =~ /^([A-Z]{1,4})/i
      find_by_identifier $1.to_s.upcase
    else
      nil
    end
  end

  def admin?
    false
  end

  def carrier?
    true
  end

  def identifier=(value)
    if value.blank?
      write_attribute :identifier, nil
    else
      write_attribute :identifier, value.to_s.upcase
    end
  end

  def self.can_create?(user)
    user && user.admin?
  end
  
  def can_view?(user)
    user && (user.admin? || user == self)
  end

  def can_edit?(user)
    user && user.admin?
  end

  def can_destroy?(user)
    user && user.admin?
  end

end


# == Schema Info
#
# Table name: carriers
#
#  id         :integer(4)      not null, primary key
#  address    :string(255)
#  identifier :string(255)
#  name       :string(255)
#  password   :string(255)
#  created_at :datetime
#  updated_at :datetime
