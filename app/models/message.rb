class Message < ActiveRecord::Base
  attr_accessible :is_active, :for, :message, :phone_number, :room_number, :hotel, :can_text, :position
  audited
  paginates_per 10

  belongs_to :user
  validates_presence_of :for, :message, :user
  validates_format_of :phone_number,  allow_blank: true, allow_nil: true,
                      message: "must be a valid telephone number.",
                      with:    /^[\(\)0-9\- \+\.]{10,20}$/

 def self.num_active
    return Message.count(conditions: "is_active == 't'")
  end

end
