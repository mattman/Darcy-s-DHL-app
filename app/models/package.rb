class Package < ActiveRecord::Base

  validates_presence_of :carrier, :customer, :description, :serial_number

  has_many :delivered_notices, :order => "tag_sequence DESC"
  has_many :intransit_notices, :order => "tag_sequence DESC"
 
  belongs_to :customer
  belongs_to :carrier

  scope :from_serial_number, lambda { |sn| where(:serial_number => sn) }
  scope :with_notices, includes(:delivered_notices, :intransit_notices)
  scope :by_carrier, lambda { |carrier| where(:carrier_id => carrier.id) }


  def archive_notices!
    intransit_notices.each { |n| n.make_delivered! }
  end

  def serial_number=(value)
    write_attribute :serial_number, value
    if serial_number_changed?
      self.carrier = Carrier.from_serial_number(serial_number)
    end
  end

end


# == Schema Info
#
# Table name: packages
#
#  id            :integer(4)      not null, primary key
#  carrier_id    :integer(4)
#  customer_id   :integer(4)
#  description   :string(255)
#  serial_number :string(255)
#  created_at    :datetime
#  updated_at    :datetime
