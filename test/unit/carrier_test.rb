require 'test_helper'

class CarrierTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
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