require "test_helper"
class CastlesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @castle = castles(:one)
    @attributes = { name: "Новий замок", region: "Львівська", location: "Олесько", description: "Історія замку", built_year: 1500 }
  end

  test "catalog and detail are public" do
    get castles_url
    assert_response :success
    assert_select "h2", text: /Колекція замків/
    get castle_url(@castle)
    assert_response :success
    assert_select "h1", @castle.name
  end

  test "search handles Ukrainian case and region" do
    get castles_url, params: { q: "ПАЛАНОК", region: "Закарпатська" }
    assert_response :success
    assert_select "article", count: 1
    assert_select "article h2", @castle.name
    get castles_url, params: { q: "absent" }
    assert_select "article", count: 0
  end

  test "guest cannot access any mutation" do
    get new_castle_url
    assert_redirected_to new_user_session_path
    get edit_castle_url(@castle)
    assert_redirected_to new_user_session_path
    assert_no_difference("Castle.count") { post castles_url, params: { castle: @attributes } }
    assert_redirected_to new_user_session_path
    patch castle_url(@castle), params: { castle: { name: "Hacked" } }
    assert_redirected_to new_user_session_path
    assert_no_difference("Castle.count") { delete castle_url(@castle) }
    assert_redirected_to new_user_session_path
  end

  test "signed in author can create edit update and delete own record" do
    sign_in users(:one)
    get new_castle_url
    assert_response :success
    assert_difference("Castle.count") do
      post castles_url, params: { castle: @attributes.merge(user_id: users(:two).id) }
    end
    castle = Castle.order(:id).last
    assert_equal users(:one), castle.user
    assert_redirected_to castle_url(castle)
    get edit_castle_url(castle)
    assert_response :success
    patch castle_url(castle), params: { castle: { name: "Оновлено", user_id: users(:two).id } }
    assert_redirected_to castle_url(castle)
    assert_equal "Оновлено", castle.reload.name
    assert_equal users(:one), castle.user
    assert_difference("Castle.count", -1) { delete castle_url(castle) }
    assert_redirected_to castles_url
  end

  test "another account cannot edit update or delete a record" do
    sign_in users(:two)
    get edit_castle_url(@castle)
    assert_response :forbidden
    patch castle_url(@castle), params: { castle: { name: "Hacked" } }
    assert_response :forbidden
    assert_not_equal "Hacked", @castle.reload.name
    assert_no_difference("Castle.count") { delete castle_url(@castle) }
    assert_response :forbidden
  end

  test "invalid create and update show errors without losing data" do
    sign_in users(:one)
    assert_no_difference("Castle.count") { post castles_url, params: { castle: @attributes.merge(name: "") } }
    assert_response :unprocessable_entity
    assert_select "[role=alert]"
    patch castle_url(@castle), params: { castle: { built_year: Date.current.year + 1 } }
    assert_response :unprocessable_entity
    assert_nil @castle.reload.built_year
  end
end
