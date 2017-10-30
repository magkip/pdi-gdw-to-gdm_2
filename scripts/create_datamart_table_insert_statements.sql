DECLARE
    v_column_list VARCHAR2(1000);
    v_sql         VARCHAR2(4000);
    v_sql2        VARCHAR2(4000);
    tableid       INTEGER;
    gdw_table     VARCHAR2(50);
BEGIN
    tableid := 0;

    FOR x IN (SELECT table_name
              FROM   user_tables
              WHERE  Substr(table_name, 1, 8) <> 'DATAMART'
              ORDER  BY table_name) LOOP
        tableid := tableid + 1;

        SELECT Listagg(column_name, ', ')
                 within GROUP(ORDER BY column_name)
        INTO   v_column_list
        FROM   all_tab_columns
        WHERE  table_name = x.table_name;

        IF ( x.table_name IN ( 'AUDIT_OPTION', 'CHECKLIST', 'CONCL_WEIGHT',
                               'CUSTOMER',
                               'CUSTOMER_MEANING', 'CUST_LIMS_SERVICE',
                               'ITEM_ISSUE'
                               ,
                                    'ITEM_OPTION',
                               'ENTITY_MEANING', 'FILE_TYPE', 'ITEM_FILE', 'LAB'
                               ,
                               'LAB_TYPE', 'LANGUAGE', 'MEANING', 'PACKAGE',
                               'PRODUCT', 'PRODUCTS_PACKAGE',
                               'PROD_PACKAGE_FILTER',
                                  'REPORT'
                                    ,
                               'SAMPLE_DETAIL', 'SERVICE', 'SITE', 'TEMPLATE',
                                    'TEMPLATE_FIELD' ) )THEN
          gdw_table := 'DEV_GDW.GDW.DIM_'
                       ||x.table_name
                       ||'S';
        ELSIF ( x.table_name IN ( 'AUDIT_CATEGORY', 'CATEGORY', 'ITEM_CATEGORY'
                                ) )
        THEN
          gdw_table := 'DEV_GDW.GDW.DIM_'
                       ||Replace(x.table_name, 'CATEGORY', 'CATEGORIES');
        ELSIF ( x.table_name IN ( 'AUDITS' ) )THEN
          gdw_table := 'DEV_GDW.GDW.FACT_'
                       ||x.table_name;
        ELSIF ( x.table_name IN ( 'RESULT', 'SAMPLE' ) )THEN
          gdw_table := 'DEV_GDW.GDW.FACT_'
                       ||x.table_name
                       ||'S';
        ELSIF ( x.table_name IN ( 'ITEM_VALUE' ) )THEN
          gdw_table := 'DEV_GDW.GDW.FACT_ITEMS_VALUES';
        ELSIF ( x.table_name IN ( 'STATUS' ) )THEN
          gdw_table := 'DEV_GDW.GDW.DIM_STATUSES';
        ELSIF ( x.table_name IN ( 'SAMPLE_DETAIL_TRANS' ) )THEN
          gdw_table := 'DEV_GDW.GDW.DIM_SAMPLE_DETAILS_TRANS';
        ELSIF ( x.table_name IN ( 'ITEM_ENTRY', 'LIST_ENTRY' ) )THEN
          gdw_table := 'DEV_GDW.GDW.DIM_'
                       ||Replace(x.table_name, 'ENTRY', 'ENTRIES');
        ELSIF ( x.table_name IN ( 'ITEM_VALUE_TRANS' ) )THEN
          gdw_table := 'DEV_GDW.GDW.DIM_ITEM_VALUES_TRANS';
        ELSIF ( x.table_name IN ( 'CUSTOMER_HIERARCHY', 'CUST_HIERARCHY_TRANS' )
              )
        THEN
          gdw_table := 'DEV_GDW.GDW.DIM_'
                       ||Replace(x.table_name, 'HIERARCHY', 'HIERARCHIES');
        ELSIF ( x.table_name IN ( 'UNIT_TRANS', 'MEANING_TRANS', 'RESULT_TRANS'
                                ) )
        THEN
          gdw_table := 'DEV_GDW.GDW.DIM_'
                       ||Replace(x.table_name, '_', 'S_');
        ELSE
          gdw_table := 'DEV_GDW.GDW.DIM_'
                       ||x.table_name;
        END IF;

        IF ( x.table_name = 'CUSTOMER' )THEN
          v_column_list := Replace(v_column_list, 'MAX_DAYS_DATA_RETAINED,', '')
          ;
        END IF;

        IF ( x.table_name = 'CONCL_WEIGHT' )THEN
          v_column_list := Replace(v_column_list, 'CONCL_WEIGHT_ID',
                           'WEIGHT_ID AS CONCL_WEIGHT_ID');
        END IF;

        IF ( x.table_name = 'AUDITS' )THEN
          v_column_list := Replace(v_column_list, 'ORDER_ID',
                           'SOURCE_ORDER_ID AS ORDER_ID');
        END IF;

        IF ( x.table_name = 'ITEM_CATEGORY' )THEN
          v_column_list := Replace(v_column_list, 'REFRESH_DATE,', '');
        END IF;

        IF ( x.table_name = 'ITEM_VALUE_TRANS' )THEN
          v_column_list := Replace(v_column_list, 'REFRESH_DATE,', '');
        END IF;

        IF ( x.table_name = 'ITEM_FILE' )THEN
          v_column_list := Replace(v_column_list, 'FILE_CONTENT,', '');
        END IF;

        IF ( x.table_name = 'SAMPLE' )THEN
          v_column_list := Replace(v_column_list, 'WEB_LOGIN_NUMBER,', '');
        END IF;

        IF ( x.table_name = 'RESULT' )THEN
          v_column_list := Replace(Replace(v_column_list, 'AL_REPORT_ID,', ''),
                           'COA_NUMBER,', '');
        END IF;

		v_sql2:='SELECT '||v_column_list || ' FROM '|| GDW_table ;
	v_sql :='INSERT INTO GDM_WEB.DataMart_Table (source,destination,sqlstatement,disabled,loadgroup) VALUES (';
	v_sql := v_sql ||''''|| GDW_table ||''''||','||''''||x.table_name||''''||','||''''||v_sql2||''''||','||''''||'N'||''''|| ','|| TO_CHAR(MOD(tableid,4)+1) ||');';
	 --dbms_output.put_line(v_sql2); 
	 dbms_output.put_line(v_sql); 
	--dbms_output.put_line(GDW_table);
 	v_sql :='';
	 END LOOP;
 END;