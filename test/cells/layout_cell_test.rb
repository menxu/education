require 'test_helper'

class LayoutCellTest < Cell::TestCase
  test "login" do
    invoke :login
    assert_select "p"
  end
  

end
