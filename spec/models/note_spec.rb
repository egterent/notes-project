require 'rails_helper'
require_relative '../shared/note_shared_context'
require_relative '../shared/category_shared_examples'

RSpec.describe Note, type: :model do
  context 'method' do
    describe 'update_category' do
      include_context 'initialize subject and masks for notes'

      context 'when favorite token value is' do
        context '0' do
          let(:favorite_token) { '0' }

          context 'all nesting categories favorite status' do
            include_context 'one note favorite status updated to 0'

            include_examples 'should change related items favorite status'
          end
        end

        context '1' do
          let(:favorite_token) { '1' }

          context 'favorite status of nesting category' do
            context 'if all nested notes favorite status is 1' do
              include_context 'two notes favorite status updated'

              include_examples 'should change related items favorite status'
            end

            context 'if there are notes which favorite status is 0' do
              context 'should keep its value, only the note favorite status' do
                include_context 'one note favorite status updated to 1'

                include_examples 'should change related items favorite status'
              end
            end
          end
        end
      end
    end
  end
end
