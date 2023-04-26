-- Note from project:
-- If you drop a table that is referenced by a foreign key in another table, you 
-- will get an error telling you that you've violated the foreign key constraint.

-- moved users to end but idk if anything else will break

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;


CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
);


CREATE TABLE question_follows(
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)

);


CREATE TABLE replies(
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    parent_reply_id INTEGER,
    body TEXT NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id)

);



CREATE TABLE question_likes(
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    like_bool BOOLEAN,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);



CREATE TABLE users(
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

-- primary keys get populated automatically
INSERT INTO 
    users (fname, lname)
VALUES
    ('Lauren','Armstrong'),
    ('Kenny','Ngo'),
    ('Paulo','Bocanegra');

INSERT INTO
    questions (title, body, user_id)
VALUES
    ('Lauren Question','What does the fox say?', 1),
    ('Paulo Question','Did everyone do the practice assessment more than 10 times?', 3);

INSERT INTO replies
    (user_id, question_id, parent_reply_id, body)
VALUES
    (1,2,NULL,'ofc');

    