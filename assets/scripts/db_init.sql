CREATE TABLE User(
    id              TEXT        NOT NULL PRIMARY KEY,
    nickname        TEXT        NOT NULL,
    fullName        TEXT,
    deletedAt       TEXT,
    avatarId        TEXT,
    FOREIGN KEY(avatarId) REFERENCES Attach(id)
);

CREATE TABLE Post(
    id                  TEXT        NOT NULL PRIMARY KEY,
    text                TEXT,
    isCommentable       BOOLEAN     NOT NULL,
    likeCount           INTEGER     NOT NULL,
    commentCount        INTEGER     NOT NULL,
    createdAt           TEXT        NOT NULL,
    updatedAt           TEXT,
    authorId            TEXT        NOT NULL,
    popularCommentId    Text,
    FOREIGN KEY(authorId) REFERENCES User(id)
);

CREATE TABLE Attach(
    id              TEXT        NOT NULL PRIMARY KEY,
    name            TEXT        NOT NULL,
    size            INTEGER     NOT NULL,
    mimeType        TEXT        NOT NULL,
    postId          TEXT        NULL,
    FOREIGN KEY(postId) REFERENCES Post(id)
);

CREATE TABLE Comment(
    id              TEXT        NOT NULL PRIMARY KEY,
    text            TEXT        NOT NULL,
    likeCount       INTEGER     NOT NULL,
    createdAt       TEXT        NOT NULL,
    updatedAt       TEXT,
    postId          TEXT        NOT NULL,
    authorId        TEXT        NOT NULL,
    FOREIGN KEY(postId) REFERENCES Post(id),
    FOREIGN KEY(authorId) REFERENCES User(id)
);

CREATE TABLE Tag(
    id              TEXT        NOT NULL PRIMARY KEY,
    name            TEXT        NOT NULL,
    postCount       INTEGER     NOT NULL,
    followerCount   INTEGER     NOT NULL
);
