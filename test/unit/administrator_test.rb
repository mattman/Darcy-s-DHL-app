require 'test_helper'

class AdministratorTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end


# == Schema Info
#
# Table name: administrators
#
#  id         :integer(4)      not null, primary key
#  password   :string(255)
#  username   :string(255)
#  created_at :datetime
#  updated_at :datetime