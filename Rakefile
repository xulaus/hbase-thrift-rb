task :generate do
  require 'tempfile'
  require 'open-uri'

  root = File.expand_path('../', __FILE__)
  spec = Gem::Specification::load(File.join(root, 'hbase-thrift.gemspec'))
  puts "Downloading hbase thirft file for #{spec.version}"
  thrift_url = "https://raw.githubusercontent.com/apache/hbase/#{spec.version}/hbase-thrift/src/main/resources/org/apache/hadoop/hbase/thrift/Hbase.thrift"
  Tempfile.create('hbase.thrift') do |thrift_file|
    URI.open(thrift_url, "rb") do |resp|
      thrift_file.write(resp.read)
    end

    `thrift --gen rb --out #{File.join(root, 'lib')} #{thrift_file.path}`
  end
end

task :build => :generate

require 'bundler/gem_tasks'
