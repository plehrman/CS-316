----------------------------------------------------------------------
-- (a) & (b) Modify the CREATE TABLE statements as needed to add
-- constraints.  Do not otherwise change the column names or types.

CREATE TABLE Person
(ssn DECIMAL(10,0) NOT NULL PRIMARY KEY, -- Social Security Number is primary key.
 name VARCHAR(256) NOT NULL,
 address VARCHAR(256) NOT NULL);

CREATE TABLE Broker
(ssn DECIMAL(10,0) NOT NULL PRIMARY KEY -- SSN is a primary key.
    REFERENCES Person(ssn), -- SSN is a foreign key.
 license VARCHAR(20) NOT NULL,
 phone DECIMAL(10,0) NOT NULL,
 manager DECIMAL(10,0)
    REFERENCES Broker(ssn));

CREATE TABLE Account
(aid INTEGER NOT NULL PRIMARY KEY, -- Account ID is primary key
 brokerssn DECIMAL(10,0) NOT NULL
    REFERENCES Broker(ssn));

CREATE TABLE Owns
(ssn DECIMAL(10,0) NOT NULL
    REFERENCES Person(ssn), -- SSN is a foreign key.
 aid INTEGER NOT NULL 
    REFERENCES Account(aid), -- AID is a foreign key.
    PRIMARY KEY(ssn,aid)); -- SSN and AID are primary keys. 

CREATE TABLE Stock
(sym CHAR(5) NOT NULL PRIMARY KEY, -- SYM is primary key.
 price DECIMAL(10,2) NOT NULL);

CREATE TABLE Trade
(aid INTEGER NOT NULL
    REFERENCES Account(aid), -- AID is a foreing key in the relationship.
 seq INTEGER NOT NULL,
    PRIMARY KEY(aid,seq), -- SEQ and AID are primary keys in the relationship.
 type CHAR(4) NOT NULL
    CHECK (type = 'buy' OR type = 'sell'),
 timestamp TIMESTAMP NOT NULL,
 sym CHAR(5) NOT NULL
    REFERENCES Stock(sym),
 shares DECIMAL(10,2) NOT NULL,
 price DECIMAL(10,2) NOT NULL);

----------------------------------------------------------------------
-- (c) There is no room for mistakes at PITS. Since PITS records only
-- completed trades, enforce that the Trade table is append-only
-- (i.e., no DELETE or UPDATE is allowed) using a trigger. Further
-- enforce that within each account, trades must be recorded
-- sequentially over time: i.e., compared with old trades in the same
-- account, a new trade must have a seq that is strictly larger, and a
-- timestamp that is no less than the old values.

CREATE FUNCTION TF_TradeSeqAppendOnly() RETURNS TRIGGER AS $$
BEGIN
  -- YOUR IMPLEMENTATION GOES HERE >>>
  -- Do not modify the CREATE TRIGGER statement that follows.
  IF TG_OP = 'UPDATE' OR TG_OP = 'DELETE' THEN
        RAISE EXCEPTION 'Update or delete operations are not allowed.';
  END IF;

  IF NEW.seq < COALESCE((SELECT MAX(seq) FROM Trade WHERE aid = NEW.aid), 0) THEN
    RAISE EXCEPTION 'Sequence number must be greater than the maximum for the same account.';
  END IF;

-- Check if the new timestamp is older than the maximum timestamp for the same account (aid).
  IF NEW.timestamp < COALESCE((SELECT MAX(timestamp) FROM Trade WHERE aid = NEW.aid), 'epoch'::timestamp) THEN
    RAISE EXCEPTION 'Timestamp must be older than the maximum for the same account.';
  END IF;

  RETURN NEW;
  -- <<< YOUR IMPLEMENTATION ENDS HERE
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TG_TradeSeqAppendOnly
  BEFORE INSERT OR UPDATE OR DELETE ON Trade
  FOR EACH ROW
  EXECUTE PROCEDURE TF_TradeSeqAppendOnly();

----------------------------------------------------------------------
-- (d) Using triggers, enforce that brokers cannot own accounts,
-- either by themselves or jointly with others.

CREATE FUNCTION TF_BrokerNotAccountOwner() RETURNS TRIGGER AS $$
BEGIN
  -- YOUR IMPLEMENTATION GOES HERE >>>
  -- Do not modify the CREATE TRIGGER statements that follow.
  IF TG_TABLE_NAME = 'owns' AND NEW.ssn IN (SELECT ssn FROM Broker) THEN
      RAISE EXCEPTION 'Brokers cannot own accounts.';
  END IF;

  IF TG_TABLE_NAME = 'broker' AND NEW.ssn IN (SELECT ssn FROM Owns) THEN
      RAISE EXCEPTION 'Brokers cannot own accounts.';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TG_BrokerNotAccountOwner_Broker
  BEFORE INSERT OR UPDATE OF ssn ON Broker
  -- note that DELETE won't cause a violation
  FOR EACH ROW
  EXECUTE PROCEDURE TF_BrokerNotAccountOwner();

CREATE TRIGGER TG_BrokerNotAccountOwner_Owns
  BEFORE INSERT OR UPDATE OF ssn ON Owns
  -- note that DELETE won't cause a violation
  FOR EACH ROW
  EXECUTE PROCEDURE TF_BrokerNotAccountOwner();

----------------------------------------------------------------------
-- (e) Define a view Holds (aid, sym, amount) that returns the current
-- account holdings, computed from the Trade table. You may assume
-- that all accounts start with holding nothing and all transactions
-- are recorded in Trade.

CREATE VIEW Holds(aid, sym, shares) AS
  SELECT t.aid, 
         t.sym, 
         SUM(CASE WHEN t.type = 'buy' THEN t.shares ELSE -t.shares END)
  FROM Trade t
  GROUP BY t.aid, t.sym;
  
  -- YOUR IMPLEMENTATION GOES HERE >>>
  -- Do not modify the CREATE FUNCTION and TRIGGER statements that follow.
  -- Stub implementation (incorrect):
  -- SELECT DISTINCT aid, sym, 10000.00
  -- FROM Account, Stock;
  -- <<< YOUR IMPLEMENTATION ENDS HERE

CREATE FUNCTION TF_NoOverSell() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.type = 'sell' AND
     NEW.shares > COALESCE((SELECT shares FROM Holds WHERE aid = NEW.aid AND sym = NEW.sym), 0) THEN
    RAISE EXCEPTION 'cannot sell more than the number of % shares currently held',
                    NEW.sym;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TG_NoOverSell
  BEFORE INSERT ON Trade
  FOR EACH ROW
  EXECUTE PROCEDURE TF_NoOverSell();
