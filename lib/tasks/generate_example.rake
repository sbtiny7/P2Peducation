require 'yaml'
desc "生成配置文件 example"
task :generate_example => :environment do
    config_path = File.join(Rails.root, "config")
    Dir.chdir(config_path)
    Dir.glob('app_config.yml').each do |f|
        original = YAML.load_file(f)
        File.open("#{f}.example", "w") {|file| file.write (delete_value original).to_yaml}
    end
end

def delete_value(hash)
    hash.each do |k, v|
        if v.class == Hash
            hash[k] = delete_value v
        else
            hash[k] = nil
        end
    end
end
