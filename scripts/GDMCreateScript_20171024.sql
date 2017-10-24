--spool generate_table.lst 
--set serveroutput on size 1000000 
declare 
startingpk boolean :=true;
pkcolumns varchar2(500):='';
ukcolumns varchar2(500):='';
starting boolean :=true; 
r_owner varchar2(30) := 'GDM_WEB'; 
r_table_name varchar2(30) := '';
BEGIN
	FOR x IN (SELECT t.table_name
			from user_tables t
			where t.TABLE_NAME not like '_$\_%' Escape '\'
			and t.TABLE_NAME not like 'ASYNC\_%' Escape '\'
			and t.TABLE_NAME not like 'AU\_%' Escape '\'
			and t.TABLE_NAME not like 'TEMP\_%' Escape '\'
			and t.TABLE_NAME not like 'WEB\_%' Escape '\'
			and t.TABLE_NAME not like 'S\_%' Escape '\'
			and NOT REGEXP_LIKE(t.TABLE_NAME , '[[:digit:]]')
			and t.TABLE_NAME not in ('MXNS_ESTAR_USER_IMPORT','MXNS_LOAD_LOG','MXNS_USER_SESSIONS','APPLICATION_STATUS','SNP_CHECK_TAB')
			and t.TABLE_NAME not in ('AUDIT_REPORTS','CHECKLIST_TRANS_BKP','CONCL_LEVEL','COUNTRY',
			'CUST_SERVICE','SERVICE_FAMILY','SOURCE_INSTANCE','ITEM_TRANS_BKP','ACCREDITATION')
			--AND SUBSTR(t.table_name,1,1) ='A'
			--AND t.table_name = 'UNIT_TRANS'
			ORDER BY t.table_name
	)
	loop
 			
		r_table_name :=x.table_name;
		begin 
		--	dbms_output.put_line('drop table '||r_owner||'.'||r_table_name||';');
			dbms_output.put_line('create table '||r_owner||'.'||r_table_name||'('); 
			starting:=TRUE;
			for r in (select column_name, data_type, data_length, data_precision, data_scale, data_default, nullable 
					from all_tab_columns 
					where table_name = upper(r_table_name) 
					--and owner=upper(r_owner) 
					order by column_id) 
					loop 
					if starting then 
					starting:=false; 
					else 
					dbms_output.put_line(','); 
					end if; 
		
			if r.data_type='NUMBER' then 
				if r.data_scale is null then 
					dbms_output.put(r.column_name||' NUMBER('||r.data_precision||')'); 
				else 
					dbms_output.put(r.column_name||' NUMBER('||r.data_precision||','||r.data_scale||')'); 
				end if; 
			else if r.data_type = 'DATE' then 
				dbms_output.put_line(r.column_name||' DATE'); 
			else if instr(r.data_type, 'CHAR') >0 then 
				dbms_output.put(r.column_name||' '||r.data_type||'('||r.data_length/4||')'); 
			else 
				dbms_output.put(r.column_name||' '||r.data_type); 
			end if; 
		end if; 
		end if; 
		if r.data_default is not null then 
			dbms_output.put(' DEFAULT '||r.data_default); 
		end if; 
		if r.nullable = 'N' then 
			dbms_output.put(' NOT NULL '); 
			end if; 
		end loop; 
		
	pkcolumns:='';
	startingpk:=TRUE;
			for pk in (select constraint_name from user_constraints where table_name = upper(r_table_name) AND constraint_type ='P') 
					loop 
					if startingpk then 
					startingpk:=false; 
					else 
					dbms_output.put_line(','); 
					end if;
					FOR col1 IN (SELECT  DISTINCT column_name ,MAX(position) FROM all_cons_columns WHERE constraint_name =pk.constraint_name GROUP BY column_name ORDER BY MAX(position) )
					LOOP
					pkcolumns:= pkcolumns || col1.column_name ||',';
					END LOOP;
					pkcolumns:=SUBSTR(pkcolumns,1,LENGTH(pkcolumns)-1);
					dbms_output.put_line (',');
					dbms_output.put_line('CONSTRAINT ' ||pk.constraint_name ||' PRIMARY KEY (' || pkcolumns||')'); 
			END LOOP;
		/*		pkcolumns:='';
			startingpk:=TRUE;
			for ck in (select constraint_name, search_condition from user_constraints where table_name = upper(r_table_name) AND constraint_type ='C') 
				loop 
					if startingpk then 
					startingpk:=false; 
					else 
					dbms_output.put_line(','); 
					end if;
					dbms_output.put_line('CONSTRAINT ' ||ck.constraint_name ||' CHECK  (' || ck.search_condition||')'); 
			END LOOP;
			
			
		dbms_output.put_line(' ); '); 
		
		ukcolumns:='';
			for uk in (select index_name, table_name from user_indexes where table_name = upper(r_table_name) ) 
				loop 
				
				
					ukcolumns:='';
					FOR col3 IN (SELECT index_name, table_name,column_name FROM all_ind_columns WHERE index_name =uk.index_name  )
						
					LOOP
					ukcolumns:= ukcolumns || col3.column_name ||',';
					END LOOP;
					if (LENGTH(ukcolumns)>=1) then
					ukcolumns:=SUBSTR(ukcolumns,1,LENGTH(ukcolumns)-1);
					end if;
					dbms_output.put_line('CREATE UNIQUE INDEX ' ||uk.index_name ||' ON ' ||uk.table_name ||' (' ||ukcolumns ||');'); 
					  
			END LOOP;
			*/
		
		dbms_output.put_line(' );  '); 
		end; 
		END LOOP;
		
		dbms_output.put_line('   '); 
		dbms_output.put_line(' --- DROPPING AND CREATING SEQUENCES.  None yet. '); 
		dbms_output.put_line('   '); 
		
 END;

 
