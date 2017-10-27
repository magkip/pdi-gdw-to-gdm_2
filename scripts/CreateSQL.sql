  DECLARE v_column_list varchar2(1000);
  v_sql varchar2(4000);
   v_sql2 varchar2(4000);
  TableID INTEGER;
  GDW_table varchar2(50);
  BEGIN
	  
  TableID :=0;
 FOR x IN (SELECT table_name FROM user_tables WHERE substr(table_name,1,1) <>'D' AND table_name <>'LANGUAGE'AND table_name <>'TEMPLATE_FIELD_TRANS' ORDER BY table_name)
 LOOP
 	TableID :=TableID +1; 
	SELECT   listagg(COLUMN_name,', ') within group(order by COLUMN_name)INTO v_column_list   
	FROM all_tab_columns 
	 WHERE table_name =x.table_name;
	 IF (x.table_name IN ('AUDIT_OPTION','CHECKLIST','CONCL_WEIGHT','CUSTOMER','CUSTOMER_MEANING','CUST_LIMS_SERVICE','ITEM_ISSUE','ITEM_OPTION','ENTITY_MEANING','FILE_TYPE','ITEM_FILE','LAB','LAB_TYPE','LANGUAGE','MEANING','PACKAGE','PRODUCT','PRODUCTS_PACKAGE','PROD_PACKAGE_FILTER','REPORT','SAMPLE_DETAIL','SERVICE','SITE','TEMPLATE','TEMPLATE_FIELD'))then
	 GDW_table:='DEV_GDW.GDW.DIM_'||x.table_name ||'S';
	ELSIF  (x.table_name IN ('AUDIT_CATEGORY','CATEGORY','ITEM_CATEGORY'))then
	 GDW_table:='DEV_GDW.GDW.DIM_'||REPLACE(x.table_name,'CATEGORY','CATEGORIES') ;
	 ELSIF  (x.table_name IN ('AUDITS'))THEN
	 GDW_table:='DEV_GDW.GDW.FACT_'||x.table_name;
	 ELSIF  (x.table_name IN ('RESULT','SAMPLE'))THEN
	 GDW_table:='DEV_GDW.GDW.FACT_'||x.table_name ||'S';
	  ELSIF  (x.table_name IN ('ITEM_VALUE'))THEN
	 GDW_table:='DEV_GDW.GDW.FACT_ITEMS_VALUES';
	   ELSIF  (x.table_name IN ('STATUS'))THEN
	 GDW_table:='DEV_GDW.GDW.DIM_STATUSES';
	   ELSIF  (x.table_name IN ('SAMPLE_DETAIL_TRANS'))THEN
	 GDW_table:='DEV_GDW.GDW.DIM_SAMPLE_DETAILS_TRANS';
	    ELSIF  (x.table_name IN ('ITEM_ENTRY','LIST_ENTRY'))THEN
	 GDW_table:='DEV_GDW.GDW.DIM_'||REPLACE(x.table_name,'ENTRY','ENTRIES') ;
	 	  ELSIF  (x.table_name IN ('ITEM_VALUE_TRANS'))THEN
	 GDW_table:='DEV_GDW.GDW.DIM_ITEM_VALUES_TRANS';
	  ELSIF  (x.table_name IN ('CUSTOMER_HIERARCHY','CUST_HIERARCHY_TRANS'))THEN
	 GDW_table:='DEV_GDW.GDW.DIM_'||REPLACE(x.table_name,'HIERARCHY','HIERARCHIES');
	   ELSIF  (x.table_name IN ('UNIT_TRANS','MEANING_TRANS','RESULT_TRANS'))THEN
	 GDW_table:='DEV_GDW.GDW.DIM_'||REPLACE(x.table_name,'_','S_');
	 ELSE 
	 	GDW_table:= 'DEV_GDW.GDW.DIM_'||x.table_name;
	 END IF;
	 IF (x.table_name='CUSTOMER')THEN
	 	v_column_list:=REPLACE(v_column_list,'MAX_DAYS_DATA_RETAINED,','');
	 END IF;
	 IF (x.table_name='CONCL_WEIGHT')THEN
	 	v_column_list:=REPLACE(v_column_list,'CONCL_WEIGHT_ID','WEIGHT_ID');
	 END IF;
	  IF (x.table_name='AUDITS')THEN
	 	v_column_list:=REPLACE(v_column_list,'ORDER_ID','SOURCE_ORDER_ID');
	 END IF;
	   IF (x.table_name='ITEM_CATEGORY' )THEN
	 	v_column_list:=REPLACE(v_column_list,'REFRESH_DATE,','');
	 END IF;
	   IF (x.table_name='ITEM_VALUE_TRANS' )THEN
	 	v_column_list:=REPLACE(v_column_list,'REFRESH_DATE,','');
	 END IF;
	    IF (x.table_name='ITEM_FILE')THEN
	 	v_column_list:=REPLACE(v_column_list,'FILE_CONTENT,','');
	 END IF;
	  IF (x.table_name='SAMPLE')THEN
	 	v_column_list:=REPLACE(v_column_list,'WEB_LOGIN_NUMBER,','');
	 END IF;
	   IF (x.table_name='RESULT')THEN
	 	v_column_list:=REPLACE(REPLACE(v_column_list,'AL_REPORT_ID,',''),'COA_NUMBER,','');
	 END IF;
	 
	 v_sql2:='SELECT '||v_column_list || ' FROM '|| GDW_table || ' limit 10;';
	v_sql :='INSERT INTO GDM_WEB.DataMartTable (DataMartTableid,source,destination,sqlstatement,disabled) VALUES (';
	v_sql := v_sql || TableID ||','||''''|| GDW_table ||''''||','||''''||x.table_name||''''||','||''''||v_sql2||''''||','||''''||'N'||''''||');';
	 --dbms_output.put_line(v_sql2); 
	 dbms_output.put_line(v_sql); 
	--dbms_output.put_line(GDW_table);
 	v_sql :='';
	 END LOOP;
 END;
 