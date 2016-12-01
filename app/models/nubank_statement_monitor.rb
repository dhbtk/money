class NubankStatementMonitor < ApplicationRecord
  belongs_to :account

  validates :account, uniqueness: true
  validates :cpf, :password, presence: true

  def check_for_new
    json = JSON.parse(`node nubank.js #{cpf} #{password}`)

    transactions = json['events'].select{ |e| e['category'] == 'transaction' }

    if self.data.present?
      ids = transactions.map{ |t| t['id'] }
      new_transactions = transactions.select{ |t| !ids.include?(t['id']) }
      Credit.transaction do
        new_transactions.sort{ |a, b| DateTime.strptime(a['time']) <=> DateTime.strptime(a['time']) }.each do |transaction|
          credit = account.credit.build(name: transaction['description'],
                                        date: DateTime.strptime(transaction['description']).to_date,
                                        value: BigDecimal.new(transaction['amount'])/100)
          credit.save!
        end
      end
    end
    update(data: transactions.to_json)
  end
end
