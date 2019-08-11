FactoryBot.define do
  factory :team do
    trait :bengals do
      name { "Bengals" }
      location { "Cincinnati" }
      nickname { ["CIN"] }
      home_field_advantage { "2.5" }
      bye_week { "9" }
    end

    trait :browns do
      name { "Browns" }
      location { "Cleveland" }
      nickname { ["CLE"] }
      home_field_advantage { "1.9" }
      bye_week { "11" }
    end
  end
end
