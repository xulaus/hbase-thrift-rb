require_relative 'hbase.rb'

module HBase
  include Apache::Hadoop::Hbase::Thrift
  def self.with_client(host = 'localhost', port = '9090')
    socket = Thrift::Socket.new(host, port)
    transport = Thrift::BufferedTransport.new(socket)
    protocol = if defined? Thrift::BinaryProtocolAccelerated
      Thrift::BinaryProtocolAccelerated.new(transport)
    else
      Thrift::BinaryProtocol.new(transport)
    end

    transport.open()
    begin
      yield Apache::Hadoop::Hbase::Thrift::Hbase::Client.new(protocol)
    ensure
      transport.close()
    end
  end

  def self.scanTable(name, columns, batchSize: 1000, &block)
    e = Enumerator.new do |e|
      with_client do |c|
        scan_def = TScan.new(startRow: '', columns: Array(columns), caching: batchSize)
        scanner = c.scannerOpenWithScan(name, scan_def, {})

        begin
          c.send_scannerGet(scanner)
          while((rows = c.recv_scannerGet()).present?) do
            c.send_scannerGet(scanner)
            e.yield rows[0].columns.transform_values { |v| v.value }
          end
        ensure
          c.scannerClose(scanner)
        end
      end
    end

    return e unless block_given?
    return e.each(&block)
  end
end
