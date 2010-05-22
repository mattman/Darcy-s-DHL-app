require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
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