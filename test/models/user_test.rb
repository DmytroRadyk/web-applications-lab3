require "test_helper"
class UserTest < ActiveSupport::TestCase
  test "password is hashed and email is unique" do
    user = users(:one)
    assert user.valid_password?("Testing123!")
    assert_not_equal "Testing123!", user.encrypted_password
    assert_not User.new(email: user.email, password: "Testing123!").valid?
  end
end
