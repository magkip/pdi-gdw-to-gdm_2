DROP TABLE GDM_WEB.DataMart_Load;
DROP SEQUENCE datamartload_seq;
DROP TABLE GDM_WEB.DataMart_Table;
DROP SEQUENCE datamarttable_seq;
DROP TABLE GDM_WEB.DataMart_LoadStatus;

CREATE SEQUENCE datamartload_seq START WITH 1;

CREATE table GDM_WEB.DataMart_Load(
DataMart_LoadID NUMBER(22,0) NOT NULL ,
DataMart_LoadType VARCHAR(20) NOT NULL,
HasErrors VARCHAR(1),
StartTime DATE DEFAULT SYSDATE,
EndTime Date
 );  
 
 ALTER TABLE GDM_WEB.DataMart_Load ADD (
  CONSTRAINT DataMartLoad_pk PRIMARY KEY (DataMart_LoadID));



CREATE OR REPLACE TRIGGER datamartload_bir 
BEFORE INSERT ON DataMart_Load 
FOR EACH ROW

BEGIN
  SELECT datamartload_seq.NEXTVAL
  INTO   :NEW.DataMart_LoadID
  FROM   dual;
END;

CREATE SEQUENCE datamarttable_seq START WITH 1;
 
CREATE  TABLE GDM_WEB.DataMart_Table(
DataMart_TableID NUMBER(22,0)  NOT NULL ,
Source VARCHAR(100) NOT NULL,
Destination VARCHAR(100) NOT NULL,
SQLStatement VARCHAR(4000) NOT NULL,
WhereClause VARCHAR(1000)  NULL,
Comments VARCHAR(1000)  NULL,
Disabled CHAR(1) DEFAULT 'N' ,
LoadGroup SMALLINT,
LoadOrder SMALLINT
 ); 
 
 ALTER TABLE GDM_WEB.DataMart_Table ADD (
  CONSTRAINT DataMartTable_pk PRIMARY KEY (DataMart_TableID));
 
  


CREATE OR REPLACE TRIGGER datamarttable_bir 
BEFORE INSERT ON DataMart_Table 
FOR EACH ROW

BEGIN
  SELECT datamarttable_seq.NEXTVAL
  INTO   :NEW.DataMart_TableID
  FROM   dual;
END;

CREATE   table GDM_WEB.DataMart_LoadTableStatus(
DataMart_LoadID NUMBER(22,0) NOT NULL ,
DataMart_TableID NUMBER(22,0) NOT NULL ,
StartDate Date,
EndDate Date,
ErrorMessage VARCHAR(4000) 
 ); 
