# Cleaning existing data
Answer.destroy_all
Attempt.destroy_all
Option.destroy_all
Question.destroy_all
Quiz.destroy_all
User.destroy_all

# Create admin
admin = User.create!(
  email: "admin@quiz.com",
  password: "password123",
  first_name: "Admin",
  last_name: "Principal",
  role: :admin
)

# Create player
player = User.create!(
  email: "player@quiz.com",
  password: "password123",
  first_name: "Juan",
  last_name: "Pérez",
  role: :player
)

# Quiz 1 - Published
quiz1 = admin.quizzes.create!(
  title: "Capitales del Mundo",
  description: "¿Cuánto sabes de geografía?",
  status: :published,
  passing_score: 70
)

q1 = quiz1.questions.create!(body: "¿Cuál es la capital de Chile?")
q1.options.create!(body: "Lima", correct: false)
q1.options.create!(body: "Santiago", correct: true)
q1.options.create!(body: "Bogotá", correct: false)
q1.options.create!(body: "Buenos Aires", correct: false)

q2 = quiz1.questions.create!(body: "¿Cuál es la capital de Japón?")
q2.options.create!(body: "Seúl", correct: false)
q2.options.create!(body: "Pekín", correct: false)
q2.options.create!(body: "Tokio", correct: true)
q2.options.create!(body: "Bangkok", correct: false)

q3 = quiz1.questions.create!(body: "¿Cuál es la capital de Australia?")
q3.options.create!(body: "Sídney", correct: false)
q3.options.create!(body: "Melbourne", correct: false)
q3.options.create!(body: "Canberra", correct: true)
q3.options.create!(body: "Brisbane", correct: false)

# Quiz 2 - Draft
quiz2 = admin.quizzes.create!(
  title: "Historia Universal",
  description: "Pon a prueba tus conocimientos de historia.",
  status: :draft,
  passing_score: 60
)

q4 = quiz2.questions.create!(body: "¿En qué año llegó Colón a América?")
q4.options.create!(body: "1492", correct: true)
q4.options.create!(body: "1500", correct: false)
q4.options.create!(body: "1488", correct: false)
q4.options.create!(body: "1510", correct: false)

puts "Seeds creados:"
puts "  Admin: admin@quiz.com / password123"
puts "  Player: player@quiz.com / password123"
puts "  Quizzes: #{Quiz.count}"
puts "  Questions: #{Question.count}"
puts "  Options: #{Option.count}"
