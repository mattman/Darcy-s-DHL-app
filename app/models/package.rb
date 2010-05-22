class Package < ActiveRecord::Base

  validates_presence_of :carrier, :customer, :description, :serial_number

  has_many :delivered_notices, :order => "tag_sequence DESC"
  has_many :intransit_notices, :order => "tag_sequence DESC"
 
  belongs_to :customer
  belongs_to :carrier

  scope :from_serial_number, lambda { |sn| where(:serial_number => sn) }
  scope :with_notices, includes(:delivered_notices, :intransit_notices)
  scope :by_carrier, lambda { |carrier| where(:carrier_id => carrier.id) }

  validates_uniqueness_of :serial_number

  def deliver!
    fields = (IntransitNotice.column_names - ["id"]).join(", ")
    conditions = "WHERE package_id = #{connection.quote id}"
    transaction do
      connection.execute "INSERT INTO delivered_notices (id, #{fields}) SELECT NULL, #{fields} FROM intransit_notices #{conditions}"
      connection.execute "DELETE FROM intransit_notices #{conditions}"
    end
    intransit_notices.reload
    delivered_notices.reload
    true
  end

  def serial_number=(value)
    write_attribute :serial_number, value
    self.carrier = Carrier.from_serial_number(serial_number) if carrier.blank? || !carrier_id_changed?
  end

  def notices
    (delivered_notices | intransit_notices).sort_by { |n| n.tag_sequence }
  end

  def delivered?
    delivery_notice.present?
  end

  def delivery_notice
    notices.detect { |n| n.delivered? }
  end

  def self.can_create?(user)
    user
  end
  
  def can_view?(user)
    user && (user.admin? || carrier == user)
  end

  def can_edit?(user)
    user && user.admin?
  end

  def can_destroy?(user)
    user && user.admin?
  end

  def self.filtered_scope(params)
    scope = self
    if params[:serial_numbers_file]
      contents = params[:serial_numbers_file].read rescue ""
      ids = contents.split.map { |i| i.strip.to_i }.compact.uniq
      scope = scope.where("serial_number IN (?)", ids)
    elsif params[:serial_number].present?
      scope = scope.where(:serial_number => params[:serial_number])
    end
    scope
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
