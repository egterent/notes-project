require 'rails_helper'
require_relative '../shared/category_shared_context'
require_relative '../shared/category_shared_examples'

RSpec.describe Category, type: :model do
  let(:user) { create(:user) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(50) }
    it { should validate_presence_of(:user_id) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:parent).class_name('Category').optional }
    it do
      should have_many(:subcategories).class_name('Category')
        .with_foreign_key('parent_id').dependent(:destroy)
    end
    it { should have_many(:notes).dependent(:destroy) }
  end

  describe 'table' do
    it { should have_db_column(:parent_id) }
    it { should have_db_column(:favorite) }
  end

  context 'methods' do
    describe 'nested_notes_count' do
      context 'if there are not any nested notes' do
        subject do
          create(:category_with_subcategories, user: user)
        end

        it 'should return 0' do
          expect(subject.nested_notes_count).to eq(0)
        end
      end

      context 'if there are nested notes in subcategories' do
        let(:subs_count) { 2 }
        let(:notes_count) { 3 }
        subject do
          create(:category_with_subcategories_and_notes,
                 subs_count: subs_count, notes_count: notes_count)
        end

        it 'should return count of all notes in all subcategories' do
          expect(subject.nested_notes_count).to eq(notes_count * subs_count)
        end

        context 'when a note is deleted' do
          let(subject_0) do
            subject.subcategories.first.notes.first.destroy
          end
          it 'should decrement nested notes count' do
            expect { subject_0 }.to change { subject.nested_notes_count }.by(-1)
          end
        end

        context 'when a new note is added' do
          let(:subject_1) do
            subject.subcategories.first.notes.create!(title: 'note',
                                                      user_id: user.id)
          end
          it 'should increment nested notes count' do
            expect { subject_1 }.to change { subject.nested_notes_count }.by(1)
          end
        end
      end
    end

    describe 'update_related_items' do
      context 'when favorite token value is' do
        context '0' do
          let(:favorite_token) { 0 }
          include_context 'initialize subject'

          context 'all related items favorite status' do
            include_context 'one category favorite status updated'
            include_examples 'favorite status of related items should be changed'
          end
        end

        context '1' do
          let(:favorite_token) { 1 }

          context 'all nested items favorite status' do
            include_context 'initialize subject'
            include_context 'one category favorite status updated'

            include_examples 'favorite status of related items should be changed'
          end

          context 'favorite status of parent category' do
            include_context 'initialize subject'
            include_context 'two categories favorite status updated'

            context 'if all nested subcategories favorite status is 1' do
              include_examples 'favorite status of related items should be changed'
            end
          end
        end
      end
    end

    describe 'each' do
      context 'if category does not contain any subcategories' do
        it 'should return the category' do
          expect(subject.each).to contain_exactly(subject)
        end
      end

      context 'if  category contains subcategories' do
        subject do
          create(:category_with_two_levels_subcategories, subs_count: 2,
                 subs_2_count: 2)
        end

        it 'should return the category with all subcategories' do
          expect(subject.each).to
            contain_exactly(subject, subject.subcategories.first,
                            subject.subcategories.second,
                            subject.subcategories.first.subcategories.first,
                            subject.subcategories.first.subcategories.second,
                            subject.subcategories.second.subcategories.first,
                            subject.subcategories.second.subcategories.second)
        end
      end
    end
  end
end
