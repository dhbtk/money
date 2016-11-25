class Revision < ApplicationRecord
  belongs_to :model, polymorphic: true
  validates :model, :revision_type, :data, presence: true
  enum revision_type: [:inserted, :updated, :deleted]
end
