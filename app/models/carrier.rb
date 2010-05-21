class Carrier < ActiveRecord::Base

  has_many :packages
  has_many :customers, :through => :packages

end