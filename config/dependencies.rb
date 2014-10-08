factory :feature_factory do |container|
  type = container[:type]
  container[:"#{type}_feature_factory"].new
end

factory :exercises_feature_factory do |container|
  container[:generic_feature_factory].new
end

factory :forum_feature_factory do |container|
  container[:generic_feature_factory].new
end

factory :shows_feature_factory do |container|
  container[:generic_feature_factory].new
end

factory :repositories_feature_factory do |container|
  container[:licenseable_feature_factory].new
end

factory :video_tutorials_feature_factory do |container|
  container[:licenseable_feature_factory].new
end

factory :mentor_feature_factory do |container|
  Features::Mentor.new(user: container[:user])
end

factory :generic_feature_factory do |container|
  Features::Generic.new
end

factory :licenseable_feature_factory do |container|
  Features::Licenseable.new(user: container[:user])
end
