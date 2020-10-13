CREATE TABLE Mappings (
  WrongWord VARCHAR(255),
  CorrectWord VARCHAR(255),
  
  -- Indexes / Constraints:
  UNIQUE (WrongWord, CorrectWord),
  INDEX (WrongWord)
)
