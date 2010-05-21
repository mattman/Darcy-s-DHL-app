class Customer < ActiveRecord::Base

  has_many :packages
  
  def self.find_or_create_by_full_name(f)
    c = find(:first, :conditions => ["first_name = ? AND last_name = ?", f["first_name"], f["last_name"]])
    if c.nil?
      c = create(:first_name => f["first_name"], :last_name => f["last_name"], :address => f["address"])
    end
    return c
  end

end