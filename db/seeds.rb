# frozen_string_literal: true

# 30.times do |i|
#   User.create name: "User #{i + 1}", email: "user#{i + 1}@example.com", password: 'P@$$w0rdS',
#               password_confirmation: 'P@$$w0rdS'
# end

PlayingTeam.all.find_each { |t| t.update place: nil, total_answered: 0 }
Answer.all.find_each { |a| a.update correct: false }
