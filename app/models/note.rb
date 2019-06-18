class Note < ApplicationRecord
  belongs_to :user
  belongs_to :category
  validates :title, presence: true, length: { minimum: 1 }
end
