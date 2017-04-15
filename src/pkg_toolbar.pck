CREATE OR REPLACE PACKAGE pkg_toolbar IS

  FUNCTION f_render_tlbr(p_dynamic_action IN apex_plugin.t_dynamic_action, p_plugin IN apex_plugin.t_plugin)
    RETURN apex_plugin.t_dynamic_action_render_result;

END pkg_toolbar;
/
CREATE OR REPLACE PACKAGE BODY pkg_toolbar IS

   g_default_separator constant varchar2(1) := ';';

  g_max_pl_varchar2_def varchar2(32767);

  subtype t_max_pl_varchar2 is g_max_pl_varchar2_def%type;

  g_icon_col constant number(1) := 1;

  g_value_col constant number(1) := 2;

  g_title_col constant number(1) := 3;

  function get_nth_token(p_text in varchar2, p_num in number, p_separator in varchar2 := g_default_separator)
    return varchar2 as
    l_pos_begin pls_integer;
    l_pos_end pls_integer;
    l_returnvalue t_max_pl_varchar2;
  begin
    if p_num <= 0 then
      return null;
    elsif p_num = 1 then
      l_pos_begin := 1;
    else
      l_pos_begin := instr(p_text, p_separator, 1, p_num - 1);
    end if;
    -- separator may be the first character
    l_pos_end := instr(p_text, p_separator, 1, p_num);
    if l_pos_end > 1 then
      l_pos_end := l_pos_end - 1;
    end if;
    if l_pos_begin > 0 then
      -- find the last element even though it may not be terminated by separator
      if l_pos_end <= 0 then
        l_pos_end := length(p_text);
      end if;
      -- do not include separator character in output
      if p_num = 1 then
        l_returnvalue := substr(p_text, l_pos_begin, l_pos_end - l_pos_begin + 1);
      else
        l_returnvalue := substr(p_text, l_pos_begin + 1, l_pos_end -
                                 l_pos_begin);
      end if;
    else
      l_returnvalue := null;
    end if;
    return l_returnvalue;
  exception
    when others then
      return null;
  end get_nth_token;

  function get_token_count(p_text in varchar2, p_separator in varchar2 := g_default_separator)
    return number as
    l_pos pls_integer;
    l_counter pls_integer := 0;
    l_returnvalue number;
  begin
    if p_text is null then
      l_returnvalue := 0;
    else
      loop
        l_pos := instr(p_text, p_separator, 1, l_counter + 1);
        if l_pos > 0 then
          l_counter := l_counter + 1;
        else
          exit;
        end if;
      end loop;
      l_returnvalue := l_counter + 1;
    end if;
    return l_returnvalue;
  end get_token_count;

  function is_numeric(p_value varchar2) return number is
    v_new_num number;
  begin
    v_new_num := to_number(p_value);
    return 1;
  exception
    when others then
      return 0;
  end is_numeric;

  function prepare_url(p_page_num varchar, p_app_num number default null)
    return varchar2 is
    v_app number := APEX_APPLICATION.g_flow_id;
    v_session number := apex_application.g_instance;
    v_debug varchar2(10) := v('DEBUG');
  begin
    if p_app_num is not null then
      v_app := p_app_num;
    end if;
    return apex_util.prepare_url(p_url => 'f?p=' || v_app || ':' ||
                                          p_page_num || ':' || v_session || '::' ||
                                          v_debug || '::', p_checksum_type => 'SESSION');
  end prepare_url;

  function prepare_url(p_url varchar2) return varchar2 is
  begin
    return apex_util.prepare_url(p_url => p_url, p_checksum_type => 'SESSION');
  end prepare_url;

  function get_page_id_from_list_entry(p_url varchar2) return number is
  begin
    return regexp_substr(p_url, 'f\?p=&APP_ID\.:(\d+).*', 1, 1, 'i', 1);
  end get_page_id_from_list_entry;

  FUNCTION f_render_tlbr(p_dynamic_action IN apex_plugin.t_dynamic_action, p_plugin IN apex_plugin.t_plugin)
    RETURN apex_plugin.t_dynamic_action_render_result AS
    V_APP_ID APEX_APPLICATIONS.APPLICATION_ID%TYPE := apex_application.g_flow_id;
    V_PAGE_ID APEX_APPLICATION_PAGES.PAGE_ID%TYPE := apex_application.g_flow_step_id;
    -- Application Plugin Attributes
    -- DA Plugin Attributes
    atr_src_type p_dynamic_action.attribute_01%type := p_dynamic_action.attribute_01;
    atr_static_vals p_dynamic_action.attribute_02%type := p_dynamic_action.attribute_02;
    --atr_03 p_dynamic_action.attribute_03%type := p_dynamic_action.attribute_03;
    atr_list p_dynamic_action.attribute_04%type := p_dynamic_action.attribute_04;
    atr_sql_qry p_dynamic_action.attribute_05%type := p_dynamic_action.attribute_05;
    --atr_06 p_dynamic_action.attribute_06%type := p_dynamic_action.attribute_06;
    atr_aff_el_style p_dynamic_action.attribute_07%type := lower(p_dynamic_action.attribute_07);
    atr_style p_dynamic_action.attribute_08%type := lower(p_dynamic_action.attribute_08);
    atr_position p_dynamic_action.attribute_09%type := p_dynamic_action.attribute_09;
    atr_adjustment p_dynamic_action.attribute_10%type := p_dynamic_action.attribute_10;
    atr_animation p_dynamic_action.attribute_11%type := p_dynamic_action.attribute_11;
    atr_event p_dynamic_action.attribute_12%type := p_dynamic_action.attribute_12;
    atr_hideOnClick p_dynamic_action.attribute_13%type := p_dynamic_action.attribute_13;
   -- atr_14 p_dynamic_action.attribute_14%type := p_dynamic_action.attribute_14;
    atr_actionEvent p_dynamic_action.attribute_15%type := p_dynamic_action.attribute_15;
    -- Return
    l_result apex_plugin.t_dynamic_action_render_result;
    -- Other variables
    l_html varchar2(32767);
    l_src_id varchar2(1000) := 'toolbar-options_' ||
                               round(dbms_random.value(1, 100000));
    l_js_code varchar2(32767);
    ---Source Type
    ----------------------
    l_stat_lst_varr wwv_flow_global.vc_arr2;

    ---STATIC
    l_value varchar2(32767);
    l_icon varchar2(32767);
    l_title varchar2(32767);
    --LIST QUERY
    l_query clob;
    l_lst_type varchar2(50);
    l_lov apex_plugin_util.t_column_value_list;
    --LIST STATIC
    cursor c_apx_list(p_app_id in number, p_list_name in varchar2) is
      select ale.entry_image icon, ale.entry_target value, ale.entry_text title
        from apex_application_list_entries ale
       where ale.application_id = p_app_id and ale.list_name = p_list_name;
    --affected Elements
    ----------------------------------------
    l_elm_selector varchar2(1000);
    l_elm_code varchar2(1000);
    -- Convert Y/N to True/False (text)
    -- Default to true
    FUNCTION f_yn_2_truefalse_str(p_val IN VARCHAR2) RETURN VARCHAR2 AS
    BEGIN
      RETURN case NVL(p_val, 'N') when 'Y' then 'true' else 'false' end;
    END f_yn_2_truefalse_str;

  BEGIN
    -- Debug information (if app is being run in debug mode)
    IF apex_application.g_debug THEN
      apex_plugin_util.debug_dynamic_action(p_plugin => p_plugin, p_dynamic_action => p_dynamic_action);
    END IF;
    ---Source Content Generation
    -- parse static2 value
    if atr_src_type = 'STATIC' then
      l_html := '<div id="' || l_src_id || '" class="hidden">';
      if upper(substr(atr_static_vals, 1, 7)) = 'STATIC2' then
        atr_static_vals := substr(atr_static_vals, 9);
      elsif upper(substr(atr_static_vals, 1, 6)) = 'STATIC' then
        atr_static_vals := substr(atr_static_vals, 8);
      else
        atr_static_vals := atr_static_vals;
      end if;
      l_stat_lst_varr := wwv_flow_utilities.string_to_table2(atr_static_vals, ',');
      for i in 1 .. l_stat_lst_varr.count loop
        /*   wwv_flow.show_error_message(p_message => get_token_count(l_stat_lst_varr(i)),
        p_footer  => l_stat_lst_varr(i));*/
        if get_token_count(l_stat_lst_varr(i)) >= 2 then
          l_icon := trim(get_nth_token(l_stat_lst_varr(i), g_icon_col));
          l_value := trim(get_nth_token(l_stat_lst_varr(i), g_value_col));
          if get_token_count(l_stat_lst_varr(i)) >= 3 then
            l_title := trim(get_nth_token(l_stat_lst_varr(i), g_title_col));
          end if;
        else
          wwv_flow.show_error_message(p_message => '--Configuration Error STATIC LIST--', p_footer => 'Refer to the Documentation.');
        end if;
        if instr(l_value, 'http') = 0 and is_numeric(l_value) = 1 then
          l_value := prepare_url(p_page_num => l_value);
          if instr(l_value, 'apex.nav') = 0 then
            l_value := 'javascript:apex.navigation.redirect(' ||
                       apex_javascript.ADD_VALUE(l_value, FALSE) || ')';
          end if;
          l_value := htf.escape_sc(l_value);
        elsif (instr(lower(l_value), 'f?p=') >= 1) Then
          l_value := prepare_url(p_url => apex_plugin_util.replace_substitutions(l_value));
          if instr(l_value, 'apex.nav') = 0 then
            l_value := 'javascript:apex.navigation.redirect(' ||
                       apex_javascript.ADD_VALUE(l_value, FALSE) || ')';
          end if;
          l_value := htf.escape_sc(l_value);
        elsif (instr(Upper(l_value), 'WWW') >= 1) then
          if instr(Upper(l_value), 'HTTP') = 0 then
            l_value := 'http://' || l_value;
          end if;
          l_value := htf.escape_sc('javascript:apex.navigation.redirect(' ||
                                   apex_javascript.ADD_VALUE(apex_plugin_util.replace_substitutions(l_value), FALSE) || ')');
        Else
          IF instr(lower(l_value), 'javascript:') = 0 then
            l_value := 'javascript:' ||
                       apex_escape.html_whitelist(apex_plugin_util.replace_substitutions(l_value));
          else
            l_value := apex_escape.html_whitelist(apex_plugin_util.replace_substitutions(l_value));
          end if;
        end if;
        l_value := apex_javascript.ADD_VALUE(l_value);
        -- wwv_flow.show_error_message(p_message => l_value);
        l_html := l_html || '<a  title="' || l_title || '" href=' ||
                  l_value || ' ><i class="t-Icon fa ' || l_icon ||
                  '" aria-hidden="true"></i></a>';
      end loop;
      l_html := l_html || '</div>';
    elsif atr_src_type = 'QUERY' then
      l_html := '<div id="' || l_src_id || '" class="hidden">';
      l_lov := apex_plugin_util.get_data(p_sql_statement => atr_sql_qry, p_min_columns => 2, p_max_columns => 3, p_component_name => p_dynamic_action.action);
      for i in 1 .. l_lov(g_icon_col).count loop
        l_icon := l_lov(g_icon_col) (i);
        l_value := l_lov(g_value_col) (i);
        if l_lov.exists(g_title_col) then
          l_title := l_lov(g_title_col) (i);
        end if;
        if instr(l_value, 'http') = 0 and is_numeric(l_value) = 1 then
          l_value := prepare_url(p_page_num => l_value);
          if instr(l_value, 'apex.nav') = 0 then
            l_value := 'javascript:apex.navigation.redirect(' ||
                       apex_javascript.ADD_VALUE(l_value, FALSE) || ')';
          end if;
          l_value := htf.escape_sc(l_value);
        elsif (instr(lower(l_value), 'f?p=') >= 1) Then
          l_value := prepare_url(p_url => apex_plugin_util.replace_substitutions(l_value));
          if instr(l_value, 'apex.nav') = 0 then
            l_value := 'javascript:apex.navigation.redirect(' ||
                       apex_javascript.ADD_VALUE(l_value, FALSE) || ')';
          end if;
          l_value := htf.escape_sc(l_value);
        elsif (instr(Upper(l_value), 'WWW') >= 1) then
          if instr(Upper(l_value), 'HTTP') = 0 then
            l_value := 'http://' || l_value;
          end if;
          l_value := htf.escape_sc('javascript:apex.navigation.redirect(' ||
                                   apex_javascript.ADD_VALUE(apex_plugin_util.replace_substitutions(l_value), FALSE) || ')');
        Else
          IF instr(lower(l_value), 'javascript:') = 0 then
            l_value := 'javascript:' ||
                       apex_escape.html_whitelist(apex_plugin_util.replace_substitutions(l_value));
          else
            l_value := apex_escape.html_whitelist(apex_plugin_util.replace_substitutions(l_value));
          end if;
        end if;
        l_value := apex_javascript.ADD_VALUE(l_value);
        l_html := l_html || '<a  title="' || l_title || '" href=' ||
                  l_value || ' ><i class="t-Icon fa ' || l_icon ||
                  '" aria-hidden="true"></i></a>';
      end loop;
      l_html := l_html || '</div>';
    elsif atr_src_type = 'LIST' then
      select max(al.list_type_code)
        into l_lst_type
        from apex_application_lists al
       where al.application_id = v_app_id and al.list_name = atr_list;
      IF l_lst_type is NULL then
        wwv_flow.show_error_message(p_message => '--Contextual Toolbar Plugin Error--', p_footer => atr_list ||
                                                 ' ,invalid list name entered in configuration.');
      end if;
      --STATIC
      --SQL_QUERY
      l_html := '<div id="' || l_src_id || '" class="hidden">';
      if l_lst_type = 'SQL_QUERY' then
        select max(al.list_query)
          into l_query
          from apex_application_lists al
         where al.application_id = v_app_id and al.list_name = atr_list;
        l_lov := apex_plugin_util.get_data(p_sql_statement => l_query, p_min_columns => 2, p_max_columns => 3, p_component_name => p_dynamic_action.action);
        for i in 1 .. l_lov(g_icon_col).count loop
          l_icon := l_lov(g_icon_col) (i);
          l_value := l_lov(g_value_col) (i);
          if l_lov.exists(g_title_col) then
            l_title := l_lov(g_title_col) (i);
          end if;
          if instr(l_value, 'http') = 0 and is_numeric(l_value) = 1 then
            l_value := prepare_url(p_page_num => l_value);
            if instr(l_value, 'apex.nav') = 0 then
              l_value := 'javascript:apex.navigation.redirect(' ||
                         apex_javascript.ADD_VALUE(l_value, FALSE) || ')';
            end if;
            l_value := htf.escape_sc(l_value);
          elsif (instr(lower(l_value), 'f?p=') >= 1) Then
            l_value := prepare_url(p_url => apex_plugin_util.replace_substitutions(l_value));
            if instr(l_value, 'apex.nav') = 0 then
              l_value := 'javascript:apex.navigation.redirect(' ||
                         apex_javascript.ADD_VALUE(l_value, FALSE) || ')';
            end if;
            l_value := htf.escape_sc(l_value);
          elsif (instr(Upper(l_value), 'WWW') >= 1) then
            if instr(Upper(l_value), 'HTTP') = 0 then
              l_value := 'http://' || l_value;
            end if;
            l_value := htf.escape_sc('javascript:apex.navigation.redirect(' ||
                                     apex_javascript.ADD_VALUE(apex_plugin_util.replace_substitutions(l_value), FALSE) || ')');
          Else
            IF instr(lower(l_value), 'javascript:') = 0 then
              l_value := 'javascript:' ||
                         apex_escape.html_whitelist(apex_plugin_util.replace_substitutions(l_value));
            else
              l_value := apex_escape.html_whitelist(apex_plugin_util.replace_substitutions(l_value));
            end if;
          end if;
          l_value := apex_javascript.ADD_VALUE(l_value);
          l_html := l_html || '<a  title="' || l_title || '" href=' ||
                    l_value || ' ><i class="t-Icon fa ' || l_icon ||
                    '" aria-hidden="true"></i></a>';
        end loop;
      elsif l_lst_type = 'STATIC' THEN
        for rec in c_apx_list(v_app_id, atr_list) loop
          l_icon := rec.icon;
          l_value := rec.value;
          l_title := rec.title;
          if (instr(lower(l_value), 'f?p=') >= 1) Then
            l_value := prepare_url(p_url => apex_plugin_util.replace_substitutions(l_value));
            if instr(l_value, 'apex.nav') = 0 then
              l_value := 'javascript:apex.navigation.redirect(' ||
                         apex_javascript.ADD_VALUE(l_value, FALSE) || ')';
            end if;
            l_value := htf.escape_sc(l_value);
          elsif (instr(Upper(l_value), 'WWW') >= 1) then
            if instr(Upper(l_value), 'HTTP') = 0 then
              l_value := 'http://' || l_value;
            end if;
            l_value := htf.escape_sc('javascript:apex.navigation.redirect(' ||
                                     apex_javascript.ADD_VALUE(apex_plugin_util.replace_substitutions(l_value), FALSE) || ')');
          Else
            IF instr(lower(l_value), 'javascript:') = 0 then
              l_value := 'javascript:' ||
                         apex_escape.html_whitelist(apex_plugin_util.replace_substitutions(l_value));
            else
              l_value := apex_escape.html_whitelist(apex_plugin_util.replace_substitutions(l_value));
            end if;
          end if;
          l_value := apex_javascript.ADD_VALUE(l_value);
          l_html := l_html || '<a  title="' || l_title || '" href=' ||
                    l_value || ' ><i class="t-Icon fa ' || l_icon ||
                    '" aria-hidden="true"></i></a>';
        end loop;
      end if;
      l_html := l_html || '</div>';
      ----atr_src_type = 'LIST'
    End if; --atr_src_type
    l_js_code := '$(''' || l_html || ''').appendTo("body");';
    apex_javascript.add_onload_code(p_code => l_js_code);
    l_js_code := '';
    SELECT case max(AFFECTED_ELEMENTS_TYPE_CODE)
              WHEN 'ITEM' THEN
               max(APEX_PLUGIN_UTIL.PAGE_ITEM_NAMES_TO_JQUERY(aapda.AFFECTED_ELEMENTS))
              WHEN 'BUTTON' THEN
               max('#' ||
                   nvl(aapb.button_static_id, 'B' || aapda.affected_button_id))
              WHEN 'REGION' THEN
               max('#' ||
                   nvl(aapr.STATIC_ID, 'R' || aapda.affected_button_id))
              WHEN 'JQUERY_SELECTOR' THEN
               max(aapda.AFFECTED_ELEMENTS)
            end as static_id
      INTO l_elm_selector
      FROM apex_application_page_da_acts aapda, apex_application_page_regions aapr, apex_application_page_items aapi, apex_application_page_buttons aapb
     WHERE aapda.action_id = p_dynamic_action.ID
          -- AND aapda.application_id = 104
           AND aapda.affected_region_id = aapr.region_id(+) and
           aapda.affected_elements = aapi.item_name(+) and
           aapda.affected_button_id = aapb.button_id(+);
    apex_javascript.add_library(p_name => 'jquery.toolbar.min', p_directory => p_plugin.file_prefix ||
                                                'tlbr/', p_version => NULL, p_skip_extension => FALSE);
    apex_css.add_file(p_name => 'jquery.toolbar', p_directory => p_plugin.file_prefix ||
                                      'tlbr/');
    IF atr_aff_el_style is not null then
      l_elm_code := '$(''' || l_elm_selector || ''').addClass(''' ||
                    'btn-toolbar-' || atr_aff_el_style || ''');';
    end if;
    l_js_code := apex_javascript.add_attribute('hideOnClick', case
                                                 atr_hideOnClick
                                                  when 'Y' then
                                                   true
                                                  else
                                                   false
                                                end); -- atr_hideOnClick);
    IF atr_style is not null then
      l_js_code := l_js_code ||
                   apex_javascript.add_attribute('style', atr_style);
    end if;
    l_js_code := l_js_code ||
                 apex_javascript.add_attribute('itemEvent', atr_actionEvent);
    l_js_code := l_js_code ||
                 apex_javascript.add_attribute('position', atr_position);
    if atr_adjustment is not null then
      l_js_code := l_js_code ||
                   apex_javascript.add_attribute('adjustment', atr_adjustment);
    end if;
    l_js_code := l_js_code ||
                 apex_javascript.add_attribute('animation', atr_animation);
    l_js_code := l_js_code ||
                 apex_javascript.add_attribute('event', atr_event);
    l_js_code := l_js_code ||
                 apex_javascript.add_attribute('content', sys.htf.escape_sc('#' ||
                                                                  l_src_id), false, false);
    l_js_code := l_elm_code || '$(''' || l_elm_selector || ''').toolbar({' ||
                 l_js_code || '});';
    apex_javascript.add_onload_code(p_code => l_js_code);
    l_result.javascript_function :='function (){ ' || l_js_code || '; debugger; if(this.action.waitForResult == true){apex.da.resume( this.resumeCallback, false );}}';
    RETURN l_result;
  END f_render_tlbr;


END pkg_toolbar;
/
