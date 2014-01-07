require "spec_helper"

describe ShortMessagesController do
  before {
    @user = FactoryGirl.create :user
    @course = FactoryGirl.create :course
  }
  before {
    sign_in @user
    xhr :post, :checkin, :id => @course.id
  }
  it { response.code.should == '200'}

  before {
    @course.sign @user
    
    @user1 = FactoryGirl.create :user
    sign_in @user1
    xhr :post, :checkin, :id => @course.id
  }

  before {
    put :set_tags, :tagable_id => @media_resource.id,
                   :tagable_type => @media_resource.class.to_s,
                   :tags => '苹果，香蕉，橘子 西瓜'
  }

  it {
    response.code.should == '302'
  }

  it {
    expect { 
      delete :destroy, :path => '/a/b/c/foo.txt'
    }.to change{ 
      MediaResource.count
    }.by(0)
  }

  it {
    delete :destroy, :path => '/abc/def/foo.txt'
    response.should redirect_to '/disk/abc/def'
  }

  it {
    delete :destroy, :path => '/d/e/f/g/h/i.j'
    response.should redirect_to '/disk/d/e/f/g/h'
  }

  context 'ajax 删除' do
    it {
      expect { 
        xhr :delete, :destroy, :path => '/foo.txt'
      }.to change{ 
        MediaResource.count
      }.by(-1)
    }

    it {
      xhr :delete, :destroy, :path => '/foo.txt'
      response.body.should == 'deleted.'
    }
  end

  before {
    sign_in @user
    post :create_folder, :path => '/abc/def/hjk'
  }

  describe '#show' do
    before {
      @file_entity = FileEntity.create({
        :attach => File.new(Rails.root.join('spec/data/upload_test_files/test1024.file'))
      })

      sign_in @user

      post :create, :file_entity_id => FileEntity.last.id,
                    :path => '/我的文档/样例.doc'

      get :show, :path => '/我的文档/样例.doc'
    }

    it {
      response.should be_success
    }
  end
end