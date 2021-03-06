# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  department :string(255)
#  cell_phone :string(255)
#  hotel      :string(255)
#  hotel_room :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  can_text   :boolean          default(FALSE)
#  position   :string(255)
#

class Contact < ActiveRecord::Base
  attr_accessible :name, :cell_phone, :department, :position, :hotel, :hotel_room, :can_text

  audited
  validates_format_of :cell_phone,
                      message: "must be a valid telephone number.",
                      with:    /\A[\(\)0-9\- \+\.]{10,20}\z/
  validates :name, presence: true, allow_blank: false
end
