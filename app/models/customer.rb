class Customer < ActiveRecord::Base

  validates_presence_of :address, :first_name, :last_name

  validates_length_of :address,    :maximum => 100
  validates_length_of :last_name,  :maximum => 20
  validates_length_of :first_name, :maximum => 10

  validates_length_of :first_name, :scope => :last_name

  attr_accessible :first_name, :last_name, :address

  scope :with_name, lambda { |f, l| where(:first_name => f, :last_name => l) }

  has_many :packages

  def self.find_or_create_by_full_name(f)
    c = find(:first, :conditions => ["first_name = ? AND last_name = ?", f["first_name"], f["last_name"]])
    if c.nil?
      c = create(:first_name => f["first_name"], :last_name => f["last_name"], :address => f["address"])
    end
    return c
  end

  def self.from_name(first_name, last_name, options = {})
    scope = with_name(first_name, last_name)
    scope.first || create!(options.merge(:first_name => first_name, :last_name => last_name))
  end

end


# == Schema Info
#
# Table name: customers
#
#  id         :integer(4)      not null, primary key
#  address    :string(255)
#  first_name :string(255)
#  last_name  :string(255)
#  created_at :datetime
#  updated_at :datetime
