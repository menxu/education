# -*- coding: utf-8 -*-
FactoryGirl.define do
  sequence(:num) {|n| n}

  factory :user, :aliases => [:creator, :receiver, :sharer, :teacher_user] do
    email    {"admin#{generate(:num)}@env.com"}
    name     {"用户#{generate(:num)}"}
    password '123456'
    role :teacher

    trait :teacher do
      role :teacher
    end

    trait :student do
      role :student
    end

    trait :student do
      role :student
    end

    trait :manager do
      role :manager
    end
  end
end
