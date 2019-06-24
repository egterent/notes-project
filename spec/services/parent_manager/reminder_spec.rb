require 'rails_helper'
require_relative '../../shared/services_shared_context'

describe ParentManager::Reminder do
  let(:session) { {} }
  include_context 'categories url'

  context 'when called' do
    it 'should store parent category url to session' do
      described_class.call(session, url)
      expect(session[:parent_category_url]).to eq(url)
    end
  end
end
