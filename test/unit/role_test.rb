require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  fixtures :roles
  
  LongName = 'a' * 33
  BadName = "a&%T@%{ \003} elknart" # Should fail for printable specials, and control-C
  
  setup do
    @empty_role = Role.new
  end
  
  test "role flags should default to false" do
    assert !@empty_role.write_entries?
    assert !@empty_role.read_hidden_entries?
    assert !@empty_role.add_lost_and_found?
    assert !@empty_role.modify_lost_and_found?
    assert !@empty_role.admin_radios?
    assert !@empty_role.admin_users?
    assert !@empty_role.admin_schedule?
    assert !@empty_role.assign_shifts?
    assert !@empty_role.assign_duty_board_slots?
    assert !@empty_role.admin_duty_board?
  end
    
  test "roles must have names" do
    role = Role.create
    assert role.invalid?
  end
  
  test "role names should be unique" do
    role1 = Role.create name: "Fish"
    role2 = Role.create name: "Fish"
    
    assert role2.invalid?
  end
  
  test "role names should be 32 characters or less" do
    role = Role.create name: LongName
    assert role.invalid?
  end
  
  test "role names should not contain printable-specials or control characters" do
    role = Role.create name: BadName
    assert role.invalid?
  end
  # test "the truth" do
  #   assert true
  # end
end