# == Schema Information
#
# Table name: event_flag_histories
#
#  id           :integer          not null, primary key
#  event_id     :integer
#  is_active    :boolean          default(FALSE)
#  comment      :boolean          default(FALSE)
#  flagged      :boolean          default(FALSE)
#  post_con     :boolean          default(FALSE)
#  quote        :boolean          default(FALSE)
#  sticky       :boolean          default(FALSE)
#  emergency    :boolean          default(FALSE)
#  medical      :boolean          default(FALSE)
#  hidden       :boolean          default(FALSE)
#  secure       :boolean          default(FALSE)
#  consuite     :boolean          default(FALSE)
#  hotel        :boolean          default(FALSE)
#  parties      :boolean          default(FALSE)
#  volunteers   :boolean          default(FALSE)
#  dealers      :boolean          default(FALSE)
#  dock         :boolean          default(FALSE)
#  merchandise  :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#  orig_time    :datetime
#  rolename     :string(255)
#  merged       :boolean
#  nerf_herders :boolean          default(FALSE)
#

require 'test_helper'

class EventFlagHistoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
