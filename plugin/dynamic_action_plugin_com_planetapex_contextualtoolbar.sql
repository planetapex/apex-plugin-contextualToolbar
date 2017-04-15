set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050000 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2013.01.01'
,p_release=>'5.0.3.00.03'
,p_default_workspace_id=>1301105260114689
,p_default_application_id=>104
,p_default_owner=>'SCOTT'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/dynamic_action/com_planetapex_contextualtoolbar
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(28269873535651867)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'COM.PLANETAPEX.CONTEXTUALTOOLBAR'
,p_display_name=>'Contextual Toolbar'
,p_category=>'NAVIGATION'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_plsql_code=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'  g_default_separator constant varchar2(1) := '';'';',
'',
'  g_max_pl_varchar2_def varchar2(32767);',
'',
'  subtype t_max_pl_varchar2 is g_max_pl_varchar2_def%type;',
'',
'  g_icon_col constant number(1) := 1;',
'',
'  g_value_col constant number(1) := 2;',
'',
'  g_title_col constant number(1) := 3;',
'',
'  function get_nth_token(p_text in varchar2, p_num in number, p_separator in varchar2 := g_default_separator)',
'    return varchar2 as',
'    l_pos_begin pls_integer;',
'    l_pos_end pls_integer;',
'    l_returnvalue t_max_pl_varchar2;',
'  begin',
'    if p_num <= 0 then',
'      return null;',
'    elsif p_num = 1 then',
'      l_pos_begin := 1;',
'    else',
'      l_pos_begin := instr(p_text, p_separator, 1, p_num - 1);',
'    end if;',
'    -- separator may be the first character',
'    l_pos_end := instr(p_text, p_separator, 1, p_num);',
'    if l_pos_end > 1 then',
'      l_pos_end := l_pos_end - 1;',
'    end if;',
'    if l_pos_begin > 0 then',
'      -- find the last element even though it may not be terminated by separator',
'      if l_pos_end <= 0 then',
'        l_pos_end := length(p_text);',
'      end if;',
'      -- do not include separator character in output',
'      if p_num = 1 then',
'        l_returnvalue := substr(p_text, l_pos_begin, l_pos_end - l_pos_begin + 1);',
'      else',
'        l_returnvalue := substr(p_text, l_pos_begin + 1, l_pos_end -',
'                                 l_pos_begin);',
'      end if;',
'    else',
'      l_returnvalue := null;',
'    end if;',
'    return l_returnvalue;',
'  exception',
'    when others then',
'      return null;',
'  end get_nth_token;',
'',
'  function get_token_count(p_text in varchar2, p_separator in varchar2 := g_default_separator)',
'    return number as',
'    l_pos pls_integer;',
'    l_counter pls_integer := 0;',
'    l_returnvalue number;',
'  begin',
'    if p_text is null then',
'      l_returnvalue := 0;',
'    else',
'      loop',
'        l_pos := instr(p_text, p_separator, 1, l_counter + 1);',
'        if l_pos > 0 then',
'          l_counter := l_counter + 1;',
'        else',
'          exit;',
'        end if;',
'      end loop;',
'      l_returnvalue := l_counter + 1;',
'    end if;',
'    return l_returnvalue;',
'  end get_token_count;',
'',
'  function is_numeric(p_value varchar2) return number is',
'    v_new_num number;',
'  begin',
'    v_new_num := to_number(p_value);',
'    return 1;',
'  exception',
'    when others then',
'      return 0;',
'  end is_numeric;',
'',
'  function prepare_url(p_page_num varchar, p_app_num number default null)',
'    return varchar2 is',
'    v_app number := APEX_APPLICATION.g_flow_id;',
'    v_session number := apex_application.g_instance;',
'    v_debug varchar2(10) := v(''DEBUG'');',
'  begin',
'    if p_app_num is not null then',
'      v_app := p_app_num;',
'    end if;',
'    return apex_util.prepare_url(p_url => ''f?p='' || v_app || '':'' ||',
'                                          p_page_num || '':'' || v_session || ''::'' ||',
'                                          v_debug || ''::'', p_checksum_type => ''SESSION'');',
'  end prepare_url;',
'',
'  function prepare_url(p_url varchar2) return varchar2 is',
'  begin',
'    return apex_util.prepare_url(p_url => p_url, p_checksum_type => ''SESSION'');',
'  end prepare_url;',
'',
'  function get_page_id_from_list_entry(p_url varchar2) return number is',
'  begin',
'    return regexp_substr(p_url, ''f\?p=&APP_ID\.:(\d+).*'', 1, 1, ''i'', 1);',
'  end get_page_id_from_list_entry;',
'',
'  FUNCTION f_render_tlbr(p_dynamic_action IN apex_plugin.t_dynamic_action, p_plugin IN apex_plugin.t_plugin)',
'    RETURN apex_plugin.t_dynamic_action_render_result AS',
'    V_APP_ID APEX_APPLICATIONS.APPLICATION_ID%TYPE := apex_application.g_flow_id;',
'    V_PAGE_ID APEX_APPLICATION_PAGES.PAGE_ID%TYPE := apex_application.g_flow_step_id;',
'    -- Application Plugin Attributes ',
'    -- DA Plugin Attributes ',
'    atr_src_type p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;',
'    atr_static_vals p_dynamic_action.attribute_02%type := p_dynamic_action.attribute_02;',
'    --atr_03 p_dynamic_action.attribute_03%type := p_dynamic_action.attribute_03;',
'    atr_list p_dynamic_action.attribute_04%type := p_dynamic_action.attribute_04;',
'    atr_sql_qry p_dynamic_action.attribute_05%type := p_dynamic_action.attribute_05;',
'    --atr_06 p_dynamic_action.attribute_06%type := p_dynamic_action.attribute_06;',
'    atr_aff_el_style p_dynamic_action.attribute_07%type := lower(p_dynamic_action.attribute_07);',
'    atr_style p_dynamic_action.attribute_08%type := lower(p_dynamic_action.attribute_08);',
'    atr_position p_dynamic_action.attribute_09%type := p_dynamic_action.attribute_09;',
'    atr_adjustment p_dynamic_action.attribute_10%type := p_dynamic_action.attribute_10;',
'    atr_animation p_dynamic_action.attribute_11%type := p_dynamic_action.attribute_11;',
'    atr_event p_dynamic_action.attribute_12%type := p_dynamic_action.attribute_12;',
'    atr_hideOnClick p_dynamic_action.attribute_13%type := p_dynamic_action.attribute_13;',
'   -- atr_14 p_dynamic_action.attribute_14%type := p_dynamic_action.attribute_14;',
'    atr_actionEvent p_dynamic_action.attribute_15%type := p_dynamic_action.attribute_15;',
'    -- Return ',
'    l_result apex_plugin.t_dynamic_action_render_result;',
'    -- Other variables ',
'    l_html varchar2(32767);',
'    l_src_id varchar2(1000) := ''toolbar-options_'' ||',
'                               round(dbms_random.value(1, 100000));',
'    l_js_code varchar2(32767);',
'    ---Source Type',
'    ----------------------',
'    l_stat_lst_varr wwv_flow_global.vc_arr2;',
'   ',
'    ---STATIC',
'    l_value varchar2(32767);',
'    l_icon varchar2(32767);',
'    l_title varchar2(32767);',
'    --LIST QUERY',
'    l_query clob;',
'    l_lst_type varchar2(50);',
'    l_lov apex_plugin_util.t_column_value_list;',
'    --LIST STATIC',
'    cursor c_apx_list(p_app_id in number, p_list_name in varchar2) is',
'      select ale.entry_image icon, ale.entry_target value, ale.entry_text title',
'        from apex_application_list_entries ale',
'       where ale.application_id = p_app_id and ale.list_name = p_list_name;',
'    --affected Elements',
'    ----------------------------------------',
'    l_elm_selector varchar2(1000);',
'    l_elm_code varchar2(1000);',
'    -- Convert Y/N to True/False (text) ',
'    -- Default to true ',
'    FUNCTION f_yn_2_truefalse_str(p_val IN VARCHAR2) RETURN VARCHAR2 AS',
'    BEGIN',
'      RETURN case NVL(p_val, ''N'') when ''Y'' then ''true'' else ''false'' end;',
'    END f_yn_2_truefalse_str;',
'  ',
'  BEGIN',
'    -- Debug information (if app is being run in debug mode) ',
'    IF apex_application.g_debug THEN',
'      apex_plugin_util.debug_dynamic_action(p_plugin => p_plugin, p_dynamic_action => p_dynamic_action);',
'    END IF;',
'    ---Source Content Generation',
'    -- parse static2 value',
'    if atr_src_type = ''STATIC'' then',
'      l_html := ''<div id="'' || l_src_id || ''" class="hidden">'';',
'      if upper(substr(atr_static_vals, 1, 7)) = ''STATIC2'' then',
'        atr_static_vals := substr(atr_static_vals, 9);',
'      elsif upper(substr(atr_static_vals, 1, 6)) = ''STATIC'' then',
'        atr_static_vals := substr(atr_static_vals, 8);',
'      else',
'        atr_static_vals := atr_static_vals;',
'      end if;',
'      l_stat_lst_varr := wwv_flow_utilities.string_to_table2(atr_static_vals, '','');',
'      for i in 1 .. l_stat_lst_varr.count loop',
'        /*   wwv_flow.show_error_message(p_message => get_token_count(l_stat_lst_varr(i)),',
'        p_footer  => l_stat_lst_varr(i));*/',
'        if get_token_count(l_stat_lst_varr(i)) >= 2 then',
'          l_icon := trim(get_nth_token(l_stat_lst_varr(i), g_icon_col));',
'          l_value := trim(get_nth_token(l_stat_lst_varr(i), g_value_col));',
'          if get_token_count(l_stat_lst_varr(i)) >= 3 then',
'            l_title := trim(get_nth_token(l_stat_lst_varr(i), g_title_col));',
'          end if;',
'        else',
'          wwv_flow.show_error_message(p_message => ''--Configuration Error STATIC LIST--'', p_footer => ''Refer to the Documentation.'');',
'        end if;',
'        if instr(l_value, ''http'') = 0 and is_numeric(l_value) = 1 then',
'          l_value := prepare_url(p_page_num => l_value);',
'          if instr(l_value, ''apex.nav'') = 0 then',
'            l_value := ''javascript:apex.navigation.redirect('' ||',
'                       apex_javascript.ADD_VALUE(l_value, FALSE) || '')'';',
'          end if;',
'          l_value := htf.escape_sc(l_value);',
'        elsif (instr(lower(l_value), ''f?p='') >= 1) Then',
'          l_value := prepare_url(p_url => apex_plugin_util.replace_substitutions(l_value));',
'          if instr(l_value, ''apex.nav'') = 0 then',
'            l_value := ''javascript:apex.navigation.redirect('' ||',
'                       apex_javascript.ADD_VALUE(l_value, FALSE) || '')'';',
'          end if;',
'          l_value := htf.escape_sc(l_value);',
'        elsif (instr(Upper(l_value), ''WWW'') >= 1) then',
'          if instr(Upper(l_value), ''HTTP'') = 0 then',
'            l_value := ''http://'' || l_value;',
'          end if;',
'          l_value := htf.escape_sc(''javascript:apex.navigation.redirect('' ||',
'                                   apex_javascript.ADD_VALUE(apex_plugin_util.replace_substitutions(l_value), FALSE) || '')'');',
'        Else',
'          IF instr(lower(l_value), ''javascript:'') = 0 then',
'            l_value := ''javascript:'' ||',
'                       apex_escape.html_whitelist(apex_plugin_util.replace_substitutions(l_value));',
'          else',
'            l_value := apex_escape.html_whitelist(apex_plugin_util.replace_substitutions(l_value));',
'          end if;',
'        end if;',
'        l_value := apex_javascript.ADD_VALUE(l_value);',
'        -- wwv_flow.show_error_message(p_message => l_value);',
'        l_html := l_html || ''<a  title="'' || l_title || ''" href='' ||',
'                  l_value || '' ><i class="t-Icon fa '' || l_icon ||',
'                  ''" aria-hidden="true"></i></a>'';',
'      end loop;',
'      l_html := l_html || ''</div>'';',
'    elsif atr_src_type = ''QUERY'' then',
'      l_html := ''<div id="'' || l_src_id || ''" class="hidden">'';',
'      l_lov := apex_plugin_util.get_data(p_sql_statement => atr_sql_qry, p_min_columns => 2, p_max_columns => 3, p_component_name => p_dynamic_action.action);',
'      for i in 1 .. l_lov(g_icon_col).count loop',
'        l_icon := l_lov(g_icon_col) (i);',
'        l_value := l_lov(g_value_col) (i);',
'        if l_lov.exists(g_title_col) then',
'          l_title := l_lov(g_title_col) (i);',
'        end if;',
'        if instr(l_value, ''http'') = 0 and is_numeric(l_value) = 1 then',
'          l_value := prepare_url(p_page_num => l_value);',
'          if instr(l_value, ''apex.nav'') = 0 then',
'            l_value := ''javascript:apex.navigation.redirect('' ||',
'                       apex_javascript.ADD_VALUE(l_value, FALSE) || '')'';',
'          end if;',
'          l_value := htf.escape_sc(l_value);',
'        elsif (instr(lower(l_value), ''f?p='') >= 1) Then',
'          l_value := prepare_url(p_url => apex_plugin_util.replace_substitutions(l_value));',
'          if instr(l_value, ''apex.nav'') = 0 then',
'            l_value := ''javascript:apex.navigation.redirect('' ||',
'                       apex_javascript.ADD_VALUE(l_value, FALSE) || '')'';',
'          end if;',
'          l_value := htf.escape_sc(l_value);',
'        elsif (instr(Upper(l_value), ''WWW'') >= 1) then',
'          if instr(Upper(l_value), ''HTTP'') = 0 then',
'            l_value := ''http://'' || l_value;',
'          end if;',
'          l_value := htf.escape_sc(''javascript:apex.navigation.redirect('' ||',
'                                   apex_javascript.ADD_VALUE(apex_plugin_util.replace_substitutions(l_value), FALSE) || '')'');',
'        Else',
'          IF instr(lower(l_value), ''javascript:'') = 0 then',
'            l_value := ''javascript:'' ||',
'                       apex_escape.html_whitelist(apex_plugin_util.replace_substitutions(l_value));',
'          else',
'            l_value := apex_escape.html_whitelist(apex_plugin_util.replace_substitutions(l_value));',
'          end if;',
'        end if;',
'        l_value := apex_javascript.ADD_VALUE(l_value);',
'        l_html := l_html || ''<a  title="'' || l_title || ''" href='' ||',
'                  l_value || '' ><i class="t-Icon fa '' || l_icon ||',
'                  ''" aria-hidden="true"></i></a>'';',
'      end loop;',
'      l_html := l_html || ''</div>'';',
'    elsif atr_src_type = ''LIST'' then',
'      select max(al.list_type_code)',
'        into l_lst_type',
'        from apex_application_lists al',
'       where al.application_id = v_app_id and al.list_name = atr_list;',
'      IF l_lst_type is NULL then',
'        wwv_flow.show_error_message(p_message => ''--Contextual Toolbar Plugin Error--'', p_footer => atr_list ||',
'                                                 '' ,invalid list name entered in configuration.'');',
'      end if;',
'      --STATIC',
'      --SQL_QUERY',
'      l_html := ''<div id="'' || l_src_id || ''" class="hidden">'';',
'      if l_lst_type = ''SQL_QUERY'' then',
'        select max(al.list_query)',
'          into l_query',
'          from apex_application_lists al',
'         where al.application_id = v_app_id and al.list_name = atr_list;',
'        l_lov := apex_plugin_util.get_data(p_sql_statement => l_query, p_min_columns => 2, p_max_columns => 3, p_component_name => p_dynamic_action.action);',
'        for i in 1 .. l_lov(g_icon_col).count loop',
'          l_icon := l_lov(g_icon_col) (i);',
'          l_value := l_lov(g_value_col) (i);',
'          if l_lov.exists(g_title_col) then',
'            l_title := l_lov(g_title_col) (i);',
'          end if;',
'          if instr(l_value, ''http'') = 0 and is_numeric(l_value) = 1 then',
'            l_value := prepare_url(p_page_num => l_value);',
'            if instr(l_value, ''apex.nav'') = 0 then',
'              l_value := ''javascript:apex.navigation.redirect('' ||',
'                         apex_javascript.ADD_VALUE(l_value, FALSE) || '')'';',
'            end if;',
'            l_value := htf.escape_sc(l_value);',
'          elsif (instr(lower(l_value), ''f?p='') >= 1) Then',
'            l_value := prepare_url(p_url => apex_plugin_util.replace_substitutions(l_value));',
'            if instr(l_value, ''apex.nav'') = 0 then',
'              l_value := ''javascript:apex.navigation.redirect('' ||',
'                         apex_javascript.ADD_VALUE(l_value, FALSE) || '')'';',
'            end if;',
'            l_value := htf.escape_sc(l_value);',
'          elsif (instr(Upper(l_value), ''WWW'') >= 1) then',
'            if instr(Upper(l_value), ''HTTP'') = 0 then',
'              l_value := ''http://'' || l_value;',
'            end if;',
'            l_value := htf.escape_sc(''javascript:apex.navigation.redirect('' ||',
'                                     apex_javascript.ADD_VALUE(apex_plugin_util.replace_substitutions(l_value), FALSE) || '')'');',
'          Else',
'            IF instr(lower(l_value), ''javascript:'') = 0 then',
'              l_value := ''javascript:'' ||',
'                         apex_escape.html_whitelist(apex_plugin_util.replace_substitutions(l_value));',
'            else',
'              l_value := apex_escape.html_whitelist(apex_plugin_util.replace_substitutions(l_value));',
'            end if;',
'          end if;',
'          l_value := apex_javascript.ADD_VALUE(l_value);',
'          l_html := l_html || ''<a  title="'' || l_title || ''" href='' ||',
'                    l_value || '' ><i class="t-Icon fa '' || l_icon ||',
'                    ''" aria-hidden="true"></i></a>'';',
'        end loop;',
'      elsif l_lst_type = ''STATIC'' THEN',
'        for rec in c_apx_list(v_app_id, atr_list) loop',
'          l_icon := rec.icon;',
'          l_value := rec.value;',
'          l_title := rec.title;',
'          if (instr(lower(l_value), ''f?p='') >= 1) Then',
'            l_value := prepare_url(p_url => apex_plugin_util.replace_substitutions(l_value));',
'            if instr(l_value, ''apex.nav'') = 0 then',
'              l_value := ''javascript:apex.navigation.redirect('' ||',
'                         apex_javascript.ADD_VALUE(l_value, FALSE) || '')'';',
'            end if;',
'            l_value := htf.escape_sc(l_value);',
'          elsif (instr(Upper(l_value), ''WWW'') >= 1) then',
'            if instr(Upper(l_value), ''HTTP'') = 0 then',
'              l_value := ''http://'' || l_value;',
'            end if;',
'            l_value := htf.escape_sc(''javascript:apex.navigation.redirect('' ||',
'                                     apex_javascript.ADD_VALUE(apex_plugin_util.replace_substitutions(l_value), FALSE) || '')'');',
'          Else',
'            IF instr(lower(l_value), ''javascript:'') = 0 then',
'              l_value := ''javascript:'' ||',
'                         apex_escape.html_whitelist(apex_plugin_util.replace_substitutions(l_value));',
'            else',
'              l_value := apex_escape.html_whitelist(apex_plugin_util.replace_substitutions(l_value));',
'            end if;',
'          end if;',
'          l_value := apex_javascript.ADD_VALUE(l_value);',
'          l_html := l_html || ''<a  title="'' || l_title || ''" href='' ||',
'                    l_value || '' ><i class="t-Icon fa '' || l_icon ||',
'                    ''" aria-hidden="true"></i></a>'';',
'        end loop;',
'      end if;',
'      l_html := l_html || ''</div>'';',
'      ----atr_src_type = ''LIST''',
'    End if; --atr_src_type',
'    l_js_code := ''$('''''' || l_html || '''''').appendTo("body");'';',
'    apex_javascript.add_onload_code(p_code => l_js_code);',
'    l_js_code := '''';',
'    SELECT case max(AFFECTED_ELEMENTS_TYPE_CODE)',
'              WHEN ''ITEM'' THEN',
'               max(APEX_PLUGIN_UTIL.PAGE_ITEM_NAMES_TO_JQUERY(aapda.AFFECTED_ELEMENTS))',
'              WHEN ''BUTTON'' THEN',
'               max(''#'' ||',
'                   nvl(aapb.button_static_id, ''B'' || aapda.affected_button_id))',
'              WHEN ''REGION'' THEN',
'               max(''#'' ||',
'                   nvl(aapr.STATIC_ID, ''R'' || aapda.affected_button_id))',
'              WHEN ''JQUERY_SELECTOR'' THEN',
'               max(aapda.AFFECTED_ELEMENTS)',
'            end as static_id',
'      INTO l_elm_selector',
'      FROM apex_application_page_da_acts aapda, apex_application_page_regions aapr, apex_application_page_items aapi, apex_application_page_buttons aapb',
'     WHERE aapda.action_id = p_dynamic_action.ID',
'          -- AND aapda.application_id = 104',
'           AND aapda.affected_region_id = aapr.region_id(+) and',
'           aapda.affected_elements = aapi.item_name(+) and',
'           aapda.affected_button_id = aapb.button_id(+);',
'    apex_javascript.add_library(p_name => ''jquery.toolbar.min'', p_directory => p_plugin.file_prefix ||',
'                                                ''tlbr/'', p_version => NULL, p_skip_extension => FALSE);',
'    apex_css.add_file(p_name => ''jquery.toolbar'', p_directory => p_plugin.file_prefix ||',
'                                      ''tlbr/'');',
'    IF atr_aff_el_style is not null then',
'      l_elm_code := ''$('''''' || l_elm_selector || '''''').addClass('''''' ||',
'                    ''btn-toolbar-'' || atr_aff_el_style || '''''');'';',
'    end if;',
'    l_js_code := apex_javascript.add_attribute(''hideOnClick'', case',
'                                                 atr_hideOnClick',
'                                                  when ''Y'' then',
'                                                   true',
'                                                  else',
'                                                   false',
'                                                end); -- atr_hideOnClick);',
'    IF atr_style is not null then',
'      l_js_code := l_js_code ||',
'                   apex_javascript.add_attribute(''style'', atr_style);',
'    end if;',
'    l_js_code := l_js_code ||',
'                 apex_javascript.add_attribute(''itemEvent'', atr_actionEvent);',
'    l_js_code := l_js_code ||',
'                 apex_javascript.add_attribute(''position'', atr_position);',
'    if atr_adjustment is not null then',
'      l_js_code := l_js_code ||',
'                   apex_javascript.add_attribute(''adjustment'', atr_adjustment);',
'    end if;',
'    l_js_code := l_js_code ||',
'                 apex_javascript.add_attribute(''animation'', atr_animation);',
'    l_js_code := l_js_code ||',
'                 apex_javascript.add_attribute(''event'', atr_event);',
'    l_js_code := l_js_code ||',
'                 apex_javascript.add_attribute(''content'', sys.htf.escape_sc(''#'' ||',
'                                                                  l_src_id), false, false);',
'    l_js_code := l_elm_code || ''$('''''' || l_elm_selector || '''''').toolbar({'' ||',
'                 l_js_code || ''});'';',
'    apex_javascript.add_onload_code(p_code => l_js_code);',
'    l_result.javascript_function :=''function (){ '' || l_js_code || ''; if(this.action.waitForResult == true){apex.da.resume( this.resumeCallback, false );}}'';',
'    RETURN l_result;',
'  END f_render_tlbr;'))
,p_render_function=>'f_render_tlbr'
,p_standard_attributes=>'ITEM:BUTTON:REGION:JQUERY_SELECTOR:JAVASCRIPT_EXPRESSION:REQUIRED:STOP_EXECUTION_ON_ERROR:WAIT_FOR_RESULT'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.2'
,p_about_url=>'https://github.com/planetapex/apex-plugin-contextualToolbar'
,p_files_version=>13
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(29232559188227060)
,p_plugin_id=>wwv_flow_api.id(28269873535651867)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Source Type'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'STATIC'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(29233633420229880)
,p_plugin_attribute_id=>wwv_flow_api.id(29232559188227060)
,p_display_sequence=>10
,p_display_value=>'Static'
,p_return_value=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(29234061838231021)
,p_plugin_attribute_id=>wwv_flow_api.id(29232559188227060)
,p_display_sequence=>20
,p_display_value=>'SQL Query'
,p_return_value=>'QUERY'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(29234421414232289)
,p_plugin_attribute_id=>wwv_flow_api.id(29232559188227060)
,p_display_sequence=>30
,p_display_value=>'List'
,p_return_value=>'LIST'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(28683557614256738)
,p_plugin_id=>wwv_flow_api.id(28269873535651867)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Source Text'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>true
,p_default_value=>'STATIC:fa-plane;1;Page 1,fa-car;f?p=&APP_ID.:2:&SESSION.;Page 2,fa-cog;alert("ola");Javascript Function'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(29232559188227060)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'STATIC'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(28712386045285553)
,p_plugin_id=>wwv_flow_api.id(28269873535651867)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'List Name'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(29232559188227060)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'LIST'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(28713068124292970)
,p_plugin_id=>wwv_flow_api.id(28269873535651867)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Query Text'
,p_attribute_type=>'SQL'
,p_is_required=>true
,p_default_value=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'Select ''fa-plane'', ''1'', ''Page 1''',
'  from dual',
'Union All',
'Select ''fa-car'', ''f?p=&APP_ID.:2:&SESSION.'', ''Page 2''',
'  from dual',
'Union All',
'Select ''fa-cog'', ''alert("ola")'', ''Javascript Function''',
'  from dual',
''))
,p_sql_min_column_count=>2
,p_sql_max_column_count=>2
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(29232559188227060)
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'QUERY'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(28715344489682627)
,p_plugin_id=>wwv_flow_api.id(28269873535651867)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Triggering Element Style'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28717020236792315)
,p_plugin_attribute_id=>wwv_flow_api.id(28715344489682627)
,p_display_sequence=>10
,p_display_value=>'Primary'
,p_return_value=>'Primary'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28717441219793261)
,p_plugin_attribute_id=>wwv_flow_api.id(28715344489682627)
,p_display_sequence=>20
,p_display_value=>'Danger'
,p_return_value=>'Danger'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28719494100892492)
,p_plugin_attribute_id=>wwv_flow_api.id(28715344489682627)
,p_display_sequence=>30
,p_display_value=>'Warning'
,p_return_value=>'Warning'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28719953142892868)
,p_plugin_attribute_id=>wwv_flow_api.id(28715344489682627)
,p_display_sequence=>40
,p_display_value=>'Info'
,p_return_value=>'Info'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28720317096893631)
,p_plugin_attribute_id=>wwv_flow_api.id(28715344489682627)
,p_display_sequence=>50
,p_display_value=>'Success'
,p_return_value=>'Success'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28720736369894496)
,p_plugin_attribute_id=>wwv_flow_api.id(28715344489682627)
,p_display_sequence=>60
,p_display_value=>'Info-o'
,p_return_value=>'Info-o'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28721092214895548)
,p_plugin_attribute_id=>wwv_flow_api.id(28715344489682627)
,p_display_sequence=>70
,p_display_value=>'Dark'
,p_return_value=>'Dark'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28721522298896307)
,p_plugin_attribute_id=>wwv_flow_api.id(28715344489682627)
,p_display_sequence=>80
,p_display_value=>'Light'
,p_return_value=>'Light'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(28721959113901621)
,p_plugin_id=>wwv_flow_api.id(28269873535651867)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Toolbar Style'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28722642358902641)
,p_plugin_attribute_id=>wwv_flow_api.id(28721959113901621)
,p_display_sequence=>10
,p_display_value=>'Primary'
,p_return_value=>'Primary'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28723054221904242)
,p_plugin_attribute_id=>wwv_flow_api.id(28721959113901621)
,p_display_sequence=>20
,p_display_value=>'Danger'
,p_return_value=>'Danger'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28723461911905064)
,p_plugin_attribute_id=>wwv_flow_api.id(28721959113901621)
,p_display_sequence=>30
,p_display_value=>'Warning'
,p_return_value=>'Warning'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28723818455905879)
,p_plugin_attribute_id=>wwv_flow_api.id(28721959113901621)
,p_display_sequence=>40
,p_display_value=>'Info'
,p_return_value=>'Info'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28724211951907060)
,p_plugin_attribute_id=>wwv_flow_api.id(28721959113901621)
,p_display_sequence=>50
,p_display_value=>'Success'
,p_return_value=>'Success'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28724596479908505)
,p_plugin_attribute_id=>wwv_flow_api.id(28721959113901621)
,p_display_sequence=>60
,p_display_value=>'Info-o'
,p_return_value=>'Info-o'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28724997127909522)
,p_plugin_attribute_id=>wwv_flow_api.id(28721959113901621)
,p_display_sequence=>70
,p_display_value=>'Dark'
,p_return_value=>'Dark'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28725443638910420)
,p_plugin_attribute_id=>wwv_flow_api.id(28721959113901621)
,p_display_sequence=>80
,p_display_value=>'Light'
,p_return_value=>'Light'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(28725867660923372)
,p_plugin_id=>wwv_flow_api.id(28269873535651867)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Position'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'top'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28726505520924014)
,p_plugin_attribute_id=>wwv_flow_api.id(28725867660923372)
,p_display_sequence=>10
,p_display_value=>'Top'
,p_return_value=>'top'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28726951540925022)
,p_plugin_attribute_id=>wwv_flow_api.id(28725867660923372)
,p_display_sequence=>20
,p_display_value=>'Bottom'
,p_return_value=>'bottom'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28727346657925947)
,p_plugin_attribute_id=>wwv_flow_api.id(28725867660923372)
,p_display_sequence=>30
,p_display_value=>'Left'
,p_return_value=>'left'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28727777284926828)
,p_plugin_attribute_id=>wwv_flow_api.id(28725867660923372)
,p_display_sequence=>40
,p_display_value=>'Right'
,p_return_value=>'right'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(28729086883984418)
,p_plugin_id=>wwv_flow_api.id(28269873535651867)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'Toolbar Offset'
,p_attribute_type=>'INTEGER'
,p_is_required=>false
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(28732107292013885)
,p_plugin_id=>wwv_flow_api.id(28269873535651867)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_prompt=>'Animation'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'standard'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
end;
/
begin
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28732883532015666)
,p_plugin_attribute_id=>wwv_flow_api.id(28732107292013885)
,p_display_sequence=>10
,p_display_value=>'Standard'
,p_return_value=>'standard'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28733256888016895)
,p_plugin_attribute_id=>wwv_flow_api.id(28732107292013885)
,p_display_sequence=>20
,p_display_value=>'Flip'
,p_return_value=>'flip'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28733681002017928)
,p_plugin_attribute_id=>wwv_flow_api.id(28732107292013885)
,p_display_sequence=>30
,p_display_value=>'Grow'
,p_return_value=>'grow'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28734082496018926)
,p_plugin_attribute_id=>wwv_flow_api.id(28732107292013885)
,p_display_sequence=>40
,p_display_value=>'Flying'
,p_return_value=>'flying'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28734394726020209)
,p_plugin_attribute_id=>wwv_flow_api.id(28732107292013885)
,p_display_sequence=>50
,p_display_value=>'Bounce'
,p_return_value=>'bounce'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(28736022259037904)
,p_plugin_id=>wwv_flow_api.id(28269873535651867)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>120
,p_prompt=>'Show Event'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'click'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28736770804039155)
,p_plugin_attribute_id=>wwv_flow_api.id(28736022259037904)
,p_display_sequence=>10
,p_display_value=>'Click'
,p_return_value=>'click'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(28737106406040553)
,p_plugin_attribute_id=>wwv_flow_api.id(28736022259037904)
,p_display_sequence=>20
,p_display_value=>'Hover'
,p_return_value=>'hover'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(28737868125054282)
,p_plugin_id=>wwv_flow_api.id(28269873535651867)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>13
,p_display_sequence=>130
,p_prompt=>'Hide on Click'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'Y'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(29094467213554684)
,p_plugin_id=>wwv_flow_api.id(28269873535651867)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>15
,p_display_sequence=>150
,p_prompt=>'Toolbar Item Event'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'click'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(29095580661556572)
,p_plugin_attribute_id=>wwv_flow_api.id(29094467213554684)
,p_display_sequence=>10
,p_display_value=>'Click'
,p_return_value=>'click'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(29095948814576193)
,p_plugin_attribute_id=>wwv_flow_api.id(29094467213554684)
,p_display_sequence=>20
,p_display_value=>'Double Click'
,p_return_value=>'dblclick'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(29096321205577578)
,p_plugin_attribute_id=>wwv_flow_api.id(29094467213554684)
,p_display_sequence=>30
,p_display_value=>'Mouse Button Pressed'
,p_return_value=>'mousedown'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(29096773200579068)
,p_plugin_attribute_id=>wwv_flow_api.id(29094467213554684)
,p_display_sequence=>40
,p_display_value=>'Mouse Button Released'
,p_return_value=>'mouseup'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(29097132397580318)
,p_plugin_attribute_id=>wwv_flow_api.id(29094467213554684)
,p_display_sequence=>50
,p_display_value=>'Mouse Pointer Out'
,p_return_value=>'mouseout'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(29097572946589731)
,p_plugin_attribute_id=>wwv_flow_api.id(29094467213554684)
,p_display_sequence=>60
,p_display_value=>'Mouse Pointer Over'
,p_return_value=>'mouseover'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E62746E2D746F6F6C6261722C2E746F6F6C2D6974656D7B646973706C61793A626C6F636B3B77696474683A323070783B746578742D616C69676E3A63656E7465723B70616464696E673A313070783B7472616E736974696F6E3A6E6F6E657D2E62746E';
wwv_flow_api.g_varchar2_table(2) := '2D746F6F6C6261722C2E746F6F6C2D636F6E7461696E65722C2E746F6F6C2D6974656D7B2D7765626B69742D626F782D73697A696E673A636F6E74656E742D626F783B2D6D6F7A2D626F782D73697A696E673A636F6E74656E742D626F783B626F782D73';
wwv_flow_api.g_varchar2_table(3) := '697A696E673A636F6E74656E742D626F787D2E62746E2D746F6F6C6261727B6261636B67726F756E643A233336343334373B6865696768743A323070783B626F726465722D7261646975733A3670787D2E62746E2D746F6F6C6261723E697B636F6C6F72';
wwv_flow_api.g_varchar2_table(4) := '3A233032626166323B666F6E742D73697A653A313670787D2E62746E2D746F6F6C6261722D64616E6765723E692C2E62746E2D746F6F6C6261722D6461726B3E692C2E62746E2D746F6F6C6261722D696E666F2D6F3E692C2E62746E2D746F6F6C626172';
wwv_flow_api.g_varchar2_table(5) := '2D696E666F3E692C2E62746E2D746F6F6C6261722D6C696768743E692C2E62746E2D746F6F6C6261722D7072696D6172793E692C2E62746E2D746F6F6C6261722D737563636573733E692C2E62746E2D746F6F6C6261722D7761726E696E673E692C2E62';
wwv_flow_api.g_varchar2_table(6) := '746E2D746F6F6C6261723A686F7665723E697B636F6C6F723A236666667D2E62746E2D746F6F6C6261723A686F7665727B6261636B67726F756E643A233032626166323B637572736F723A706F696E7465727D2E62746E2D746F6F6C6261722D7072696D';
wwv_flow_api.g_varchar2_table(7) := '6172797B6261636B67726F756E642D636F6C6F723A233030396463647D2E62746E2D746F6F6C6261722D7072696D6172792E707265737365642C2E62746E2D746F6F6C6261722D7072696D6172793A686F7665727B6261636B67726F756E642D636F6C6F';
wwv_flow_api.g_varchar2_table(8) := '723A233032626166327D2E62746E2D746F6F6C6261722D64616E6765727B6261636B67726F756E642D636F6C6F723A236330307D2E62746E2D746F6F6C6261722D64616E6765722E707265737365642C2E62746E2D746F6F6C6261722D64616E6765723A';
wwv_flow_api.g_varchar2_table(9) := '686F7665727B6261636B67726F756E642D636F6C6F723A236638343534357D2E62746E2D746F6F6C6261722D7761726E696E677B6261636B67726F756E642D636F6C6F723A236633626336357D2E62746E2D746F6F6C6261722D7761726E696E672E7072';
wwv_flow_api.g_varchar2_table(10) := '65737365642C2E62746E2D746F6F6C6261722D7761726E696E673A686F7665727B6261636B67726F756E642D636F6C6F723A236661643436627D2E62746E2D746F6F6C6261722D696E666F7B6261636B67726F756E642D636F6C6F723A23653936333030';
wwv_flow_api.g_varchar2_table(11) := '7D2E62746E2D746F6F6C6261722D696E666F2E707265737365642C2E62746E2D746F6F6C6261722D696E666F3A686F7665727B6261636B67726F756E642D636F6C6F723A236635383431307D2E62746E2D746F6F6C6261722D737563636573737B626163';
wwv_flow_api.g_varchar2_table(12) := '6B67726F756E642D636F6C6F723A233238393438637D2E62746E2D746F6F6C6261722D737563636573732E707265737365642C2E62746E2D746F6F6C6261722D737563636573733A686F7665727B6261636B67726F756E642D636F6C6F723A2333656235';
wwv_flow_api.g_varchar2_table(13) := '61637D2E62746E2D746F6F6C6261722D696E666F2D6F7B6261636B67726F756E642D636F6C6F723A233931373562647D2E62746E2D746F6F6C6261722D696E666F2D6F2E707265737365642C2E62746E2D746F6F6C6261722D696E666F2D6F3A686F7665';
wwv_flow_api.g_varchar2_table(14) := '727B6261636B67726F756E642D636F6C6F723A236138386364357D2E62746E2D746F6F6C6261722D6C696768747B6261636B67726F756E642D636F6C6F723A236232633663647D2E62746E2D746F6F6C6261722D6C696768742E707265737365642C2E62';
wwv_flow_api.g_varchar2_table(15) := '746E2D746F6F6C6261722D6C696768743A686F7665727B6261636B67726F756E642D636F6C6F723A236436653165357D2E62746E2D746F6F6C6261722D6461726B7B6261636B67726F756E642D636F6C6F723A233336343334377D2E62746E2D746F6F6C';
wwv_flow_api.g_varchar2_table(16) := '6261722D6461726B2E707265737365642C2E62746E2D746F6F6C6261722D6461726B3A686F7665722C2E746F6F6C2D636F6E7461696E65727B6261636B67726F756E642D636F6C6F723A233565363936647D2E746F6F6C2D636F6E7461696E65727B6261';
wwv_flow_api.g_varchar2_table(17) := '636B67726F756E642D73697A653A3130302520313030253B626F726465722D7261646975733A3670783B706F736974696F6E3A6162736F6C7574657D2E746F6F6C2D636F6E7461696E65722E746F6F6C2D626F74746F6D2C2E746F6F6C2D636F6E746169';
wwv_flow_api.g_varchar2_table(18) := '6E65722E746F6F6C2D746F707B6865696768743A343070783B626F726465722D626F74746F6D3A3020736F6C696420236265623862387D2E746F6F6C2D636F6E7461696E65722E746F6F6C2D626F74746F6D202E746F6F6C2D6974656D2C2E746F6F6C2D';
wwv_flow_api.g_varchar2_table(19) := '636F6E7461696E65722E746F6F6C2D746F70202E746F6F6C2D6974656D7B666C6F61743A6C6566743B626F726465722D72696768743A303B626F726465722D6C6566743A307D2E746F6F6C2D6974656D7B6865696768743A323070787D2E746F6F6C2D69';
wwv_flow_api.g_varchar2_table(20) := '74656D3E2E66617B636F6C6F723A236232633663647D2E746F6F6C2D6974656D2E73656C65637465642C2E746F6F6C2D6974656D3A686F7665727B6261636B67726F756E643A233032626166327D2E746F6F6C2D6974656D2E73656C65637465643E2E66';
wwv_flow_api.g_varchar2_table(21) := '612C2E746F6F6C2D6974656D3A686F7665723E2E66617B636F6C6F723A236666667D2E746F6F6C2D626F74746F6D202E746F6F6C2D6974656D3A66697273742D6368696C643A686F7665722C2E746F6F6C2D746F70202E746F6F6C2D6974656D3A666972';
wwv_flow_api.g_varchar2_table(22) := '73742D6368696C643A686F7665727B626F726465722D746F702D6C6566742D7261646975733A3670783B626F726465722D626F74746F6D2D6C6566742D7261646975733A3670787D2E746F6F6C2D626F74746F6D202E746F6F6C2D6974656D3A6C617374';
wwv_flow_api.g_varchar2_table(23) := '2D6368696C643A686F7665722C2E746F6F6C2D746F70202E746F6F6C2D6974656D3A6C6173742D6368696C643A686F7665727B626F726465722D746F702D72696768742D7261646975733A3670783B626F726465722D626F74746F6D2D72696768742D72';
wwv_flow_api.g_varchar2_table(24) := '61646975733A3670787D2E746F6F6C2D6C656674202E746F6F6C2D6974656D3A66697273742D6368696C643A686F7665722C2E746F6F6C2D7269676874202E746F6F6C2D6974656D3A66697273742D6368696C643A686F7665722C2E746F6F6C2D766572';
wwv_flow_api.g_varchar2_table(25) := '746963616C2D626F74746F6D202E746F6F6C2D6974656D3A66697273742D6368696C643A686F7665722C2E746F6F6C2D766572746963616C2D746F70202E746F6F6C2D6974656D3A66697273742D6368696C643A686F7665727B626F726465722D746F70';
wwv_flow_api.g_varchar2_table(26) := '2D6C6566742D7261646975733A3670783B626F726465722D746F702D72696768742D7261646975733A3670787D2E746F6F6C2D6C656674202E746F6F6C2D6974656D3A6C6173742D6368696C643A686F7665722C2E746F6F6C2D7269676874202E746F6F';
wwv_flow_api.g_varchar2_table(27) := '6C2D6974656D3A6C6173742D6368696C643A686F7665722C2E746F6F6C2D766572746963616C2D626F74746F6D202E746F6F6C2D6974656D3A6C6173742D6368696C643A686F7665722C2E746F6F6C2D766572746963616C2D746F70202E746F6F6C2D69';
wwv_flow_api.g_varchar2_table(28) := '74656D3A6C6173742D6368696C643A686F7665727B626F726465722D626F74746F6D2D6C6566742D7261646975733A3670783B626F726465722D626F74746F6D2D72696768742D7261646975733A3670787D2E746F6F6C2D636F6E7461696E6572202E61';
wwv_flow_api.g_varchar2_table(29) := '72726F777B77696474683A303B6865696768743A303B706F736974696F6E3A6162736F6C7574653B626F726465722D77696474683A3770783B626F726465722D7374796C653A736F6C69647D2E746F6F6C2D636F6E7461696E65722E746F6F6C2D746F70';
wwv_flow_api.g_varchar2_table(30) := '202E6172726F777B626F726465722D636F6C6F723A23356536393664207472616E73706172656E74207472616E73706172656E743B6C6566743A3530253B626F74746F6D3A2D313470783B6D617267696E2D6C6566743A2D3770787D2E746F6F6C2D636F';
wwv_flow_api.g_varchar2_table(31) := '6E7461696E65722E746F6F6C2D626F74746F6D202E6172726F777B626F726465722D636F6C6F723A7472616E73706172656E74207472616E73706172656E7420233565363936643B6C6566743A3530253B746F703A2D313470783B6D617267696E2D6C65';
wwv_flow_api.g_varchar2_table(32) := '66743A2D3770787D2E746F6F6C2D636F6E7461696E65722E746F6F6C2D6C656674202E6172726F777B626F726465722D636F6C6F723A7472616E73706172656E74207472616E73706172656E74207472616E73706172656E7420233565363936643B746F';
wwv_flow_api.g_varchar2_table(33) := '703A3530253B72696768743A2D313470783B6D617267696E2D746F703A2D3770787D2E746F6F6C2D636F6E7461696E65722E746F6F6C2D7269676874202E6172726F777B626F726465722D636F6C6F723A7472616E73706172656E742023356536393664';
wwv_flow_api.g_varchar2_table(34) := '207472616E73706172656E74207472616E73706172656E743B746F703A3530253B6C6566743A2D313470783B6D617267696E2D746F703A2D3770787D2E746F6F6C6261722D7072696D6172797B6261636B67726F756E642D636F6C6F723A233032626166';
wwv_flow_api.g_varchar2_table(35) := '327D2E746F6F6C6261722D7072696D6172792E746F6F6C2D746F70202E6172726F777B626F726465722D636F6C6F723A23303262616632207472616E73706172656E74207472616E73706172656E747D2E746F6F6C6261722D7072696D6172792E746F6F';
wwv_flow_api.g_varchar2_table(36) := '6C2D626F74746F6D202E6172726F777B626F726465722D636F6C6F723A7472616E73706172656E74207472616E73706172656E7420233032626166327D2E746F6F6C6261722D7072696D6172792E746F6F6C2D6C656674202E6172726F777B626F726465';
wwv_flow_api.g_varchar2_table(37) := '722D636F6C6F723A7472616E73706172656E74207472616E73706172656E74207472616E73706172656E7420233032626166327D2E746F6F6C6261722D7072696D6172792E746F6F6C2D7269676874202E6172726F777B626F726465722D636F6C6F723A';
wwv_flow_api.g_varchar2_table(38) := '7472616E73706172656E742023303262616632207472616E73706172656E74207472616E73706172656E747D2E746F6F6C6261722D7072696D617279202E746F6F6C2D6974656D3E2E66617B636F6C6F723A236666667D2E746F6F6C6261722D7072696D';
wwv_flow_api.g_varchar2_table(39) := '617279202E746F6F6C2D6974656D2E73656C65637465642C2E746F6F6C6261722D7072696D617279202E746F6F6C2D6974656D3A686F7665727B6261636B67726F756E643A233030396463643B636F6C6F723A236666667D2E746F6F6C6261722D64616E';
wwv_flow_api.g_varchar2_table(40) := '6765727B6261636B67726F756E642D636F6C6F723A236638343534357D2E746F6F6C6261722D64616E6765722E746F6F6C2D746F70202E6172726F777B626F726465722D636F6C6F723A23663834353435207472616E73706172656E74207472616E7370';
wwv_flow_api.g_varchar2_table(41) := '6172656E747D2E746F6F6C6261722D64616E6765722E746F6F6C2D626F74746F6D202E6172726F777B626F726465722D636F6C6F723A7472616E73706172656E74207472616E73706172656E7420236638343534357D2E746F6F6C6261722D64616E6765';
wwv_flow_api.g_varchar2_table(42) := '722E746F6F6C2D6C656674202E6172726F777B626F726465722D636F6C6F723A7472616E73706172656E74207472616E73706172656E74207472616E73706172656E7420236638343534357D2E746F6F6C6261722D64616E6765722E746F6F6C2D726967';
wwv_flow_api.g_varchar2_table(43) := '6874202E6172726F777B626F726465722D636F6C6F723A7472616E73706172656E742023663834353435207472616E73706172656E74207472616E73706172656E747D2E746F6F6C6261722D64616E676572202E746F6F6C2D6974656D3E2E66617B636F';
wwv_flow_api.g_varchar2_table(44) := '6C6F723A236666667D2E746F6F6C6261722D64616E676572202E746F6F6C2D6974656D2E73656C65637465642C2E746F6F6C6261722D64616E676572202E746F6F6C2D6974656D3A686F7665727B6261636B67726F756E643A236330303B636F6C6F723A';
wwv_flow_api.g_varchar2_table(45) := '236666667D2E746F6F6C6261722D7761726E696E677B6261636B67726F756E642D636F6C6F723A236633626336357D2E746F6F6C6261722D7761726E696E672E746F6F6C2D746F70202E6172726F777B626F726465722D636F6C6F723A23663362633635';
wwv_flow_api.g_varchar2_table(46) := '207472616E73706172656E74207472616E73706172656E747D2E746F6F6C6261722D7761726E696E672E746F6F6C2D626F74746F6D202E6172726F777B626F726465722D636F6C6F723A7472616E73706172656E74207472616E73706172656E74202366';
wwv_flow_api.g_varchar2_table(47) := '33626336357D2E746F6F6C6261722D7761726E696E672E746F6F6C2D6C656674202E6172726F777B626F726465722D636F6C6F723A7472616E73706172656E74207472616E73706172656E74207472616E73706172656E7420236633626336357D2E746F';
wwv_flow_api.g_varchar2_table(48) := '6F6C6261722D7761726E696E672E746F6F6C2D7269676874202E6172726F777B626F726465722D636F6C6F723A7472616E73706172656E742023663362633635207472616E73706172656E74207472616E73706172656E747D2E746F6F6C6261722D7761';
wwv_flow_api.g_varchar2_table(49) := '726E696E67202E746F6F6C2D6974656D3E2E66617B636F6C6F723A236666667D2E746F6F6C6261722D7761726E696E67202E746F6F6C2D6974656D2E73656C65637465642C2E746F6F6C6261722D7761726E696E67202E746F6F6C2D6974656D3A686F76';
wwv_flow_api.g_varchar2_table(50) := '65727B6261636B67726F756E643A236661643436623B636F6C6F723A236666667D2E746F6F6C6261722D696E666F7B6261636B67726F756E642D636F6C6F723A236539363330307D2E746F6F6C6261722D696E666F2E746F6F6C2D746F70202E6172726F';
wwv_flow_api.g_varchar2_table(51) := '777B626F726465722D636F6C6F723A23653936333030207472616E73706172656E74207472616E73706172656E747D2E746F6F6C6261722D696E666F2E746F6F6C2D626F74746F6D202E6172726F777B626F726465722D636F6C6F723A7472616E737061';
wwv_flow_api.g_varchar2_table(52) := '72656E74207472616E73706172656E7420236539363330307D2E746F6F6C6261722D696E666F2E746F6F6C2D6C656674202E6172726F777B626F726465722D636F6C6F723A7472616E73706172656E74207472616E73706172656E74207472616E737061';
wwv_flow_api.g_varchar2_table(53) := '72656E7420236539363330307D2E746F6F6C6261722D696E666F2E746F6F6C2D7269676874202E6172726F777B626F726465722D636F6C6F723A7472616E73706172656E742023653936333030207472616E73706172656E74207472616E73706172656E';
wwv_flow_api.g_varchar2_table(54) := '747D2E746F6F6C6261722D696E666F202E746F6F6C2D6974656D3E2E66617B636F6C6F723A236666667D2E746F6F6C6261722D696E666F202E746F6F6C2D6974656D2E73656C65637465642C2E746F6F6C6261722D696E666F202E746F6F6C2D6974656D';
wwv_flow_api.g_varchar2_table(55) := '3A686F7665727B6261636B67726F756E643A236635383431303B636F6C6F723A236666667D2E746F6F6C6261722D737563636573737B6261636B67726F756E642D636F6C6F723A233238393438637D2E746F6F6C6261722D737563636573732E746F6F6C';
wwv_flow_api.g_varchar2_table(56) := '2D746F70202E6172726F777B626F726465722D636F6C6F723A23323839343863207472616E73706172656E74207472616E73706172656E747D2E746F6F6C6261722D737563636573732E746F6F6C2D626F74746F6D202E6172726F777B626F726465722D';
wwv_flow_api.g_varchar2_table(57) := '636F6C6F723A7472616E73706172656E74207472616E73706172656E7420233238393438637D2E746F6F6C6261722D737563636573732E746F6F6C2D6C656674202E6172726F777B626F726465722D636F6C6F723A7472616E73706172656E7420747261';
wwv_flow_api.g_varchar2_table(58) := '6E73706172656E74207472616E73706172656E7420233238393438637D2E746F6F6C6261722D737563636573732E746F6F6C2D7269676874202E6172726F777B626F726465722D636F6C6F723A7472616E73706172656E74202332383934386320747261';
wwv_flow_api.g_varchar2_table(59) := '6E73706172656E74207472616E73706172656E747D2E746F6F6C6261722D73756363657373202E746F6F6C2D6974656D3E2E66617B636F6C6F723A236666667D2E746F6F6C6261722D73756363657373202E746F6F6C2D6974656D2E73656C6563746564';
wwv_flow_api.g_varchar2_table(60) := '2C2E746F6F6C6261722D73756363657373202E746F6F6C2D6974656D3A686F7665727B6261636B67726F756E643A233365623561633B636F6C6F723A236666667D2E746F6F6C6261722D696E666F2D6F7B6261636B67726F756E642D636F6C6F723A2339';
wwv_flow_api.g_varchar2_table(61) := '31373562647D2E746F6F6C6261722D696E666F2D6F2E746F6F6C2D746F70202E6172726F777B626F726465722D636F6C6F723A23393137356264207472616E73706172656E74207472616E73706172656E747D2E746F6F6C6261722D696E666F2D6F2E74';
wwv_flow_api.g_varchar2_table(62) := '6F6F6C2D626F74746F6D202E6172726F777B626F726465722D636F6C6F723A7472616E73706172656E74207472616E73706172656E7420233931373562647D2E746F6F6C6261722D696E666F2D6F2E746F6F6C2D6C656674202E6172726F777B626F7264';
wwv_flow_api.g_varchar2_table(63) := '65722D636F6C6F723A7472616E73706172656E74207472616E73706172656E74207472616E73706172656E7420233931373562647D2E746F6F6C6261722D696E666F2D6F2E746F6F6C2D7269676874202E6172726F777B626F726465722D636F6C6F723A';
wwv_flow_api.g_varchar2_table(64) := '7472616E73706172656E742023393137356264207472616E73706172656E74207472616E73706172656E747D2E746F6F6C6261722D696E666F2D6F202E746F6F6C2D6974656D3E2E66617B636F6C6F723A236666667D2E746F6F6C6261722D696E666F2D';
wwv_flow_api.g_varchar2_table(65) := '6F202E746F6F6C2D6974656D2E73656C65637465642C2E746F6F6C6261722D696E666F2D6F202E746F6F6C2D6974656D3A686F7665727B6261636B67726F756E643A236138386364353B636F6C6F723A236666667D2E746F6F6C6261722D6C696768747B';
wwv_flow_api.g_varchar2_table(66) := '6261636B67726F756E642D636F6C6F723A236232633663647D2E746F6F6C6261722D6C696768742E746F6F6C2D746F70202E6172726F777B626F726465722D636F6C6F723A23623263366364207472616E73706172656E74207472616E73706172656E74';
wwv_flow_api.g_varchar2_table(67) := '7D2E746F6F6C6261722D6C696768742E746F6F6C2D626F74746F6D202E6172726F777B626F726465722D636F6C6F723A7472616E73706172656E74207472616E73706172656E7420236232633663647D2E746F6F6C6261722D6C696768742E746F6F6C2D';
wwv_flow_api.g_varchar2_table(68) := '6C656674202E6172726F777B626F726465722D636F6C6F723A7472616E73706172656E74207472616E73706172656E74207472616E73706172656E7420236232633663647D2E746F6F6C6261722D6C696768742E746F6F6C2D7269676874202E6172726F';
wwv_flow_api.g_varchar2_table(69) := '777B626F726465722D636F6C6F723A7472616E73706172656E742023623263366364207472616E73706172656E74207472616E73706172656E747D2E746F6F6C6261722D6C69676874202E746F6F6C2D6974656D3E2E66617B636F6C6F723A236666667D';
wwv_flow_api.g_varchar2_table(70) := '2E746F6F6C6261722D6C69676874202E746F6F6C2D6974656D2E73656C65637465642C2E746F6F6C6261722D6C69676874202E746F6F6C2D6974656D3A686F7665727B6261636B67726F756E643A236436653165353B636F6C6F723A236666667D2E746F';
wwv_flow_api.g_varchar2_table(71) := '6F6C6261722D6461726B7B6261636B67726F756E642D636F6C6F723A233336343334377D2E746F6F6C6261722D6461726B2E746F6F6C2D746F70202E6172726F777B626F726465722D636F6C6F723A23333634333437207472616E73706172656E742074';
wwv_flow_api.g_varchar2_table(72) := '72616E73706172656E747D2E746F6F6C6261722D6461726B2E746F6F6C2D626F74746F6D202E6172726F777B626F726465722D636F6C6F723A7472616E73706172656E74207472616E73706172656E7420233336343334377D2E746F6F6C6261722D6461';
wwv_flow_api.g_varchar2_table(73) := '726B2E746F6F6C2D6C656674202E6172726F777B626F726465722D636F6C6F723A7472616E73706172656E74207472616E73706172656E74207472616E73706172656E7420233336343334377D2E746F6F6C6261722D6461726B2E746F6F6C2D72696768';
wwv_flow_api.g_varchar2_table(74) := '74202E6172726F777B626F726465722D636F6C6F723A7472616E73706172656E742023333634333437207472616E73706172656E74207472616E73706172656E747D2E746F6F6C6261722D6461726B202E746F6F6C2D6974656D3E2E66617B636F6C6F72';
wwv_flow_api.g_varchar2_table(75) := '3A236666667D2E746F6F6C6261722D6461726B202E746F6F6C2D6974656D2E73656C65637465642C2E746F6F6C6261722D6461726B202E746F6F6C2D6974656D3A686F7665727B6261636B67726F756E643A233565363936643B636F6C6F723A23666666';
wwv_flow_api.g_varchar2_table(76) := '7D2E616E696D6174652D7374616E646172647B2D7765626B69742D616E696D6174696F6E3A7374616E64617264416E696D617465202E3373203120656173657D2E616E696D6174652D666C79696E7B2D7765626B69742D616E696D6174696F6E3A726F74';
wwv_flow_api.g_varchar2_table(77) := '617465416E696D617465202E3573203120656173657D2E616E696D6174652D67726F777B2D7765626B69742D616E696D6174696F6E3A67726F77416E696D617465202E3473203120656173657D2E616E696D6174652D666C69707B2D7765626B69742D61';
wwv_flow_api.g_varchar2_table(78) := '6E696D6174696F6E3A666C6970416E696D617465202E3473203120656173657D2E616E696D6174652D626F756E63657B2D7765626B69742D616E696D6174696F6E3A626F756E6365416E696D617465202E3473203120656173652D6F75747D402D776562';
wwv_flow_api.g_varchar2_table(79) := '6B69742D6B65796672616D657320726F74617465416E696D6174657B66726F6D7B7472616E73666F726D3A726F746174652831383064656729207472616E736C617465282D3132307078293B6F7061636974793A307D746F7B7472616E73666F726D3A72';
wwv_flow_api.g_varchar2_table(80) := '6F74617465283029207472616E736C6174652830293B6F7061636974793A317D7D402D7765626B69742D6B65796672616D6573207374616E64617264416E696D6174657B66726F6D7B7472616E73666F726D3A7472616E736C617465592832307078293B';
wwv_flow_api.g_varchar2_table(81) := '6F7061636974793A307D746F7B7472616E73666F726D3A7472616E736C617465592830293B6F7061636974793A317D7D402D7765626B69742D6B65796672616D65732067726F77416E696D6174657B30257B7472616E73666F726D3A7363616C65283029';
wwv_flow_api.g_varchar2_table(82) := '207472616E736C617465592834307078293B6F7061636974793A307D3730257B7472616E73666F726D3A7363616C6528312E3529207472616E736C6174652830297D313030257B7472616E73666F726D3A7363616C65283129207472616E736C61746528';
wwv_flow_api.g_varchar2_table(83) := '30293B6F7061636974793A317D7D402D7765626B69742D6B65796672616D657320726F7461746532416E696D6174657B66726F6D7B7472616E73666F726D3A726F74617465282D3930646567293B7472616E73666F726D2D6F726967696E3A3020313030';
wwv_flow_api.g_varchar2_table(84) := '253B6F7061636974793A307D746F7B7472616E73666F726D3A726F746174652830293B6F7061636974793A317D7D402D7765626B69742D6B65796672616D657320666C6970416E696D6174657B66726F6D7B7472616E73666F726D3A726F746174653364';
wwv_flow_api.g_varchar2_table(85) := '28322C322C322C313830646567293B6F7061636974793A307D746F7B7472616E73666F726D3A726F74617465336428302C302C302C30646567293B6F7061636974793A317D7D402D7765626B69742D6B65796672616D657320626F756E6365416E696D61';
wwv_flow_api.g_varchar2_table(86) := '74657B30257B7472616E73666F726D3A7472616E736C617465592834307078293B6F7061636974793A307D3330257B7472616E73666F726D3A7472616E736C61746559282D34307078297D3730257B7472616E73666F726D3A7472616E736C6174655928';
wwv_flow_api.g_varchar2_table(87) := '32307078297D313030257B7472616E73666F726D3A7472616E736C617465592830293B6F7061636974793A317D7D2E68696464656E7B646973706C61793A6E6F6E657D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(25913825008328333)
,p_plugin_id=>wwv_flow_api.id(28269873535651867)
,p_file_name=>'tlbr/jquery.toolbar.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2266756E6374696F6E22213D747970656F66204F626A6563742E6372656174652626284F626A6563742E6372656174653D66756E6374696F6E2874297B66756E6374696F6E206F28297B7D72657475726E206F2E70726F746F747970653D742C6E657720';
wwv_flow_api.g_varchar2_table(2) := '6F7D292C66756E6374696F6E28742C6F2C65297B76617220693D66756E6374696F6E28742C65297B76617220693D22636F6E7465787475616C546F6F6C626172223B6F2E646562756728697C7C22202D20227C7C742C652C74686973297D2C613D7B696E';
wwv_flow_api.g_varchar2_table(3) := '69743A66756E6374696F6E286F2C65297B692E63616C6C28746869732C617267756D656E74732E63616C6C65652E6E616D652C617267756D656E7473293B76617220613D746869733B612E656C656D3D652C612E24656C656D3D742865292C612E6F7074';
wwv_flow_api.g_varchar2_table(4) := '696F6E733D742E657874656E64287B7D2C742E666E2E746F6F6C6261722E6F7074696F6E732C6F292C612E6D657461646174613D612E24656C656D2E6461746128292C612E6F766572726964654F7074696F6E7328292C612E746F6F6C6261723D742827';
wwv_flow_api.g_varchar2_table(5) := '3C64697620636C6173733D22746F6F6C2D636F6E7461696E657222202F3E27292E616464436C6173732822746F6F6C2D222B612E6F7074696F6E732E706F736974696F6E292E616464436C6173732822746F6F6C6261722D222B612E6F7074696F6E732E';
wwv_flow_api.g_varchar2_table(6) := '7374796C65292E617070656E6428273C64697620636C6173733D22746F6F6C2D6974656D7322202F3E27292E617070656E6428273C64697620636C6173733D226172726F7722202F3E27292E617070656E64546F2822626F647922292E63737328226F70';
wwv_flow_api.g_varchar2_table(7) := '6163697479222C30292E6869646528292C612E746F6F6C6261725F6172726F773D612E746F6F6C6261722E66696E6428222E6172726F7722292C612E696E697469616C697A65546F6F6C62617228297D2C6F766572726964654F7074696F6E733A66756E';
wwv_flow_api.g_varchar2_table(8) := '6374696F6E28297B692E63616C6C28746869732C617267756D656E74732E63616C6C65652E6E616D652C617267756D656E7473293B766172206F3D746869733B742E65616368286F2E6F7074696F6E732C66756E6374696F6E2874297B22756E64656669';
wwv_flow_api.g_varchar2_table(9) := '6E656422213D747970656F66206F2E24656C656D2E646174612822746F6F6C6261722D222B74292626286F2E6F7074696F6E735B745D3D6F2E24656C656D2E646174612822746F6F6C6261722D222B7429297D297D2C696E697469616C697A65546F6F6C';
wwv_flow_api.g_varchar2_table(10) := '6261723A66756E6374696F6E28297B692E63616C6C28746869732C617267756D656E74732E63616C6C65652E6E616D652C617267756D656E7473293B76617220743D746869733B742E706F70756C617465436F6E74656E7428292C742E73657454726967';
wwv_flow_api.g_varchar2_table(11) := '67657228292C742E746F6F6C62617257696474683D742E746F6F6C6261722E776964746828297D2C736574547269676765723A66756E6374696F6E28297B66756E6374696F6E206F28297B612E24656C656D2E686173436C617373282270726573736564';
wwv_flow_api.g_varchar2_table(12) := '22293F6E3D73657454696D656F75742866756E6374696F6E28297B612E6869646528297D2C313530293A636C65617254696D656F7574286E297D66756E6374696F6E206F28297B612E24656C656D2E686173436C61737328227072657373656422293F6E';
wwv_flow_api.g_varchar2_table(13) := '3D73657454696D656F75742866756E6374696F6E28297B612E6869646528297D2C313530293A636C65617254696D656F7574286E297D692E63616C6C28746869732C617267756D656E74732E63616C6C65652E6E616D652C617267756D656E7473293B76';
wwv_flow_api.g_varchar2_table(14) := '617220613D746869733B69662822636C69636B22213D612E6F7074696F6E732E6576656E74297B766172206E3B612E24656C656D2E6F6E287B6D6F757365656E7465723A66756E6374696F6E28297B612E24656C656D2E686173436C6173732822707265';
wwv_flow_api.g_varchar2_table(15) := '7373656422293F636C65617254696D656F7574286E293A612E73686F7728297D7D292C612E24656C656D2E706172656E7428292E6F6E287B6D6F7573656C656176653A66756E6374696F6E28297B6F28297D7D292C7428222E746F6F6C2D636F6E746169';
wwv_flow_api.g_varchar2_table(16) := '6E657222292E6F6E287B6D6F757365656E7465723A66756E6374696F6E28297B636C65617254696D656F7574286E297D2C6D6F7573656C656176653A66756E6374696F6E28297B6F28297D7D297D69662822636C69636B223D3D612E6F7074696F6E732E';
wwv_flow_api.g_varchar2_table(17) := '6576656E74262628612E24656C656D2E6F6E2822636C69636B222C66756E6374696F6E2874297B742E70726576656E7444656661756C7428292C612E24656C656D2E686173436C61737328227072657373656422293F612E6869646528293A612E73686F';
wwv_flow_api.g_varchar2_table(18) := '7728297D292C612E6F7074696F6E732E686964654F6E436C69636B262674282268746D6C22292E6F6E2822636C69636B2E746F6F6C626172222C66756E6374696F6E2874297B742E746172676574213D612E656C656D2626303D3D3D612E24656C656D2E';
wwv_flow_api.g_varchar2_table(19) := '68617328742E746172676574292E6C656E6774682626303D3D3D612E746F6F6C6261722E68617328742E746172676574292E6C656E6774682626612E746F6F6C6261722E697328223A76697369626C6522292626612E6869646528297D29292C612E6F70';
wwv_flow_api.g_varchar2_table(20) := '74696F6E732E686F766572297B766172206E3B612E24656C656D2E6F6E287B6D6F757365656E7465723A66756E6374696F6E28297B612E24656C656D2E686173436C61737328227072657373656422293F636C65617254696D656F7574286E293A612E73';
wwv_flow_api.g_varchar2_table(21) := '686F7728297D7D292C612E24656C656D2E706172656E7428292E6F6E287B6D6F7573656C656176653A66756E6374696F6E28297B6F28297D7D292C7428222E746F6F6C2D636F6E7461696E657222292E6F6E287B6D6F757365656E7465723A66756E6374';
wwv_flow_api.g_varchar2_table(22) := '696F6E28297B636C65617254696D656F7574286E297D2C6D6F7573656C656176653A66756E6374696F6E28297B6F28297D7D297D742865292E726573697A652866756E6374696F6E2874297B742E73746F7050726F7061676174696F6E28292C612E746F';
wwv_flow_api.g_varchar2_table(23) := '6F6C6261722E697328223A76697369626C652229262628612E746F6F6C6261724373733D612E676574436F6F7264696E6174657328612E6F7074696F6E732E706F736974696F6E2C3230292C612E636F6C6C6973696F6E446574656374696F6E28292C61';
wwv_flow_api.g_varchar2_table(24) := '2E746F6F6C6261722E63737328612E746F6F6C626172437373292C612E746F6F6C6261725F6172726F772E63737328612E6172726F7743737329297D297D2C706F70756C617465436F6E74656E743A66756E6374696F6E28297B692E63616C6C28746869';
wwv_flow_api.g_varchar2_table(25) := '732C617267756D656E74732E63616C6C65652E6E616D652C617267756D656E7473293B766172206F3D746869732C613D6F2E746F6F6C6261722E66696E6428222E746F6F6C2D6974656D7322292C6E3D74286F2E6F7074696F6E732E636F6E74656E7429';
wwv_flow_api.g_varchar2_table(26) := '2E636C6F6E65282130292E66696E6428226122292E616464436C6173732822746F6F6C2D6974656D22293B612E68746D6C286E292C612E66696E6428222E746F6F6C2D6974656D22292E6F6E2822636C69636B222C66756E6374696F6E2874297B742E70';
wwv_flow_api.g_varchar2_table(27) := '726576656E7444656661756C7428297D292C612E66696E6428222E746F6F6C2D6974656D22292E6F6E286F2E6F7074696F6E732E6974656D4576656E742C66756E6374696F6E2869297B692E70726576656E7444656661756C7428292C652E6C6F636174';
wwv_flow_api.g_varchar2_table(28) := '696F6E2E687265663D742874686973292E6174747228226872656622292C6F2E24656C656D2E747269676765722822746F6F6C6261724974656D436C69636B22297D297D2C63616C63756C617465506F736974696F6E3A66756E6374696F6E28297B692E';
wwv_flow_api.g_varchar2_table(29) := '63616C6C28746869732C617267756D656E74732E63616C6C65652E6E616D652C617267756D656E7473293B76617220743D746869733B742E6172726F774373733D7B7D2C742E746F6F6C6261724373733D742E676574436F6F7264696E6174657328742E';
wwv_flow_api.g_varchar2_table(30) := '6F7074696F6E732E706F736974696F6E2C742E6F7074696F6E732E61646A7573746D656E74292C742E746F6F6C6261724373732E706F736974696F6E3D226162736F6C757465222C742E746F6F6C6261724373732E7A496E6465783D742E6F7074696F6E';
wwv_flow_api.g_varchar2_table(31) := '732E7A496E6465782C742E636F6C6C6973696F6E446574656374696F6E28292C742E746F6F6C6261722E63737328742E746F6F6C626172437373292C742E746F6F6C6261725F6172726F772E63737328742E6172726F77437373297D2C676574436F6F72';
wwv_flow_api.g_varchar2_table(32) := '64696E617465733A66756E6374696F6E28742C6F297B692E63616C6C28746869732C617267756D656E74732E63616C6C65652E6E616D652C617267756D656E7473293B76617220653D746869733B73776974636828652E636F6F7264696E617465733D65';
wwv_flow_api.g_varchar2_table(33) := '2E24656C656D2E6F666673657428292C6F3D7061727365496E7428652E6F7074696F6E732E61646A7573746D656E74292C652E6F7074696F6E732E706F736974696F6E297B6361736522746F70223A72657475726E7B6C6566743A652E636F6F7264696E';
wwv_flow_api.g_varchar2_table(34) := '617465732E6C6566742D652E746F6F6C6261722E776964746828292F322B652E24656C656D2E6F75746572576964746828292F322C746F703A652E636F6F7264696E617465732E746F702D652E24656C656D2E6F7574657248656967687428292D6F2C72';
wwv_flow_api.g_varchar2_table(35) := '696768743A226175746F227D3B63617365226C656674223A72657475726E7B6C6566743A652E636F6F7264696E617465732E6C6566742D652E746F6F6C6261722E776964746828292F322D652E24656C656D2E6F75746572576964746828292F322D6F2C';
wwv_flow_api.g_varchar2_table(36) := '746F703A652E636F6F7264696E617465732E746F702D652E746F6F6C6261722E68656967687428292F322B652E24656C656D2E6F7574657248656967687428292F322C72696768743A226175746F227D3B63617365227269676874223A72657475726E7B';
wwv_flow_api.g_varchar2_table(37) := '6C6566743A652E636F6F7264696E617465732E6C6566742D652E746F6F6C6261722E776964746828292F322B652E24656C656D2E6F75746572576964746828292F322B6F2C746F703A652E636F6F7264696E617465732E746F702D652E746F6F6C626172';
wwv_flow_api.g_varchar2_table(38) := '2E68656967687428292F322B652E24656C656D2E6F7574657248656967687428292F322C72696768743A226175746F227D3B6361736522626F74746F6D223A72657475726E7B6C6566743A652E636F6F7264696E617465732E6C6566742D652E746F6F6C';
wwv_flow_api.g_varchar2_table(39) := '6261722E776964746828292F322B652E24656C656D2E6F75746572576964746828292F322C746F703A652E636F6F7264696E617465732E746F702B652E24656C656D2E6F7574657248656967687428292B6F2C72696768743A226175746F227D7D7D2C63';
wwv_flow_api.g_varchar2_table(40) := '6F6C6C6973696F6E446574656374696F6E3A66756E6374696F6E28297B692E63616C6C28746869732C617267756D656E74732E63616C6C65652E6E616D652C617267756D656E7473293B766172206F3D746869732C613D32303B22746F7022213D6F2E6F';
wwv_flow_api.g_varchar2_table(41) := '7074696F6E732E706F736974696F6E262622626F74746F6D22213D6F2E6F7074696F6E732E706F736974696F6E7C7C286F2E6172726F774373733D7B6C6566743A22353025222C72696768743A22353025227D2C6F2E746F6F6C6261724373732E6C6566';
wwv_flow_api.g_varchar2_table(42) := '743C613F286F2E746F6F6C6261724373732E6C6566743D612C6F2E6172726F774373732E6C6566743D6F2E24656C656D2E6F666673657428292E6C6566742B6F2E24656C656D2E776964746828292F322D61293A742865292E776964746828292D286F2E';
wwv_flow_api.g_varchar2_table(43) := '746F6F6C6261724373732E6C6566742B6F2E746F6F6C6261725769647468293C612626286F2E746F6F6C6261724373732E72696768743D612C6F2E746F6F6C6261724373732E6C6566743D226175746F222C6F2E6172726F774373732E6C6566743D2261';
wwv_flow_api.g_varchar2_table(44) := '75746F222C6F2E6172726F774373732E72696768743D742865292E776964746828292D6F2E24656C656D2E6F666673657428292E6C6566742D6F2E24656C656D2E776964746828292F322D612D3529297D2C73686F773A66756E6374696F6E28297B692E';
wwv_flow_api.g_varchar2_table(45) := '63616C6C28746869732C617267756D656E74732E63616C6C65652E6E616D652C617267756D656E7473293B76617220743D746869733B742E24656C656D2E616464436C61737328227072657373656422292C742E63616C63756C617465506F736974696F';
wwv_flow_api.g_varchar2_table(46) := '6E28292C742E746F6F6C6261722E73686F7728292E637373287B6F7061636974793A317D292E616464436C6173732822616E696D6174652D222B742E6F7074696F6E732E616E696D6174696F6E292C742E24656C656D2E747269676765722822746F6F6C';
wwv_flow_api.g_varchar2_table(47) := '62617253686F776E22297D2C686964653A66756E6374696F6E28297B692E63616C6C28746869732C617267756D656E74732E63616C6C65652E6E616D652C617267756D656E7473293B76617220743D746869732C6F3D7B6F7061636974793A307D3B7377';
wwv_flow_api.g_varchar2_table(48) := '6974636828742E24656C656D2E72656D6F7665436C61737328227072657373656422292C742E6F7074696F6E732E706F736974696F6E297B6361736522746F70223A6F2E746F703D222B3D3230223B627265616B3B63617365226C656674223A6F2E6C65';
wwv_flow_api.g_varchar2_table(49) := '66743D222B3D3230223B627265616B3B63617365227269676874223A6F2E6C6566743D222D3D3230223B627265616B3B6361736522626F74746F6D223A6F2E746F703D222D3D3230227D742E746F6F6C6261722E616E696D617465286F2C3230302C6675';
wwv_flow_api.g_varchar2_table(50) := '6E6374696F6E28297B742E746F6F6C6261722E6869646528297D292C742E24656C656D2E747269676765722822746F6F6C62617248696464656E22297D2C676574546F6F6C626172456C656D656E743A66756E6374696F6E28297B72657475726E20692E';
wwv_flow_api.g_varchar2_table(51) := '63616C6C28746869732C617267756D656E74732E63616C6C65652E6E616D652C617267756D656E7473292C746869732E746F6F6C6261722E66696E6428222E746F6F6C2D6974656D7322297D7D3B742E666E2E746F6F6C6261723D66756E6374696F6E28';
wwv_flow_api.g_varchar2_table(52) := '6F297B696628742E6973506C61696E4F626A656374286F292972657475726E20746869732E656163682866756E6374696F6E28297B76617220653D4F626A6563742E6372656174652861293B652E696E6974286F2C74686973292C742874686973292E64';
wwv_flow_api.g_varchar2_table(53) := '6174612822746F6F6C6261724F626A222C65297D293B69662822737472696E67223D3D747970656F66206F262630213D3D6F2E696E6465784F6628225F2229297B76617220653D742874686973292E646174612822746F6F6C6261724F626A22292C693D';
wwv_flow_api.g_varchar2_table(54) := '655B6F5D3B72657475726E20692E6170706C7928652C742E6D616B65417272617928617267756D656E7473292E736C696365283129297D7D2C742E666E2E746F6F6C6261722E6F7074696F6E733D7B636F6E74656E743A22236D79436F6E74656E74222C';
wwv_flow_api.g_varchar2_table(55) := '706F736974696F6E3A22746F70222C686964654F6E436C69636B3A21312C7A496E6465783A3165372C686F7665723A21312C7374796C653A2264656661756C74222C616E696D6174696F6E3A227374616E64617264222C61646A7573746D656E743A3130';
wwv_flow_api.g_varchar2_table(56) := '2C6974656D4576656E743A22636C69636B227D7D28617065782E6A51756572792C617065782C77696E646F772C646F63756D656E74293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(25914370507339580)
,p_plugin_id=>wwv_flow_api.id(28269873535651867)
,p_file_name=>'tlbr/jquery.toolbar.min.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
