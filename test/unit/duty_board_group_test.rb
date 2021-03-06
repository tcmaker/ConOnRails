# == Schema Information
#
# Table name: duty_board_groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  row        :integer
#  column     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class DutyBoardGroupTest < ActiveSupport::TestCase
  setup do
    @dbgt = FactoryGirl.create :valid_duty_board_group
  end

  should have_many :duty_board_slots
  should validate_presence_of :name
  should validate_presence_of :row
  should validate_presence_of :column
  should validate_uniqueness_of :name
  should validate_numericality_of :row
  should validate_numericality_of :column
  should validate_uniqueness_of(:row).scoped_to :column
  should ensure_inclusion_of(:row).in_range DutyBoardGroup.row_range
  should ensure_inclusion_of(:column).in_range DutyBoardGroup.col_range

end
