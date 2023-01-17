require_relative 'hbase.rb'

module HBase
  include Apache::Hadoop::Hbase::Thrift
  def self.with_client(host = 'localhost', port = '9090')
    socket = Thrift::Socket.new(host, port)
    transport = Thrift::BufferedTransport.new(socket)
    protocol = Thrift::BinaryProtocolAccelerated.new(transport)

    transport.open()
    yield Apache::Hadoop::Hbase::Thrift::Hbase::Client.new(protocol)
    transport.close()
  end
end
