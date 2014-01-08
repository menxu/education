require "spec_helper"

describe User do
  describe "import file" do
    it "should raise format error" do
      file = File.new 'spec/data/user_import_test_files/incorrect_excel.aaa'

      expect {
        User.import_excel_admin file
      }.to raise_error(Exception)
    end
  end

  context "import admin excel files" do
    describe "import xls format" do
      before {
        file = File.new 'spec/data/user_import_test_files/user.xls'

        # expect{
        User.import_excel_admin file
        # }.to change{User.count}.by(3)

        @user = User.find_by_name('hello2')
      }

      it {
        @user.login.should == 'aaa2'
      }

      it {
        @user.gender.should == '女'
      }

      it {
        @user.role?(:admin).should == true
      }
    end
  end
end