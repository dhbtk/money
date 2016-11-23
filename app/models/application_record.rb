class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def sync_selectors
      @sync_selectors ||= []
    end

    def sync_selectors=(val)
      @sync_selectors = val
    end

    def insertion_order
      @insertion_order ||= []
    end

    def insertion_order=(val)
      @insertion_order = val
    end
  end

  self.insertion_order = ['User', 'Tag', 'Account', 'RecurringCredit', 'RecurringDebit', 'Credit', 'Debit', 'Transfer']
end
