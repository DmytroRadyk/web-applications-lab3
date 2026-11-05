require "test_helper"
class CastleTest < ActiveSupport::TestCase
  test "requires meaningful fields and validates optional year" do
    castle = castles(:one)
    assert castle.valid?
    castle.name = ""
    assert_not castle.valid?
    castle.name = "Test castle"
    castle.built_year = Date.current.year + 1
    assert_not castle.valid?
    castle.built_year = 0
    assert_not castle.valid?
    castle.built_year = 1500
    assert castle.valid?
    castle.user = nil
    assert_not castle.valid?
  end
  test "normalizes Unicode for database independent searching" do
    castle = castles(:one)
    castle.update!(name: "ПАЛАНОК", location: "МУКАЧЕВО")
    assert_equal "паланок мукачево", castle.search_text
  end
end
