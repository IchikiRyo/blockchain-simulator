require 'openssl'

require_relative 'blockchain'

class Miner
  attr_reader :name, :blockchain
  def initialize args
    @name = args[:name]
    @rsa = OpenSSL::PKey::RSA.generate(2048)
    @blockchain = Blockchain.new
  end

  def accept receive_blockchain
    puts "#{@name} checks received blockchain. Size: #{@blockchain.size}"
    if receive_blockchain.size > @blockchain.size
      if Blockchain.is_valid_chain? receive_blockchain
        puts "#{@name} accepted received blockchain"
        @blockchain = receive_blockchain.clone
      else
        puts "Received blockchain invalid"
      end
    end
  end

  def add_new_block
    next_block = @blockchain.next_block []
    @blockchain.add_block(next_block)
    puts "#{@name} add new block: #{next_block.hash}"
  end
end