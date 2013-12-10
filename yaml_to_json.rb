require 'json'
require 'yaml'

Dir["/Users/menxu/Workspace/android/eshare/eshare-android-preview/assets/*.yaml"].each do |path|
	str = IO.read(path)
	hash = YAML.load(str)
    json = JSON.generate(hash)

	p path
	p path.match(/[0-9]+/)
    id = path.match(/[0-9]+/)[0]
	  
    out_path = "./json/#{id}.json"
    p "convert #{out_path}"
	File.open(out_path,"w"){|f|f << json}
end
