require_relative 'blockchain/blockchain'
require_relative 'blockchain/miner'

## blockchain simulator
$receive_blockchain = Blockchain.new

def create_miner args
  Thread.new {
    miner = Miner.new args
    3.times do
      sleep [1, 2, 3].sample
      miner.accept $receive_blockchain
      [1, 2, 3].sample.times.each do |i|
        miner.add_new_block
      end
      broadcast miner
    end
  }
end

def broadcast miner
  puts "#{miner.name} broadcasted"
  $receive_blockchain = miner.blockchain
end

puts "start"
th1 = create_miner name: "miner1"
th2 = create_miner name: "miner2"
th3 = create_miner name: "miner3"
[th1, th2, th3].each{|t| t.join}

puts "blockchain result"

$receive_blockchain.blocks.each do |block|
  puts "*** Block #{block.height} ***"
  puts "hash: #{block.hash}"
  puts "previous_hash: #{block.previous_hash}"
  puts "timestamp: #{block.timestamp}"
  puts "transactions: #{block.transactions}"
  puts "nonce: #{block.nonce}"
  puts ""
end