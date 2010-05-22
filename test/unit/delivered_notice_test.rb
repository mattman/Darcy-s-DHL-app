require 'test_helper'

class DeliveredNoticeTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end


# == Schema Info
#
# Table name: delivered_notices
#
#  id           :integer(4)      not null, primary key
#  package_id   :integer(4)
#  comment      :string(255)
#  lat          :decimal(15, 10)
#  lng          :decimal(15, 10)
#  status       :string(255)
#  tag_sequence :integer(4)
#  created_at   :datetime
#  recorded_at  :datetime
#  updated_at   :datetime