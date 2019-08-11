FactoryBot.define do
  factory :team do
    trait :bengals do
      name { "Bengals" }
      location { "Cincinnati" }
      nickname { ["CIN"] }
      home_field_advantage { "2.5" }
      bye_week { "9" }
    end
  end
end
