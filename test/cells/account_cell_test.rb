require 'test_helper'

class AccountCellTest < Cell::TestCase
  test "show" do
    invoke :show
    assert_select "p"
  end
  

end
