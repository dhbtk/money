class BillingAccount < Account
  def total_due
    balance.abs
  end
end
