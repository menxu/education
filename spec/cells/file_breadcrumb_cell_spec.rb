require "spec_helper"

describe FileBreadcrumbCell do
  describe 'display' do
    let(:result) {
      render_cell :file_breadcrumb, :display
    }

    it {
      result.should have_content '所有文件'
    }

    it {
      result.should have_no_content 'Not nil 所有文件'
    }
  end
end