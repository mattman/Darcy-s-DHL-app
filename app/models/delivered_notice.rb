class DeliveredNotice < ActiveRecord::Base

  validates_presence_of  :tag_sequence, :lat, :lng, :status
  validates_inclusion_of :status, :in => %w(T D)

  scope :ordered, 'tag_sequence ASC'

  def in_transit?
    status == 'T'
  end

  def at_final_destination?
    status == 'D'
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
