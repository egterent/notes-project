require 'rails_helper'

RSpec.describe NotesController, type: :controller do
  context 'when user is not logged in' do
    describe 'POST #create' do
      let(:note_params) { { title: 'Today', category_id: 1 } }
      let(:post_create) do
        post :create, params: { note: note_params }
      end

      it 'should redirect to login url' do
        expect { post_create }.not_to(change { Note.all.count })
        should redirect_to(login_url)
      end
    end

    describe 'DELETE #destroy' do
      before(:example) { @note = create(:note) }
      let(:delete_note) do
        delete :destroy, params: { id: @note.id }
      end

      it 'should redirect to login url' do
        expect { delete_note }.not_to(change { Note.all.count })
        should redirect_to(login_url)
      end
    end
  end
end
