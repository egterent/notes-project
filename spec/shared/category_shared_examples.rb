require 'rails_helper'
require_relative 'category_shared_context'

RSpec.shared_examples 'favorite status of related items should be changed' do
  include_context 'notes and categories masks'

  it 'should be changed to favorite token value' do
    subject.each do |category|
      expect(category.favorite).to eq(categories_mask[category.id])
    end
    subject.each do |category|
      if category.notes.any?
        category.notes.each do |note|
          expect(note.favorite).to eq(notes_mask[note.id])
        end
      end
    end
  end
end
