class AddNameToTransferDependents < ActiveRecord::Migration[5.0]
  def change
    Transfer.all.each do |transfer|
      if transfer.credit.name.nil?
        transfer.credit.update(name: transfer.description)
      end
      if transfer.debit.name.nil?
        transfer.debit.update(name: transfer.description)
      end
    end
  end
end
