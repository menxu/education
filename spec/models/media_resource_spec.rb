require 'spec_helper'

describe MediaResource do
  describe '私有方法' do
    context '能够切分传入的路径' do
      it {MediaResource.send(:split_path,'/muisc/zhou/123').should == ['muisc','zhou','123']}
      it {MediaResource.send(:split_path,'/muisc/zhou').should == ['muisc','zhou']}
      it {MediaResource.send(:split_path,'/muisc').should == ['muisc']}
      it {MediaResource.send(:split_path,'/双节棍').should == ['双节棍']}
    end

    context '对于传入的无效路径会抛出异常' do
      it {
        expect {
          MediaResource.send(:split_path,'/')
        }.to raise_error(MediaResource::InvalidPathError)
      }

      it {
        expect {
          MediaResource.send(:split_path,'')
        }.to raise_error(MediaResource::InvalidPathError)
      }

      it {
        expect {
          MediaResource.send(:split_path,nil)
        }.to raise_error(MediaResource::InvalidPathError)
      }

      it {
        expect {
          MediaResource.send(:split_path,'muisc/zhou')
        }.to raise_error(MediaResource::InvalidPathError)
      }

      it {
        expect {
          MediaResource.send(:split_path,'//muisc/zhou')
        }.to raise_error(MediaResource::InvalidPathError)
      }

      it {
        expect {
          MediaResource.send(:split_path,'/muisc//zhou')
        }.to raise_error(MediaResource::InvalidPathError)
      }

      it {
        expect {
          MediaResource.send(:split_path,'/muisc\zhou')
        }.to raise_error(MediaResource::InvalidPathError)
      }
    end
  end

  describe '资源操作' do
    before do
      @xiao_wang  = FactoryGirl.create :user, :manager, :email => 'manager@163.com', :name => '小王'
      @xiao_mao   = FactoryGirl.create :user, :student, :email => 'student@163.com', :name => '小猫'
      MediaResource.create(
        :name => '天下',
        :is_dir => true,
        :creator => @xiao_wang,
        :media_resources => [
          MediaResource.create(
            :name => '张杰',
            :is_dir => true,
            :creator => @xiao_wang,
            :media_resources => [
              MediaResource.new(:name => '谢娜.jpg.gif', :is_dir => false, :creator => @xiao_wang),
              MediaResource.new(:name => '小刚.jpg', :is_dir => false, :creator => @xiao_wang)
            ]
          )
        ]
      )

      tmpfile = Tempfile.new('taiji')
      tmpfile.write('张三丰')

      MediaResource.create(
        :name   => '天意',
        :is_dir => true,
        :creator => @xiao_wang,
        :media_resources => [
          MediaResource.new(
            :name => '刘德华.jpg', 
            :is_dir => false,
            :creator => @xiao_wang,
            :file_entity => FileEntity.new(:attach => tmpfile)
          ),
          MediaResource.new(
            :name => '李连杰.jpg', 
            :is_dir => false,
            :creator => @xiao_wang,
            :file_entity => FileEntity.new(:attach => tmpfile)
          ),
          MediaResource.new(:name => '无间道.jpg', :is_dir => false, :creator => @xiao_wang)
        ]
      )

      MediaResource.create(:name => '何炅.png', :is_dir => false, :creator => @xiao_wang)
      MediaResource.create(:name => '霹雳火.jpg', :is_dir => false, :creator => @xiao_wang)
      MediaResource.create(:name => '向南飞.jpg', :is_dir => false, :creator => @xiao_wang)
      MediaResource.create(:name => '笑脸元宝.jpg', :is_dir => false, :creator => @xiao_wang)

      MediaResource.create(:name => '天蚕神功.txt', :is_dir => false, :is_removed => true, :creator => @xiao_wang)
      MediaResource.create(:name => '降龙十八掌.txt', :is_dir => false, :is_removed => true, :creator => @xiao_wang)
      MediaResource.create(:name => '小无相功', :is_dir => true, :is_removed => true, :creator => @xiao_wang)
    end

    it {
      MediaResource.find_by_name('刘德华.jpg').file_entity.should_not be_blank
    }
    describe '获取资源' do
      it '传入的路径没有资源时，返回空' do
        MediaResource.get(@xiao_wang, '/foo/bar/123').should == nil
        MediaResource.get(@xiao_wang, '/foo/bar').should == nil
        MediaResource.get(@xiao_wang, '/foo').should == nil
        MediaResource.get(@xiao_wang, '/中国国宝大熊猫').should == nil
        MediaResource.get(@xiao_wang, '/北极熊/HTC').should == nil
      end

      it '传入的路径有资源时，返回指定资源' do
        MediaResource.get(@xiao_wang, '/天下').is_dir.should == true
        MediaResource.get(@xiao_wang, '/天下/张杰/谢娜.jpg.gif').is_dir.should == false
        MediaResource.get(@xiao_wang, '/何炅.png').is_dir.should == false
      end

      it '传入无效路径时，返回空' do
        MediaResource.get(@xiao_wang, '/').should == nil
        MediaResource.get(@xiao_wang, '/fo\o/bar').should == nil
        MediaResource.get(@xiao_wang, '/f//f').should == nil
      end

      it '传入的路径对应已经被删除的资源时，返回空' do
        MediaResource.get(@xiao_wang, '/天蚕神功.txt').should == nil
        MediaResource.get(@xiao_wang, '/小无相功').should == nil

        MediaResource.get(@xiao_wang, '/天下/张杰/谢娜.jpg.gif').should_not == nil
        MediaResource.get(@xiao_wang, '/天下/张杰/谢娜.jpg.gif').remove
        MediaResource.get(@xiao_wang, '/天下/张杰/谢娜.jpg.gif').should == nil

        MediaResource.get(@xiao_wang, '/天意').should_not == nil
        MediaResource.get(@xiao_wang, '/天意/刘德华.jpg').should_not == nil
        MediaResource.get(@xiao_wang, '/天意').remove
        MediaResource.get(@xiao_wang, '/天意').should == nil
        MediaResource.get(@xiao_wang, '/天意/无间道.jpg').should == nil
      end
    end

    describe '创建资源' do
      describe '创建文件资源' do

        file = Tempfile.new('test')
        it '创建资源后应该可以拿到' do
          MediaResource.get(@xiao_wang, '/酸梅汤.html').should == nil
          MediaResource.get(@xiao_wang, '/红枣/绿豆.png').should == nil

          MediaResource.put(@xiao_wang, '/酸梅汤.html', file)
          MediaResource.get(@xiao_wang, '/酸梅汤.html').should_not == nil

          MediaResource.put(@xiao_wang, '/红枣/绿豆.png', file)
          MediaResource.get(@xiao_wang, '/红枣').is_dir.should == true
          MediaResource.get(@xiao_wang, '/红枣/绿豆.png').is_dir.should == false
        end

        it '传入无效路径后，创建资源抛出异常' do
          expect {
            MediaResource.put(@xiao_wang, nil, file)
          }.to raise_error(MediaResource::InvalidPathError)

          expect {
            MediaResource.put(@xiao_wang, 'haha', file)
          }.to raise_error(MediaResource::InvalidPathError)

          expect {
            MediaResource.put(@xiao_wang, '/', file)
          }.to raise_error(MediaResource::InvalidPathError)

          expect {
            MediaResource.put(@xiao_wang, '/fo\o', file)
          }.to raise_error(MediaResource::InvalidPathError)
        end

        it '先删除一个资源，再针对同样的路径创建资源，资源可以取到，且资源总数不变' do
          MediaResource.get(@xiao_wang, '/霹雳火.jpg').should_not == nil

          count = MediaResource.count
          removed_count = MediaResource.removed.count

          MediaResource.get(@xiao_wang, '/霹雳火.jpg').remove
          MediaResource.count.should == count - 1
          MediaResource.removed.count.should == removed_count + 1

          MediaResource.put(@xiao_wang, '/霹雳火.jpg', file)
          MediaResource.count.should == count
          MediaResource.removed.count.should == removed_count
        end

        it '可以以文件覆盖文件夹，覆盖时，文件夹下所有资源被删除' do
          MediaResource.get(@xiao_wang, '/天意').is_dir?.should == true
          MediaResource.get(@xiao_wang, '/天意/李连杰.jpg').is_file?.should == true
          MediaResource.get(@xiao_wang, '/天意/无间道.jpg').is_file?.should == true

          MediaResource.replace(@xiao_wang, '/天意', file)
          MediaResource.get(@xiao_wang, '/天意').is_file?.should == true
          MediaResource.get(@xiao_wang, '/天意/李连杰.jpg').should == nil
          MediaResource.get(@xiao_wang, '/天意/无间道.jpg').should == nil
        end

        it '当创建深层文件资源时，父文件夹包含已被删除的文件夹资源，则创建后应是非删除状态' do
          MediaResource.get(@xiao_wang, '/小无相功').should == nil
          MediaResource.removed.root_res.find_by_name('小无相功').should_not == nil

          MediaResource.get(@xiao_wang, '/小无相功/凉茶').should == nil

          MediaResource.put(@xiao_wang, '/小无相功/一阳指/六脉神剑.zip', file)

          MediaResource.get(@xiao_wang, '/小无相功').is_dir?.should == true
          MediaResource.get(@xiao_wang, '/小无相功/一阳指').is_dir?.should == true
          MediaResource.get(@xiao_wang, '/小无相功/一阳指/六脉神剑.zip').is_file?.should == true
        end

        it '当创建深层文件资源时，父文件夹是已存在的文件，则覆盖已存在的文件为文件夹' do
          MediaResource.get(@xiao_wang, '/向南飞.jpg').is_file? == true

          MediaResource.put(@xiao_wang, '/向南飞.jpg/花火/群星.ppt', file)

          MediaResource.get(@xiao_wang, '/向南飞.jpg').is_dir? == true
          MediaResource.get(@xiao_wang, '/向南飞.jpg').is_file? == false

          MediaResource.get(@xiao_wang, '/向南飞.jpg/花火').is_dir? == true
          MediaResource.get(@xiao_wang, '/向南飞.jpg/花火/群星.ppt').is_file? == true
        end

        it '当创建深层文件资源时，父文件夹是已删除的文件，则创建后应该是未删除的文件夹' do
          MediaResource.get(@xiao_wang, '/天蚕神功.txt').should == nil
          MediaResource.removed.root_res.find_by_name('天蚕神功.txt').is_file? == true

          count = MediaResource.count
          removed_count = MediaResource.removed.count

          MediaResource.put(@xiao_wang, '/天蚕神功.txt/星之所在.mp3', file)
          MediaResource.get(@xiao_wang, '/天蚕神功.txt').should_not == nil
          MediaResource.get(@xiao_wang, '/天蚕神功.txt').is_dir?.should == true
          MediaResource.get(@xiao_wang, '/天蚕神功.txt/星之所在.mp3').is_file?.should == true

          MediaResource.count.should == count + 2        
          MediaResource.removed.count.should == removed_count - 1
        end

        it '创建资源时文件参数不能传 nil 否则抛异常' do
          expect {
            MediaResource.put(@xiao_wang, '/hhaa/wwoo/ffoo', nil)
          }.to raise_error(MediaResource::FileEmptyError)
        end
      end

      describe '创建文件夹资源' do
        it '当指定位置已经存在任何资源时，抛出异常' do
          MediaResource.get(@xiao_wang, '/霹雳火.jpg').should be_is_file
          MediaResource.get(@xiao_wang, '/天下').should be_is_dir

          expect {
            MediaResource.create_folder(@xiao_wang, '/霹雳火.jpg')
          }.to raise_error(MediaResource::RepeatedlyCreateFolderError)

          expect {
            MediaResource.create_folder(@xiao_wang, '/天下')
          }.to raise_error(MediaResource::RepeatedlyCreateFolderError)
        end

        it '当创建一个多级文件夹时，父文件夹被连带创建' do
          MediaResource.get(@xiao_wang, '/当归').should == nil
          MediaResource.get(@xiao_wang, '/当归/鹿茸').should == nil

          MediaResource.create_folder(@xiao_wang, '/当归/鹿茸/人参')

          MediaResource.get(@xiao_wang, '/当归').should_not == nil
          MediaResource.get(@xiao_wang, '/当归/鹿茸').should_not == nil
          MediaResource.get(@xiao_wang, '/当归/鹿茸/人参').should_not == nil
        end

        it '当创建一个多级文件夹时，父文件夹是已存在的文件，则将其覆盖' do
          MediaResource.get(@xiao_wang, '/天意/李连杰.jpg').is_file?.should == true

          MediaResource.create_folder(@xiao_wang, '/天意/李连杰.jpg/滚滚控')
          MediaResource.get(@xiao_wang, '/天意').is_dir?.should == true
          MediaResource.get(@xiao_wang, '/天意/李连杰.jpg').is_dir?.should == true
          MediaResource.get(@xiao_wang, '/天意/李连杰.jpg/滚滚控').is_dir?.should == true
        end

        it '当创建文件夹时，指定路径是一个已被删除的资源，创建文件夹后，资源总数不变' do
          MediaResource.get(@xiao_wang, '/小无相功').should == nil
          MediaResource.removed.root_res.find_by_name('小无相功').should_not == nil

          count = MediaResource.count
          removed_count = MediaResource.removed.count

          MediaResource.create_folder(@xiao_wang, '/小无相功').should == MediaResource.get(@xiao_wang, '/小无相功')
          MediaResource.get(@xiao_wang, '/小无相功').should_not == nil
          MediaResource.removed.root_res.find_by_name('小无相功').should == nil
          MediaResource.count.should == count + 1
          MediaResource.removed.count.should == removed_count - 1
        end

        it '当传入无效路径时，不创建任何资源，也不抛异常' do
          count = MediaResource.count
          removed_count = MediaResource.removed.count

          MediaResource.create_folder(@xiao_wang, '/小无\相功').should == nil
          MediaResource.create_folder(@xiao_wang, nil).should == nil
          MediaResource.create_folder(@xiao_wang, '/').should == nil
          MediaResource.create_folder(@xiao_wang, 'nl').should == nil

          MediaResource.count.should == count
          MediaResource.removed.count.should == removed_count
        end
      end
    end

    describe '读取信息' do
      it '能够从资源读取路径信息' do
        MediaResource.find_by_name('小刚.jpg').path.should == '/天下/张杰/小刚.jpg'
        MediaResource.find_by_name('谢娜.jpg.gif').path.should == '/天下/张杰/谢娜.jpg.gif'
      end

      it '能够读取文件和文件夹资源的META信息' do
        MediaResource.get(@xiao_wang, '/天意').metadata(:list => false).should == {
          :bytes => 0,
          :is_dir => true,
          :path => '/天意',
          :contents => []
        }

        MediaResource.get(@xiao_wang, '/天意').metadata(:list => true).should == {
          :bytes => 0,
          :path => "/天意",
          :is_dir => true,
          :contents => [
            {
              :bytes => 9,
              :path => '/天意/刘德华.jpg',
              :is_dir => false,
              :mime_type => "application/octet-stream"
            },
            {
              :bytes => 0,
              :path => '/天意/无间道.jpg',
              :is_dir => false,
              :mime_type => 'application/octet-stream'
            },
            {
              :bytes => 9,
              :path => '/天意/李连杰.jpg',
              :is_dir => false,
              :mime_type => "application/octet-stream"
            }
          ]
        }

        MediaResource.get(@xiao_wang, '/天意/刘德华.jpg').metadata.should == {
          :bytes => 9,
          :is_dir => false,
          :path => '/天意/刘德华.jpg',
          :mime_type => "application/octet-stream"
        }
      end

      context '读取文件大小信息' do
        before {
          @dir  = MediaResource.get(@xiao_wang, '/天意')
          @file = MediaResource.get(@xiao_wang, '/天意/刘德华.jpg')
        }

        it {
          @dir.size.should == 0
        }

        it {
          @file.size.should == 9
        }

        it {
          @dir.size_str.should == ''
        }

        it {
          @file.size_str.should == '9B'
        }
      end
    end

    describe '删除资源' do
      it '资源被删除后，fileops_time应该更新' do
        mr = MediaResource.get(@xiao_wang, '/天意/无间道.jpg')
        mr.fileops_time = 21.minutes.ago
        mr.save

        fileops_time = mr.fileops_time

        mr.remove

        mr.should be_is_removed
        mr.fileops_time.should_not == fileops_time
      end
    end

    describe '为指定用户创建资源' do
      file = Tempfile.new('test')

      before do
        MediaResource.all.each {|x| 
          x.fileops_time = 21.minutes.ago
          x.save
        }
        MediaResource.removed.each {|x|
          x.fileops_time = 21.minutes.ago
          x.save
        }
      end

      it '可以为指定用户创建资源' do
        MediaResource.get(@xiao_wang, '/这就是爱.txt').should == nil
        MediaResource.put(@xiao_wang, '/这就是爱.txt', file)
        MediaResource.get(@xiao_wang, '/这就是爱.txt').should_not == nil
      end

      it '创建资源时必须指定用户，否则抛异常' do
        expect {
          MediaResource.put(nil, '/这就是爱.txt', file)
        }.to raise_error(MediaResource::NotAssignCreatorError)
      end

      it '可以为不同的用户创建同名的资源' do
        count = MediaResource.count

        MediaResource.get(@xiao_wang, '/一杯二锅头.txt').should == nil
        MediaResource.get(@xiao_mao,  '/一杯二锅头.txt').should == nil

        MediaResource.put(@xiao_wang, '/一杯二锅头.txt', file)
        MediaResource.put(@xiao_mao,  '/一杯二锅头.txt', file)

        MediaResource.count.should == count + 2

        MediaResource.get(@xiao_wang, '/一杯二锅头.txt').should_not == nil
        MediaResource.get(@xiao_mao,  '/一杯二锅头.txt').should_not == nil

        MediaResource.get(@xiao_wang, '/一杯二锅头.txt').id.should_not == MediaResource.get(@xiao_mao,  '/一杯二锅头.txt').id
      end
    end

    describe '文件夹的文件计数' do

      file = Tempfile.new('test')

      it '文件夹会记录下面的文件计数' do
        MediaResource.get(@xiao_wang, '/天意').is_dir?.should == true
        MediaResource.get(@xiao_wang, '/天意').files_count.should == 3
      end

      it '对于上传的文件连带创建的父文件夹，文件计数是正确的' do
        MediaResource.put(@xiao_wang, '/小吃/花生.txt', file)
        MediaResource.get(@xiao_wang, '/小吃').files_count.should == 1

        MediaResource.put(@xiao_wang, '/饮料/矿泉水/农夫山泉.txt', file)

        MediaResource.get(@xiao_wang, '/饮料/矿泉水').is_dir?.should == true
        MediaResource.get(@xiao_wang, '/饮料/矿泉水').files_count.should == 1
        MediaResource.get(@xiao_wang, '/饮料').is_dir?.should == true
        MediaResource.get(@xiao_wang, '/饮料').files_count.should == 1

        MediaResource.put(@xiao_wang, '/饮料/可乐/百事可乐.txt', file)
        MediaResource.get(@xiao_wang, '/饮料/矿泉水').files_count.should == 1
        MediaResource.get(@xiao_wang, '/饮料/可乐').files_count.should == 1
        MediaResource.get(@xiao_wang, '/饮料').files_count.should == 2

        MediaResource.put(@xiao_wang, '/饮料/营养快线.txt', file)
        MediaResource.get(@xiao_wang, '/饮料/矿泉水').files_count.should == 1
        MediaResource.get(@xiao_wang, '/饮料/可乐').files_count.should == 1
        MediaResource.get(@xiao_wang, '/饮料').files_count.should == 3
      end

      it '对于已经删除的文件资源，其父文件夹的计数正确' do
        MediaResource.put(@xiao_wang, '/电影/文艺片/四月物语.rmvb', file)
        MediaResource.put(@xiao_wang, '/电影/喜剧片/疯狂的石头.rmvb', file)
        MediaResource.put(@xiao_wang, '/电影/喜剧片/疯狂的赛车.rmvb', file)

        MediaResource.get(@xiao_wang, '/电影').files_count.should == 3
        MediaResource.get(@xiao_wang, '/电影/文艺片').files_count.should == 1
        MediaResource.get(@xiao_wang, '/电影/喜剧片').files_count.should == 2

        MediaResource.get(@xiao_wang, '/电影/文艺片/四月物语.rmvb').remove

        MediaResource.get(@xiao_wang, '/电影').files_count.should == 2
        MediaResource.get(@xiao_wang, '/电影/文艺片').files_count.should == 0
        MediaResource.get(@xiao_wang, '/电影/喜剧片').files_count.should == 2

        MediaResource.get(@xiao_wang, '/电影/喜剧片').remove
        MediaResource.get(@xiao_wang, '/电影').files_count.should == 0
        MediaResource.get(@xiao_wang, '/电影/文艺片').files_count.should == 0
      end

      context '获取文件夹下的文件' do
        it { MediaResource.gets(@xiao_wang, '/').length.should > 0 }

        it { MediaResource.gets(@xiao_wang, '').length.should > 0 }

        it { MediaResource.gets(@xiao_wang).length.should > 0}

        it { MediaResource.gets(@xiao_wang, '  ').length.should > 0}

        it {
          MediaResource.gets(@xiao_wang, '/天意').length.should == 3
        }

        it {
          MediaResource.gets(@xiao_wang, '/天意/').length.should == 3
        }

        it {
          MediaResource.put(@xiao_wang, '/小吃/花生.txt', file)
          MediaResource.gets(@xiao_wang, '/小吃/').length.should == 1

          expect {
            MediaResource.gets(@xiao_wang, '/小吃/花生.txt')
          }.to raise_error(MediaResource::NotDirError)
        }

        it {
          expect {
            MediaResource.gets(@xiao_wang, '/椰子汁')
          }.to raise_error(MediaResource::InvalidPathError)
        }
      end
    end

    describe '能够根据传入的 cursor(状态标识) 返回 delta(变更信息)' do
      file = Tempfile.new('test')

      it '测试例的变更信息应当正确' do
        delta = MediaResource.delta(@xiao_wang, nil)
        delta.should_not == nil
        delta[:entries].blank?.should == false
        path = delta[:entries][0][0]
        path.should == '/天下/张杰'
      end

      it '当传入的状态标识为零或空时，从开头开始返回变更信息，包括删除变更' do
        delta = MediaResource.delta(@xiao_wang, nil)
        delta.should_not == nil

        cursor = delta[:cursor]
        cursor.should_not == nil

        delta[:entries][0][0].should == '/天下/张杰'

        Timecop.travel(Time.now + 1.hours)
        MediaResource.put(@xiao_wang, '/爷爷/爸爸/自己.zip', file)
        delta = MediaResource.delta(@xiao_wang, cursor)
        delta[:entries].blank?.should == false
        delta[:entries].length.should == 3
        cursor_2 = delta[:cursor]

        delta[:entries][0].should == [
          '/爷爷', 
          MediaResource.get(@xiao_wang, '/爷爷').metadata(:list => false)
        ]
        delta[:entries][1].should == [
          '/爷爷/爸爸', 
          MediaResource.get(@xiao_wang, '/爷爷/爸爸').metadata(:list => false)
        ]
        delta[:entries][2].should == [
          '/爷爷/爸爸/自己.zip', 
          MediaResource.get(@xiao_wang, '/爷爷/爸爸/自己.zip').metadata
        ]

        Timecop.travel(Time.now + 1.hours)
        MediaResource.put(@xiao_wang, '/爷爷/女儿/外孙.zip', file)

        delta_2 = MediaResource.delta(@xiao_wang, cursor)
        delta_2[:entries].blank?.should == false
        delta_2[:entries].length.should == 5

        delta_2 = MediaResource.delta(@xiao_wang, cursor_2)
        delta_2[:entries].blank?.should == false
        delta_2[:entries].length.should == 2
        cursor_3 = delta_2[:cursor]

        Timecop.travel(Time.now + 1.hours)
        MediaResource.get(@xiao_wang, '/爷爷/女儿').remove
        delta_3 = MediaResource.delta(@xiao_wang, cursor_3)
        delta_3[:entries].blank?.should == false
        delta_3[:entries].length.should == 2
      end

      it '删除文件导致的变更应该可以获取到，格式也应当正确' do
        cursor = MediaResource.delta(@xiao_wang, nil)[:cursor]

        Timecop.travel(Time.now + 1.hours)
        MediaResource.put(@xiao_wang, '/爷爷/爸爸/自己.zip', file)
        delta = MediaResource.delta(@xiao_wang, cursor)
        delta[:entries].blank?.should == false
        delta[:entries].length.should == 3
        cursor_2 = delta[:cursor]

        Timecop.travel(Time.now + 1.hours)
        MediaResource.get(@xiao_wang, '/爷爷/爸爸').remove
        delta_2 = MediaResource.delta(@xiao_wang, cursor_2)
        delta_2[:entries].blank?.should == false
        delta_2[:entries].length.should == 2

        delta_2[:entries][0].should == ['/爷爷/爸爸', nil]
        delta_2[:entries][1].should == ['/爷爷/爸爸/自己.zip', nil]
      end

      it '不同用户取得各自的delta信息时，不会冲突' do
        cursor_xiao_wang = MediaResource.delta(@xiao_wang, nil)[:cursor]
        cursor_xiao_mao  = MediaResource.delta(@xiao_mao, nil)[:cursor]

        cursor_xiao_wang.should_not == nil
        cursor_xiao_mao.should == nil

        Timecop.travel(Time.now + 1.hours)
        MediaResource.put(@xiao_wang, '/小说/奇幻/冰与火之歌.zip', file)
        MediaResource.put(@xiao_mao, '/电影/黑衣人.rmvb', file)
        delta_ben7th = MediaResource.delta(@xiao_wang, cursor_xiao_wang)
        delta_lifei  = MediaResource.delta(@xiao_mao, cursor_xiao_mao)

        delta_ben7th[:entries].length.should == 3
        delta_lifei[:entries].length.should == 2

        cursor_xiao_wang = delta_ben7th[:cursor]
        cursor_xiao_mao  = delta_lifei[:cursor]

        Timecop.travel(Time.now + 1.hours)
        MediaResource.put(@xiao_mao, '/电影/阿凡达2.rmvb', file)
        delta_ben7th = MediaResource.delta(@xiao_wang, cursor_xiao_wang)
        delta_lifei  = MediaResource.delta(@xiao_mao, cursor_xiao_mao)

        delta_ben7th[:entries].length.should == 0
        delta_lifei[:entries].length.should == 1
      end
    end
  end

  describe '# put_file_entity' do
    before do
      @xiao_wang = User.create!(
        :email => 'xiao_wang@env.com',
        :name  => 'xiao_wang',
        :password => '123456',
        :role     => :teacher
      )

      @dir_media_resource = MediaResource.create(
        :name    => '我是目录',
        :is_dir  => true,
        :creator => @xiao_wang,
        :media_resources => [
          MediaResource.new(
            :name => '子目录',
            :is_dir => true,
            :creator => @xiao_wang
          )
        ]
      )

    end

    it '目前在个人文件夹上传文件时，如果已经有同名文件，新上传的同名文件名字应该是这样 old_name(1) old_name(2)' do
      tmpfile = Tempfile.new('panda')
      tmpfile.write('hello world')

      file_entity = FileEntity.create(:attach => tmpfile)
      MediaResource.put_file_entity(@xiao_wang, '/我是目录/abc', file_entity)
      abc = MediaResource.last
      abc.name.should == 'abc'
      abc.path.should == '/我是目录/abc'

      file_entity = FileEntity.create(:attach => tmpfile)
      MediaResource.put_file_entity(@xiao_wang, '/我是目录/abc', file_entity)
      abc = MediaResource.last
      abc.name.should == 'abc(1)'
      abc.path.should == '/我是目录/abc(1)'

      file_entity = FileEntity.create(:attach => tmpfile)
      MediaResource.put_file_entity(@xiao_wang, '/我是目录/abc', file_entity)
      abc = MediaResource.last
      abc.name.should == 'abc(2)'
      abc.path.should == '/我是目录/abc(2)'

      file_entity = FileEntity.create(:attach => tmpfile)
      MediaResource.put_file_entity(@xiao_wang, '/abc', file_entity)
      abc = MediaResource.last
      abc.name.should == 'abc'
      abc.path.should == '/abc'

      file_entity = FileEntity.create(:attach => tmpfile)
      MediaResource.put_file_entity(@xiao_wang, '/abc', file_entity)
      abc = MediaResource.last
      abc.name.should == 'abc(1)'
      abc.path.should == '/abc(1)'

      file_entity = FileEntity.create(:attach => tmpfile)
      MediaResource.put_file_entity(@xiao_wang, '/abc', file_entity)
      abc = MediaResource.last
      abc.name.should == 'abc(2)'
      abc.path.should == '/abc(2)'

      file_entity = FileEntity.create(:attach => tmpfile)
      MediaResource.put_file_entity(@xiao_wang, '/我是目录/子目录/a.jpg', file_entity)
      abc = MediaResource.last
      abc.name.should == 'a.jpg'
      abc.path.should == '/我是目录/子目录/a.jpg'

      file_entity = FileEntity.create(:attach => tmpfile)
      MediaResource.put_file_entity(@xiao_wang, '/我是目录/子目录/a.jpg', file_entity)
      abc = MediaResource.last
      abc.name.should == 'a(1).jpg'
      abc.path.should == '/我是目录/子目录/a(1).jpg'

      file_entity = FileEntity.create(:attach => tmpfile)
      MediaResource.put_file_entity(@xiao_wang, '/我是目录/子目录/a.jpg', file_entity)
      abc = MediaResource.last
      abc.name.should == 'a(2).jpg'
      abc.path.should == '/我是目录/子目录/a(2).jpg'

      file_entity = FileEntity.create(:attach => tmpfile)
      a = MediaResource.put_file_entity(@xiao_wang, '/我是目录/子目录/a.jpg', file_entity)
      abc = MediaResource.last
      abc.name.should == 'a(3).jpg'
      abc.path.should == '/我是目录/子目录/a(3).jpg'
      a.should == abc
    end
  end

  describe '# move_to' do
    before do
      @xiao_wang = User.create!(
        :email => 'xiao_wang@163.com',
        :name  => 'xiao_wang',
        :password => '123456',
        :role     => :teacher
      )

      tmpfile = Tempfile.new('panda')
      tmpfile.write('hello world')

      @dir_media_resource = MediaResource.create(
        :name    => '我是目录',
        :is_dir  => true,
        :creator => @xiao_wang,
        :media_resources => [
          MediaResource.new(
            :name => '三只熊猫.jpg', 
            :is_dir => false,
            :creator => @xiao_wang,
            :file_entity => FileEntity.new(:attach => tmpfile)
          ),
          MediaResource.new(
            :name => 'abc', 
            :is_dir => true,
            :creator => @xiao_wang
          )
        ]
      )

      @file_media_resource_1 = MediaResource.create(
        :name => '三只狼.jpg', 
        :is_dir => false,
        :creator => @xiao_wang,
        :file_entity => FileEntity.new(:attach => tmpfile)
      )

      @file_media_resource_2 = MediaResource.create(
        :name => '三只熊猫.jpg', 
        :is_dir => false,
        :creator => @xiao_wang,
        :file_entity => FileEntity.new(:attach => tmpfile)
      )

      @dir_media_resource_1 = MediaResource.create(
        :name => 'def', 
        :is_dir => true,
        :creator => @xiao_wang
      )

      @dir_media_resource_2 = MediaResource.create(
        :name => 'abc', 
        :is_dir => true,
        :creator => @xiao_wang
      )
    end

    context '移动资源（文件、目录）时，目标位置有同名资源（文件、目录）时，应当都不允许移动' do
      it {
        @file_media_resource_1.move_to('/我是目录').should == true
        @file_media_resource_1.dir.should == @dir_media_resource
      }

      it {
        @dir_media_resource_1.move_to('/我是目录').should == true
        @dir_media_resource_1.dir.should == @dir_media_resource
      }

      it {
        @file_media_resource_2.move_to('/我是目录').should == false
        @file_media_resource_2.valid?.should == false
        @file_media_resource_2.errors[:dir].blank?.should == false
      }

      it {
        @dir_media_resource_2.move_to('/我是目录').should == false
        @dir_media_resource_2.valid?.should == false
        @dir_media_resource_2.errors[:dir].blank?.should == false
      }

      it {
        @file_media_resource_1.move_to('').should == true
        @file_media_resource_1.dir_id.should == 0
      }

      it {
        @file_media_resource_1.move_to('/我是目录')
        @file_media_resource_1.move_to(nil).should == true
        @file_media_resource_1.dir_id.should == 0
      }

      it {
        @file_media_resource_1.move_to('/我是目录')
        @file_media_resource_1.move_to('/').should == true
        @file_media_resource_1.dir_id.should == 0
      }
    end
  end

  describe '个人资源目录 dir_id 可以赋值' do
    before do
      @xiao_wang = User.create!(
        :email => 'xiao_wang@163.com',
        :name  => 'xiao_wang',
        :password => '123456',
        :role     => :teacher
      )

      @dir_media_resource = MediaResource.create(
        :name    => '我是目录',
        :is_dir  => true,
        :creator => @xiao_wang
      )

      tmpfile = Tempfile.new('panda')
      tmpfile.write('hello world')
      @file_media_resource_1 = MediaResource.create(
        :name => '三只熊猫.jpg', 
        :is_dir => false,
        :creator => @xiao_wang,
        :file_entity => FileEntity.new(:attach => tmpfile)
      )

      @file_media_resource_2 = MediaResource.create(
        :name => '三只狼.jpg', 
        :is_dir => false,
        :creator => @xiao_wang,
        :file_entity => FileEntity.new(:attach => tmpfile)
      )
    end

    context '个人资源目录 dir_id 字段没有增加校验' do
      it {
        @file_media_resource_1.dir_id = @dir_media_resource.id
        @file_media_resource_1.valid?.should == true
      }

      it {
        @file_media_resource_1.dir_id = @file_media_resource_2.id
        @file_media_resource_1.valid?.should == false
        @file_media_resource_1.errors[:dir].should_not be_blank
      }

      it {
        @file_media_resource_1.dir_id = -1
        @file_media_resource_1.valid?.should == false
        @file_media_resource_1.errors[:dir].should_not be_blank
      } 
    end
  end

  describe '新注册用户预制目录' do
    it{
      user = FactoryGirl.create :user

      dir_names = YAML.load_file(Rails.root.join('config/default_media_resource_dir.yaml'))["default_dir"]
      user.media_resources.root_res.dir_res.should =~ []
      user.set_default_media_resource_dirs
      user.set_default_media_resource_dirs
      user.media_resources.root_res.dir_res.map(&:name).should =~ dir_names
    }
      
  end
end