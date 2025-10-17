-- 实体表
CREATE TABLE Clubs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    details TEXT
);

CREATE TABLE Players (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    details TEXT
);

CREATE TABLE Tournaments (
    code VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    details TEXT
);

CREATE TABLE Sponsors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    sponsor_type VARCHAR(50),
    details TEXT
);


--关系表
CREATE TABLE Members (
    id INT PRIMARY KEY AUTO_INCREMENT,
    club_id INT NOT NULL,
    player_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    details TEXT
    FOREIGN KEY (club_id) REFERENCES Clubs(id),
    FOREIGN KEY (player_id) REFERENCES Players(id)
);

CREATE TABLE Matches (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tournament_code VARCHAR(50) NOT NULL,
    round VARCHAR(50),
    player_id_1 INT NOT NULL,
    player_id_2 INT NOT NULL,
    result VARCHAR(20),
    time TIMESTAMP,
    details TEXT,
    FOREIGN KEY (tournament_code) REFERENCES Tournaments(code),
    FOREIGN KEY (player_id_1) REFERENCES Players(id),
    FOREIGN KEY (player_id_2) REFERENCES Players(id),
    CHECK (player_id_1 <> player_id_2)
);


CREATE TABLE Tournament_Sponsors_Relation (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tournament_code VARCHAR(50) NOT NULL,
    sponsor_id INT NOT NULL,
    FOREIGN KEY (tournament_code) REFERENCES Tournaments(code),
    FOREIGN KEY (sponsor_id) REFERENCES Sponsors(id)
);

CREATE TABLE Tournaments_Host_Relation (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tournament_code VARCHAR(50) NOT NULL,
    club_id INT NOT NULL,
    FOREIGN KEY (tournament_code) REFERENCES Tournaments(code),
    FOREIGN KEY (club_id) REFERENCES Clubs(id)
);

CREATE TABLE Tournament_Participants_Relation (
    tournament_code VARCHAR(50) NOT NULL,
    player_id INT NOT NULL,
    rank INT,
    PRIMARY KEY (tournament_code, player_id),
    FOREIGN KEY (tournament_code) REFERENCES Tournaments(code),
    FOREIGN KEY (player_id) REFERENCES Players(id)
);

