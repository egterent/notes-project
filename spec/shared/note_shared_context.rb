require_relative '../shared/category_shared_context'

RSpec.shared_context 'initialize subject and masks for notes' do
  include_context 'initialize subject'
  include_context 'basic favorite masks'
  let(:category) { subject_1.subcategories.first.subcategories.first }
  let(:note) { category.notes.first }
  let(:notes_mask) do
    basic_notes_mask[note.id] = favorite_token
    basic_notes_mask.map { |k, v| [k, v.to_s] }.to_h
  end
end

RSpec.shared_context 'one note favorite status updated' do
  subject(:subject_2) do
    note.update_attribute(:favorite, favorite_token)
    note.update_category(favorite_token)
    subject_1.reload
  end
end

RSpec.shared_context 'one note favorite status updated to 0' do
  include_context 'one note favorite status updated'
  let(:categories_mask) do
    basic_categories_mask[subject_1.id] = 0
    basic_categories_mask[subject_1.subcategories.first.id] = 0
    basic_categories_mask[category.id] = 0
    basic_categories_mask.map { |k, v| [k, v.to_s] }.to_h
  end
end

RSpec.shared_context 'one note favorite status updated to 1' do
  include_context 'one note favorite status updated'
  let(:categories_mask) do
    basic_categories_mask.map { |k, v| [k, v.to_s] }.to_h
  end
end

RSpec.shared_context 'two notes favorite status updated' do
  include_context 'one note favorite status updated'
  subject(:subject_3) do
    category.notes.second.update_attribute(:favorite, favorite_token)
    category.notes.second.update_category(favorite_token)
    notes_mask[category.notes.second.id] = favorite_token.to_s
    subject_2.reload
  end
  let(:categories_mask) do
    basic_categories_mask[category.id] = favorite_token
    basic_categories_mask.map { |k, v| [k, v.to_s] }.to_h
  end
end
