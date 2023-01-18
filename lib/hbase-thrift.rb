require_relative 'hbase.rb'

module HBase
  include Apache::Hadoop::Hbase::Thrift
  def self.with_client(host = 'localhost', port = '9090')
    socket = Thrift::Socket.new(host, port)
    transport = Thrift::BufferedTransport.new(socket)
    protocol = Thrift::BinaryProtocolAccelerated.new(transport)

    transport.open()
    begin
      yield Apache::Hadoop::Hbase::Thrift::Hbase::Client.new(protocol)
    ensure
      transport.close()
    end
  end

  def self.scanTable(name, columns, &block)
    e = Enumerator.new do |e|
      with_client do |c|
          scanner =  c.scannerOpen(name, '', Array(columns), {})
          while((row = c.scannerGet(scanner)).present?) do
            e.yield row[0].columns.transform_values { |v| v.value }
          end
        end
      end

    return e unless block_given?
    return e.each(&block)
  end
end
