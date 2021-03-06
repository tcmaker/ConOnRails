# == Schema Information
#
# Table name: radios
#
#  id             :integer          not null, primary key
#  number         :string(255)
#  notes          :string(255)
#  radio_group_id :integer
#  image_filename :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  state          :string(255)      default("in")
#

require 'test_helper'

class RadioTest < ActiveSupport::TestCase
  setup do
    @blue = FactoryGirl.create :blue_man_group
    @red  = FactoryGirl.create :red_handed
    @blue_radios = FactoryGirl.build_list( :one_of_many_blue_radios, 10, radio_group: @blue )
    @blue_radios[0].state = "out"
    @blue_radios[6].state = "out"
  end

  test "can create several radios in one group" do
    assert_difference 'Radio.count', 10 do
      @blue_radios.each { |r| r.save! }
    end
  end

  test "can break out assigned and unassigned" do
    @blue_radios.each { |r| r.save! }
    assert_equal 2, Radio.assigned.count
    assert_equal 8, Radio.unassigned.count
  end

end
