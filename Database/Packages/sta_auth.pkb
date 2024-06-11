create or replace  package body sta_auth
is

  -- procedure used to upsert privileges
  -- And couple the authorizations to the privileges
  procedure upsert_pve( pi_id          sta_privilege.id%type
                        , pi_name        sta_privilege.name%type
                        , pi_description sta_privilege.description%type
                        , pi_auths       varchar2
                        )
  is
    l_pve_id sta_privilege.id%type;
  begin
    if pi_id is null then
      insert into sta_privilege 
      ( 
        name
      , description
      )
      values
      (
        pi_name
      , pi_description
      )returning id into l_pve_id
      ;
      for r in (
                select  column_value as auth_id
                from    table(apex_string.split(pi_auths, ':'))
                )loop
        insert into sta_authorization_privilege
        (
          auth_id
        , pve_id
        )
        values
        (
          r.auth_id
        , l_pve_id
        );
      end loop;
    else
      delete from sta_authorization_privilege
      where  pve_id = pi_id;
      
      for r in (
                select  column_value as auth_id
                from    table(apex_string.split(pi_auths, ':'))
                )loop
        insert into sta_authorization_privilege
        (
          auth_id
        , pve_id
        )
        values
        (
          r.auth_id
        , pi_id
        );
      end loop;
      update sta_privilege
      set
        name        = pi_name
      , description = pi_description
      where id = pi_id;
      end if;
    end upsert_pve;

    procedure delete_pve( pi_id sta_privilege.id%type)
    is
    begin
      delete from sta_privilege
      where id = pi_id;
    end delete_pve;


    -- procedure used to upsert authorizations
    -- Not used(but keeping just in case)
  procedure upsert_auth( pi_id                  sta_authorization.id%type
                       , pi_apex_component_type sta_authorization.apex_component_type%type 
                       , pi_name                sta_authorization.name%type
                       , pi_apex_component_name    sta_authorization.apex_component_name%type
                       , pi_apex_page              sta_authorization.apex_page%type
                      -- , pi_row_operation          sta_authorization.apex_page%type
                       )
  is
  begin
    if pi_id is null then
      insert into sta_authorization 
      ( 
        name
      , apex_component_type
      , apex_component_name
      , apex_page
      )
      values
      (
          pi_name
        , pi_apex_component_type             
        , pi_apex_component_name 
        , pi_apex_page           
      );
    else
      update sta_authorization
      set
        name                = pi_name
      , apex_component_type = pi_apex_component_type
      , apex_component_name = apex_component_name
      , apex_page           = apex_page
      where id = pi_id;
    end if;
  end upsert_auth;

  procedure delete_auth( pi_id sta_authorization.id%type)
  is
  begin
    delete from sta_authorization
    where id = pi_id;
  end delete_auth;

  function f_generate_authorization_name( pi_apex_component_type varchar2
                                        , pi_apex_component_name sta_authorization.apex_component_name%type
                                        , pi_apex_page           sta_authorization.apex_page%type
                                        , pi_row_operation       sta_authorization.row_operation%type
                                        , pi_read_only           sta_authorization.read_only%type
                                        )return sta_authorization.name%type
  is
    l_generated_name sta_authorization.name%type;
    cursor c_get_navigation_name(b_entry_text apex_application_list_entries.entry_text%type)
    is
     select case
         when parent_entry_text is null and list_name = 'Navigation Menu' then
             'Hoofdmenu: ' || entry_text
         when parent_entry_text is not null and list_name = 'Navigation Menu' then
             'Submenu: ' || entry_text || ' (' || parent_entry_text || ')'
         when parent_entry_text is null and list_name in (select column_value from table(apex_string.split(sta_sypa.f_get_parameter(pi_parameter => 'PARENT_LISTS'), ','))) then
           'User Defined List: ' || entry_text || ' (' || list_name || ')'
          else
           'Unknown Navigation'
     end as navigation_name
    from apex_application_list_entries
    where list_name in (
        select column_value
        from table(apex_string.split(sta_sypa.f_get_parameter(pi_parameter => 'PARENT_LISTS'), ','))
    )
    and entry_text = b_entry_text;

      cursor c_get_apex_page_name(b_apex_page_id apex_application_pages.page_id%type)
      is
        select  page_name
        from    apex_application_pages
        where   page_id = b_apex_page_id
        ;

    l_nav_name        apex_application_list_entries.entry_text%type;
    l_apex_page_name  apex_application_pages.page_name%type;

  begin


    if pi_apex_component_type in ('REG', 'BUTTONS', 'PAGE_ITEMS', 'PAGE', 'IG') then
      open  c_get_apex_page_name(b_apex_page_id => pi_apex_page);
      fetch c_get_apex_page_name into l_apex_page_name;
      close c_get_apex_page_name;
    end if;

    case pi_apex_component_type
      when 'NAV' then
        -- extra processing
        open  c_get_navigation_name( b_entry_text => pi_apex_component_name);
        fetch c_get_navigation_name into l_nav_name;
        close c_get_navigation_name;
        --
        l_generated_name := 'Navigation ' || l_nav_name;
        --
      when 'REG' then
        --
        l_generated_name := 'Page ' || pi_apex_page || ': '|| l_apex_page_name || ' - Region: ' || pi_apex_component_name;
        --
      when 'BUTTONS' then
        l_generated_name := 'Page ' || pi_apex_page || ': ' || l_apex_page_name || ' - Button: ' || pi_apex_component_name;
        --
      when 'PAGE_ITEMS' then
        --
        l_generated_name := 'Page ' || pi_apex_page ||': '|| l_apex_page_name ||  ' - Item: '   || pi_apex_component_name;
        --
      when 'PAGE' then
        --
        l_generated_name := 'Page ' || pi_apex_page || ': ' || l_apex_page_name;
        --
      when 'IG' then
        l_generated_name := 'Page ' || pi_apex_page || ': ' || l_apex_page_name || ' - Interactive Grid: ' || pi_apex_component_name || ' - ' || case pi_row_operation 
                                                                                                                                                   when 'I' then 'Insert' 
                                                                                                                                                   when 'U' then 'Update' 
                                                                                                                                                   when 'D' then 'Delete' 
                                                                                                                                                   else 'Unknown Row Operation' end; 
      when null then
        l_generated_name := null;
      else
        l_generated_name := 'Unknown Component Type';
    end case;

    if pi_read_only = 'Y' then
      l_generated_name := l_generated_name || ' - Read Only';
    end if;
     
    return l_generated_name;
  end f_generate_authorization_name;
end sta_auth;
