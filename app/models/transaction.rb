class Transaction < ActiveRecord::Base
  belongs_to :transactable, polymorphic:true
  validates :transaction_code, uniqueness: { scope: [:transaction_time, :transaction_code] }
  scope :credits_sold, -> { where(transaction_code: [20,21]) }

end
