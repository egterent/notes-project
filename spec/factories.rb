FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "user-#{n}@example.com" }
    password { '123456' }
    password_confirmation { '123456' }
    admin { false }
    
    trait :admin do
      admin { true }
    end 
  end

  factory :note do
    title { Faker::Lorem.word }
    body { Faker::Lorem.paragraph }
    favorite { 0 }
    category
    user 
  end

  factory :category do
    name { Faker::Lorem.word }
    parent_id { nil }
    favorite { 0 }
    user
    
    factory :category_with_notes do
      transient do
        notes_count { 2 }
      end

      after(:create) do |category, evaluator|
        create_list(:note, evaluator.notes_count, favorite: category.favorite, category: category, user: category.user)
      end
    end

    factory :category_with_subcategories do
      transient do
        subs_count { 3 }
      end

      after(:create) do |category, evaluator|
        create_list(:category, evaluator.subs_count, favorite: category.favorite, parent_id: category.id, user: category.user)
      end
    end

    factory :category_with_two_levels_subcategories do
      transient do
        subs_count { 3 }
      end

      transient do
        subs_2_count { 2 }
      end

      after(:create) do |category, evaluator|
        create_list(:category_with_subcategories, evaluator.subs_count, subs_count: evaluator.subs_2_count, favorite: category.favorite, parent_id: category.id, user: category.user)
      end
    end

    factory :category_with_subcategories_and_notes do
      transient do
        subs_count { 2 }
      end

      transient do
        notes_count { 2 }
      end

      after(:create) do |category, evaluator|
        create_list(:category_with_notes, evaluator.subs_count, notes_count: evaluator.notes_count, favorite: category.favorite, parent_id: category.id, user: category.user)
      end
    end

    factory :category_with_two_levels_subcategories_and_notes do
      transient do
        subs_count { 3 }
      end

      after(:create) do |category, evaluator|
        create_list(:category_with_subcategories_and_notes, evaluator.subs_count, favorite: category.favorite, parent_id: category.id, user: category.user)
      end
    end
  end
end
