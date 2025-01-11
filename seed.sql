-- Text to SQL original prompt:
-- Design a database schema for a chatbot application with the following features:
--
-- Tables:
--
-- chatbots: Stores chatbot details (ID, clerk user ID, name, created_at).
-- chatbot_characteristics: Links chatbots to their characteristics (ID, chatbot ID, content, created_at).
-- guests: Stores guest info (ID, name, email, created_at).
-- chat_sessions: Tracks guest-chatbot interactions (ID, chatbot ID, guest ID, created_at).
-- messages: Logs chat messages (ID, chat_session ID, content, sender, created_at).
-- Triggers:
--
-- A function (set_created_at) sets created_at to the current timestamp if not provided. Apply this to all tables.
-- Sample Data:
--
-- Add at least 3 chatbots (e.g., "Support Bot", "Sales Assistant Bot", "Technical Support Bot").
-- Add characteristics (e.g., "Available 24/7").
-- Add guests (e.g., "John Doe").
-- Add chat sessions and messages (e.g., guest queries and bot responses).
-- Provide SQL statements for tables, triggers, and sample data.
--
--
CREATE TABLE chatbots
(
    id            SERIAL PRIMARY KEY,
    clerk_user_id TEXT,
    name          TEXT NOT NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE chatbot_characteristics
(
    id         SERIAL PRIMARY KEY,
    chatbot_id INTEGER REFERENCES chatbots (id),
    content    TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE guests
(
    id         SERIAL PRIMARY KEY,
    name       TEXT NOT NULL,
    email      TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE chat_sessions
(
    id         SERIAL PRIMARY KEY,
    chatbot_id INTEGER REFERENCES chatbots (id),
    guest_id   INTEGER REFERENCES guests (id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE messages
(
    id              SERIAL PRIMARY KEY,
    chat_session_id INTEGER REFERENCES chat_sessions (id),
    content         TEXT NOT NULL,
    sender          TEXT NOT NULL,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION set_created_at()
    RETURNS TRIGGER AS
$$
BEGIN
    NEW.created_at = COALESCE(NEW.created_at, CURRENT_TIMESTAMP);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_created_at_chatbots
    BEFORE INSERT
    ON chatbots
    FOR EACH ROW
EXECUTE FUNCTION set_created_at();

CREATE TRIGGER set_created_at_chatbot_characteristics
    BEFORE INSERT
    ON chatbot_characteristics
    FOR EACH ROW
EXECUTE FUNCTION set_created_at();

CREATE TRIGGER set_created_at_guests
    BEFORE INSERT
    ON guests
    FOR EACH ROW
EXECUTE FUNCTION set_created_at();

CREATE TRIGGER set_created_at_chat_sessions
    BEFORE INSERT
    ON chat_sessions
    FOR EACH ROW
EXECUTE FUNCTION set_created_at();

CREATE TRIGGER set_created_at_messages
    BEFORE INSERT
    ON messages
    FOR EACH ROW
EXECUTE FUNCTION set_created_at();

INSERT INTO chatbots (clerk_user_id, name)
VALUES ('user_1', 'Support Bot'),
       ('user_2', 'Sales Assistant Bot'),
       ('user_3', 'Technical Support Bot');

INSERT INTO chatbot_characteristics (chatbot_id, content)
VALUES (1, 'Available 24/7'),
       (2, 'Specializes in product recommendations'),
       (3, 'Provides technical troubleshooting');

INSERT INTO guests (name, email)
VALUES ('John Doe', 'john@example.com'),
       ('Jane Smith', 'jane@example.com'),
       ('Bob Johnson', 'bob@example.com');

INSERT INTO chat_sessions (chatbot_id, guest_id)
VALUES (1, 1),
       (2, 2),
       (3, 3);

INSERT INTO messages (chat_session_id, content, sender)
VALUES (1, 'Hello, how can I help you today?', 'bot'),
       (1, 'I have a question about my order.', 'guest'),
       (2, 'Welcome! Are you looking for any specific products?', 'bot'),
       (2, 'Yes, I need help choosing a laptop.', 'guest'),
       (3, 'Hi there! What technical issue are you experiencing?', 'bot'),
       (3, 'My printer is not connecting to Wi-Fi.', 'guest');