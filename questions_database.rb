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

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM users")
        data.map { |datum| User.new(datum) }
    end

    def self.find_by_name(fname,lname)
        QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
            SELECT * FROM users
            WHERE fname = ? AND lname = ?
        SQL
    end


    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end
    
    def authored_questions
        Question.find_by_author_id(self.id)
    end

    def authored_replies
        Reply.find_by_user_id(self.id)
    end

    def followed_questions 
        QuestionFollow.followed_questions_for_user_id(self.id)
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

    def self.find_by_author_id(author_id)
        QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT * FROM questions
            WHERE author_id = ?
        SQL
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

    def author
        User.find_by_id(self.author_id)
    end

    def replies
        Reply.find_by_question_id(self.id)
    end

    def followers 
        QuestionFollow.followers_for_question_id(self.id)
    end 

end

class QuestionFollow
    attr_accessor :id,:user_id,:question_id
        def self.all
            data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows")
            data.map { |datum| QuestionFollow.new(datum) }
        end

        def self.find_by_id(id)
        query = QuestionsDatabase.instance.execute(<<-SQL, id)
                SELECT * FROM question_follows
                WHERE id = ?
            SQL

        return nil unless query.length > 0
        QuestionFollow.new(query.first)
    end

    def self.followers_for_question_id(question_id)
        QuestionsDatabase.instance.execute(<<-SQL, question_id)
                SELECT * FROM users u
                JOIN question_follows q
                ON q.user_id = u.id
                WHERE question_id = ?
            SQL
    end

    def self.followed_questions_for_user_id(user_id)
            QuestionsDatabase.instance.execute(<<-SQL, user_id)
                SELECT * FROM questions q
                JOIN question_follows qf
                ON q.question_id = qf.id
                WHERE user_id = ?
            SQL
    end



    def initialize(options)
        @id = options['id']
        @user_id = options['user_id']
        @question_id = options['question_id']
    end



end

class Reply
    attr_accessor :id,:question_id,:parent_reply_id,:author_id,:body
        def self.find_by_id(id)
        query = QuestionsDatabase.instance.execute(<<-SQL, id)
                SELECT * FROM replies
                WHERE id = ?
            SQL

        return nil unless query.length > 0
        Reply.new(query.first)
    end

    def self.find_by_user_id(user_id)
        QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT * FROM replies
            WHERE user_id = ?
        SQL
    end

    def self.find_by_question_id(question_id)
        QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT * FROM replies
            WHERE question_id = ?
        SQL
    end

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
        data.map { |datum| Reply.new(datum) }
    end

    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_reply_id = options['parent_reply_id']
        @author_id = options['author_id']
        @body = options['body']
    end

    def author
        User.find_by_id(self.author_id)
    end

    def question
        Question.find_by_id(self.question_id)
    end

    def parent_reply 
        if self.parent_reply_id == nil
            raise "Current reply is the parent"
        end
        Reply.find_by_id(self.parent_reply_id)
    end

    def child_replies
        QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * FROM replies
            WHERE parent_reply_id = ?
        SQL
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