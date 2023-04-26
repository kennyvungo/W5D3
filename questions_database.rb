require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true #all the data we get back is the same data type, int in sql, int in ruby
        self.results_as_hash = true #data will come back as a hash, instead of array (default)
    end
end

class User

end

class Question
    def self.find_by_id(id)
        query = QuestionsDatabase.instance.execute(<<-SQL, id)
                SELECT * FROM questions
                WHERE id = ?
            SQL

        return nil unless query.length > 0
        Question.new(query.first)
    end

    def initialize

end

class QuestionFollow
end

class Reply
end

class Like
end