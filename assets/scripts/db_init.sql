CREATE TABLE User(
    id              TEXT        NOT NULL PRIMARY KEY,
    nickname        TEXT        NOT NULL,
    fullName        TEXT,
    deletedAt       TEXT,
    avatarId        TEXT,
    about           TEXT,
    avatarLink      TEXT,
    isFollowing     BOOLEAN,
    followerCount   INTEGER,
    followingCount  INTEGER,
    postCount       INTEGER,
    createdAt       TEXT,
    updatedAt       TEXT,
    FOREIGN KEY(avatarId) REFERENCES Attach(id)
);

CREATE TABLE Post(
    id                  TEXT        NOT NULL PRIMARY KEY,
    text                TEXT,
    isCommentable       BOOLEAN     NOT NULL,
    likeCount           INTEGER     NOT NULL,
    commentCount        INTEGER     NOT NULL,
    isLiked             BOOLEAN     NOT NULL,
    isPersonal          BOOLEAN     NOT NULL,
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
    link            TEXT        NOT NULL,
    mimeType        TEXT        NOT NULL,
    postId          TEXT        NULL,
    FOREIGN KEY(postId) REFERENCES Post(id)
);

CREATE TABLE Comment(
    id              TEXT        NOT NULL PRIMARY KEY,
    text            TEXT        NOT NULL,
    likeCount       INTEGER     NOT NULL,
    isLiked         BOOLEAN     NOT NULL,
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
    followerCount   INTEGER     NOT NULL,
    isFollowed      BOOLEAN     NOT NULL
);

CREATE TABLE Notification(
    id                  TEXT        NOT NULL PRIMARY KEY,
    title               TEXT        NOT NULL,
    subTitle            TEXT,
    body                TEXT,
    fromUserId          TEXT,
    toUserId            TEXT        NOT NULL,
    notificationType    INTEGER     NOT NULL,
    viewedAt            TEXT,
    createdAt           TEXT        NOT NULL,
    FOREIGN KEY(toUserId) REFERENCES User(id),
    FOREIGN KEY(fromUserId) REFERENCES User(id)
);