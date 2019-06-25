require 'rails_helper'
require_relative '../../shared/services_shared_context'

RSpec.describe ParentManager::CategoryProvider do
  include_context 'categories url'

  context 'when called if a category was created' do
    let(:user) { create(:user) }
    let(:category) { create(:category, user: user) }

    context 'in a parent category' do
      it 'should return the parent category' do
        session = { parent_category_url: url + category.id.to_s }
        expect(described_class.call(session, user)).to eql(category)
      end
    end

    context 'in index' do
      it 'should return nil' do
        session = { parent_category_url: url }
        expect(described_class.call(session, user)).to be(nil)
      end
    end
  end
end
