class Package < ActiveRecord::Base

  has_many :delivered_notices, :order => "tag_sequence DESC"
  has_many :intransit_notices, :order => "tag_sequence DESC"
  
  belongs_to :customer
  belongs_to :carrier

  scope :from_serial_number, lambda { |sn| where(:serial_number => sn) }
  scope :with_notices, includes(:delivered_notices, :intransit_notices)

end
