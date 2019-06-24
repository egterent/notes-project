# frozen_string_literal: true

class Note < ApplicationRecord
  validates :title, presence: true, length: { minimum: 1 }
  belongs_to :category
  validates :category_id, presence: true
  belongs_to :user
  validates :user_id, presence: true
end
