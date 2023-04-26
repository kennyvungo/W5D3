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
    attr_accessor :id,:fname,:lname
    def self.find_by_id(id)
        query = QuestionsDatabase.instance.execute(<<-SQL, id)
                SELECT * FROM users
                WHERE id = ?
            SQL

        return nil unless query.length > 0
        User.new(query.first)
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end
end

class Question
    attr_accessor :id,:title,:body,:author_id
    def self.find_by_id(id)
        query = QuestionsDatabase.instance.execute(<<-SQL, id)
                SELECT * FROM questions
                WHERE id = ?
            SQL

        return nil unless query.length > 0
        Question.new(query.first)
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

end

class QuestionFollow
    attr_accessor :id,:user_id,:question_id
        def self.find_by_id(id)
        query = QuestionsDatabase.instance.execute(<<-SQL, id)
                SELECT * FROM question_follows
                WHERE id = ?
            SQL

        return nil unless query.length > 0
        QuestionFollow.new(query.first)
    end

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end
end

class Reply
    :id,:question_id,:parent_reply_id,:author_id,:body
        def self.find_by_id(id)
        query = QuestionsDatabase.instance.execute(<<-SQL, id)
                SELECT * FROM replies
                WHERE id = ?
            SQL

        return nil unless query.length > 0
        Reply.new(query.first)
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_reply_id = options['parent_reply_id']
        @author_id = options['author_id']
        @body = options['body']
        
    end
end

class Like
    attr_accessor :id,:user_id,:question_id
        def self.find_by_id(id)
        query = QuestionsDatabase.instance.execute(<<-SQL, id)
                SELECT * FROM question_likes
                WHERE id = ?
            SQL

        return nil unless query.length > 0
        Like.new(query.first)
    end

    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end
end