# frozen_string_literal: true

class Note < ApplicationRecord
  validates :title, presence: true, length: { minimum: 1 }
  belongs_to :category
end
