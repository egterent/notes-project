require 'rails_helper'
require_relative 'category_shared_context'

RSpec.shared_examples 'should change related items favorite status' do
  include_context 'notes and categories masks'

  it 'should be changed to favorite token value' do
    subject.each do |category|
      expect(category.favorite).to eq(categories_mask[category.id])
    end
    subject.each do |category|
      next unless category.notes.any?

      category.notes.each do |note|
        expect(note.favorite).to eq(notes_mask[note.id])
      end
    end
  end
end
