DROP TABLE GDM_WEB.DataMartLoad;
create table GDM_WEB.DataMartLoad(
DataMartLoadID NUMBER(22,0) NOT NULL ,
DataMartLoadType VARCHAR(20) NOT NULL,
HasErrors VARCHAR(1),
StartTime DATE,
EndTime Date
 );  
 ALTER TABLE GDM_WEB.DataMartLoad ADD (
  CONSTRAINT DataMartLoad_pk PRIMARY KEY (DataMartLoadID));

CREATE SEQUENCE datamartload_seq START WITH 1;

CREATE OR REPLACE TRIGGER datamartload_bir 
BEFORE INSERT ON DataMartLoad 
FOR EACH ROW

BEGIN
  SELECT datamartload_seq.NEXTVAL
  INTO   :new.id
  FROM   dual;
END;



 DROP TABLE DataMartTable;
 create table GDM_WEB.DataMartTable(
DataMartTableID NUMBER(22,0) NOT NULL ,
Source VARCHAR(100) NOT NULL,
Destination VARCHAR(100) NOT NULL,
WhereClause VARCHAR(1000)  NULL,
COMMENTS  VARCHAR(1000)  NULL,
Disabled VARCHAR(1) NOT NULL
 ); 
 
  ALTER TABLE GDM_WEB.DataMartTable ADD (
  CONSTRAINT DataMartTable_pk PRIMARY KEY (DataMartTableID));

CREATE SEQUENCE datamarttable_seq START WITH 1;

CREATE OR REPLACE TRIGGER datamarttable_bir 
BEFORE INSERT ON DataMartTable 
FOR EACH ROW

BEGIN
  SELECT datamarttable_seq.NEXTVAL
  INTO   :new.id
  FROM   dual;
END;


  create table GDM_WEB.DataMartLoadTableStatus(
DataMartLoadID NUMBER(22,0) NOT NULL ,
DataMartTableID NUMBER(22,0) NOT NULL ,
StartDate Date,
EndDate Date,
ERRORMessage VARCHAR(4000) 
 ); 
 
 TRUNCATE TABLE   DataMartTable;
 INSERT INTO DataMartTable(DataMartTableID,SOURCE,Destination,WhereClause,Comments,Disabled)
 VALUES(1,'DIM_ANALYSIS','ANALYSIS',NULL,NULL,'N');
 INSERT INTO DataMartTable(DataMartTableID,SOURCE,Destination,WhereClause,Comments,Disabled)
 VALUES(2,'DIM_ANALYSIS_TRANS','ANALYSIS_TRANS',NULL,NULL,'N');
 INSERT INTO DataMartTable(DataMartTableID,SOURCE,Destination,WhereClause,Comments,Disabled)
 VALUES(3,'DIM_ANALYSIS_TYPES','ANALYSIS_TYPES',NULL,NULL,'N');
 SELECT * FROM datamarttable;