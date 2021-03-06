# == Schema Information
#
# Table name: duty_board_assignments
#
#  id                 :integer          not null, primary key
#  duty_board_slot_id :integer
#  notes              :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  name               :string(255)
#  string             :string(255)
#

class DutyBoardAssignment < ActiveRecord::Base
  attr_accessible :name, :duty_board_slot_id, :notes
  audited

  belongs_to :duty_board_slot
  validates_presence_of :name, message: "You must have a name"
  validates_presence_of :duty_board_slot, message: "You must associate with a duty board slot"
  validates_length_of :notes, maximum: 255
end
