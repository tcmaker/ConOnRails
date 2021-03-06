# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  realname        :string(255)
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  LongName = 'a' * 33
  LongRealName = 'a' * 65
  ShortPassword = 'a' * 4
  LongPassword = 'a' * 33
  BadName = "a&%T@%{ \003} elknart" # Should fail for space, printable specials, and control-C
  BadPassword = "a&%T@%{ \003} elknart" # Should fail for control-C
  GoodPassword = "zogity123*%^! 42"
  
  def failure_is_good( input_attributes )
    user = nil
    if input_attributes == {}
      user = User.new
    else
      user = User.new( input_attributes )
    end

    assert user.invalid?
  end
  
  setup do
    @input_attributes = {
        name: "uncle-mikey",
        realname: "Mi Key",
        password: GoodPassword,
        password_confirmation: GoodPassword,
    }
  end
  
  test "user attributes must not be empty" do
    empty = {}
    failure_is_good empty
  end
  
  test "create a new user" do
    assert User.new(@input_attributes).valid?
  end
    
  test "user's name should be unique" do
    user1 = User.create!(@input_attributes)
    failure_is_good @input_attributes
  end
  
  test "username should not be longer than 32 characters" do
    @input_attributes[:name] = LongName
    failure_is_good @input_attributes
  end
  
  test "realname should not be longer than 64 characters" do
    @input_attributes[:realname] = LongRealName
    failure_is_good @input_attributes
  end
  
  test "username should only contain alphanumerics and underscores" do
    @input_attributes[:name] = BadName
    failure_is_good @input_attributes
  end
  
  test "passwords have to match" do
    @input_attributes[:password_confirmation] = ShortPassword
    failure_is_good @input_attributes
  end
  
  test "passwords have to be at least 6 characters" do
    @input_attributes[:password] = ShortPassword
    @input_attributes[:password_confirmation] = ShortPassword
    failure_is_good @input_attributes
  end
  
  test "passwords shouldn't be more than 32 characters" do
    @input_attributes[:password] = LongPassword
    @input_attributes[:password_confirmation] = LongPassword
    failure_is_good @input_attributes
  end
  
  test "passwords should only contain alphanumerics underscores and some printable specials" do
    @input_attributes[:password] = BadPassword
    @input_attributes[:password_confirmation] = BadPassword
    failure_is_good @input_attributes
  end
  
  test "can authenticate user" do
    user = User.create!(@input_attributes)
    assert user.authenticate GoodPassword
  end
  
  test "wrong passwords don't authenticate" do
    user = User.create!(@input_attributes)
    assert false == user.authenticate( ShortPassword )
  end
  
end
