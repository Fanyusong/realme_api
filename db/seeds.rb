# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
random_numbers = (1..500000).sort_by{ rand }
random_numbers.shift(100).each do |v|
  RewardList.create(random_number: v, reward_type_id: 1)
end
random_numbers.shift(200000).each do |v|
  RewardList.create(random_number: v, reward_type_id: 2)
end
random_numbers.shift(150000).each do |v|
  RewardList.create(random_number: v, reward_type_id: 3)
end
random_numbers.shift(100000).each do |v|
  RewardList.create(random_number: v, reward_type_id: 4)
end
random_numbers.shift(30).each do |v|
  RewardList.create(random_number: v, reward_type_id: 5)
end
random_numbers.shift(1).each do |v|
  RewardList.create(random_number: v, reward_type_id: 6)
end
random_numbers_2 = (1..500000).sort_by{ rand }
random_numbers_2.each do |v|
  RandomNumber.create(number: v)
end
# RewardList.create(non_numbers)
