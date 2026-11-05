require "test_helper"
class AuthenticationTest < ActionDispatch::IntegrationTest
  test "registration login and logout" do
    get new_user_registration_path
    assert_response :success
    assert_difference("User.count") do
      post user_registration_path, params: { user: { email: "new@example.com", password: "Testing123!", password_confirmation: "Testing123!" } }
    end
    assert_response :redirect
    get new_castle_path
    assert_response :success
    delete destroy_user_session_path
    get new_castle_path
    assert_redirected_to new_user_session_path
    post user_session_path, params: { user: { email: "new@example.com", password: "Testing123!" } }
    assert_response :redirect
    get new_castle_path
    assert_response :success
  end

  test "wrong password does not sign user in" do
    post user_session_path, params: { user: { email: users(:one).email, password: "wrong" } }
    assert_response :unprocessable_entity
    get new_castle_path
    assert_redirected_to new_user_session_path
  end

  test "password recovery creates a token and sends instructions" do
    assert_emails 1 do
      post user_password_path, params: { user: { email: users(:one).email } }
    end
    assert_response :redirect
    assert users(:one).reload.reset_password_token.present?
  end
end
