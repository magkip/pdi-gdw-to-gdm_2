--Creates the tables for PDI database logging

CREATE TABLE CTL.GDW_PDI_TRANSFORMATION_LOG
(
  ID_BATCH INT
, CHANNEL_ID VARCHAR
, TRANSNAME VARCHAR
, STATUS VARCHAR
, LINES_READ INT
, LINES_WRITTEN INT
, LINES_UPDATED INT
, LINES_INPUT INT
, LINES_OUTPUT INT
, LINES_REJECTED INT
, ERRORS INT
, STARTDATE DATETIME
, ENDDATE DATETIME
, LOGDATE DATETIME
, DEPDATE DATETIME
, REPLAYDATE DATETIME
)
;

CREATE TABLE CTL.GDW_PDI_JOB_LOG
(
  ID_JOB INT
, CHANNEL_ID VARCHAR
, JOBNAME VARCHAR
, STATUS VARCHAR
, LINES_READ INT
, LINES_WRITTEN INT
, LINES_UPDATED INT
, LINES_INPUT INT
, LINES_OUTPUT INT
, LINES_REJECTED INT
, ERRORS INT
, STARTDATE DATETIME
, ENDDATE DATETIME
, LOGDATE DATETIME
, DEPDATE DATETIME
, REPLAYDATE DATETIME
)
;