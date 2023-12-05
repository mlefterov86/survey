# frozen_string_literal: true

if Rails.env.development?
  AdminUser.create!(email: 'admin@example.com', password: 'password',
                    password_confirmation: 'password')
  puts '==> Admin user created'
end

100.times { Question.create!(content: Faker::Lorem.sentence) }
puts '==> Questions created'

20.times do |n|
  begin
    poll = Poll.new(title: "Poll #{n}", questions_limit: rand(5..15))
    poll.questions << poll.questions_limit.times.map { Question.find(rand(100)) }
    poll.state = Poll.states.values[rand(0..2)]
    poll.save!(validate: false)
  rescue
    retry
  end
end
puts '==> Polls created'

30.times { Customer.create!(ip: Faker::Internet.ip_v4_address) }
puts '==> Customers created'

200.times do
  polls = Poll.published.or(Poll.archived)
  poll = polls[rand(polls.count)]
  question = poll.questions[rand(poll.questions_limit)]
  customer = Customer.all[rand(Customer.count)]
  Vote.create!(customer:, poll:, question:)
rescue StandardError
  next
end
puts '==> Customers votest created'
