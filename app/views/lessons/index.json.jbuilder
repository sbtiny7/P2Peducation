json.array!(@lessons) do |lesson|
  json.extract! lesson, :id, :title, :course_id
  json.url lesson_url(lesson, format: :json)
end
