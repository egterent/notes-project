require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  context 'when user is not logged in' do
    describe 'POST #create' do
      it 'should redirect to login url' do
        expect { post :create, params: { category: { name: "Music",
                                                     favorite_token: 0 } } }
                .not_to change { Category.count }
        should redirect_to(login_url)
      end
    end

    describe 'DELETE #destroy' do
      it 'should redirect to login url' do
        category = create(:category)
        expect { delete :destroy, params: { :id => category.id } }
                .not_to change { Category.count }
        should redirect_to(login_url)
      end
    end
  end
end
