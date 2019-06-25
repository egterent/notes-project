require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(50) }

    it { should validate_presence_of(:email) }
    it { should validate_length_of(:email).is_at_most(100) }
    it { should validate_uniqueness_of(:email).case_insensitive }

    it { should allow_value('user@example.com').for(:email) }
    it { should allow_value('USER@foo.COM').for(:email) }
    it { should allow_value('A_US-ER@foo.bar.org').for(:email) }
    it { should allow_value('first.last@foo.jp').for(:email) }
    it { should allow_value('alice+bob@baz.cn').for(:email) }

    it { should_not allow_value('user@example,com').for(:email) }
    it { should_not allow_value('user_at_foo.org').for(:email) }
    it { should_not allow_value('user.name@example.').for(:email) }
    it { should_not allow_value('foo@bar_baz.com').for(:email) }
    it { should_not allow_value('foo@bar+baz.com').for(:email) }

    it { should have_secure_password }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  context 'associations' do
    it { should have_many(:categories).dependent(:destroy) }
    it { should have_many(:notes) }
  end
end
