namespace :miner do
  desc "Build blocks"
  task :new_blocks => :environment do
    bw = BlockWorker.make
    if bw.proof_of_work
      # it is confirmed. Create the block and update the payments to be a part of it.
      b = Block.create miner_id: 1, block_worker_id: bw.id  # leaving data blank for now
      list = JSON.parse bw.payment_list
      list.each do |payid|
        pay = Payment.find payid
        pay.update_attribute(:block_id, b.id)
      end
    end
  end
  
  # other tasks will transmit blocks to the network and validate received blocks.
end