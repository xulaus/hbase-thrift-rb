Gem::Specification.new do |spec|
  spec.name = "hbase-thrift"
  spec.summary = ""
  spec.authors = ""
  spec.version = "2.5.2RC0"

  files = Dir["lib/**/{*,.*}"]
  spec.files = files

  spec.add_runtime_dependency "thrift"
end
