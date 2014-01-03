require "spec_helper"

describe FileEntityDownload do
  describe ".from_download_id" do
    let(:resource) {FactoryGirl.create :media_resource, :file}
    subject {FileEntity.from_download_id(resource.download_id)}

    it {should be_a FileEntity}
    its(:media_resources) {should include resource}
  end
end
