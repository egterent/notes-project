require 'rails_helper'
require_relative '../../shared/services_shared_context'

RSpec.describe ParentManager::Redirector do
  include_context 'categories url'
  let(:session) { { parent_category_url: url } }

  context 'when called' do
    it 'should remove parent category url from session' do
      described_class.call(session) {}
      expect(session[:parent_category_url]).to be(nil)
    end

    it 'should return parent category url' do
      url1 = ""
      described_class.call(session) { |str| url1 = str }
      expect(url1).to eq(url)
    end
  end
end
