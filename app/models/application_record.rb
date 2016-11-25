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

  after_create do
  	  unless self.class == Revision
  	  	  puts "after_create"
  	  	  revision = Revision.new
  	  	  revision.model = self
  	  	  revision.revision_type = 'inserted'
  	  	  revision.data = self.to_json
  	  	  revision.save
  	  end
  end

  after_update do
  	  unless self.class == Revision
  	  	  puts "after_update"
  	  	  revision = Revision.new
  	  	  revision.model = self
  	  	  revision.revision_type = 'updated'
  	  	  revision.data = self.to_json
  	  	  revision.save
  	  end
  end

  after_destroy do
  	  unless self.class == Revision
  	  	  puts "after_destroy"
  	  	  revision = Revision.new
  	  	  revision.model = self
  	  	  revision.revision_type = 'deleted'
  	  	  revision.data = self.to_json
  	  	  revision.save
  	  end
  end
end
