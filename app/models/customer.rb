class Customer < ActiveRecord::Base

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
