require 'test_helper'

class PackageTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
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