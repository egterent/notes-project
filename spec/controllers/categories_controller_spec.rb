require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  context 'when user is not logged in' do
    describe 'POST #create' do
      let(:category_params) { { name: 'Music', favorite_token: 0 } }
      let(:create_category) do
        post :create, category: category_params
      end

      it 'should redirect to login url' do
        expect { create_category }.to { avoid_changing { Category.all.count } }
        should redirect_to(login_url)
      end
    end

    describe 'DELETE #destroy' do
      let(:delete_category) do
        delete :destroy, id: create(:category).id
      end

      it 'should redirect to login url' do
        expect { delete_category }.to { avoid_changing { Category.all.count } }
        should redirect_to(login_url)
      end
    end
  end
end
