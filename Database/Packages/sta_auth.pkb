create or replace package body sta_auth 
is
    -- Global Variables
  type t_salt_password_rec is record( salt     sta_user.salt%type
                                      , password sta_user.password%type
                                      );
  
  --Password item on Page 14
  g_page14_pw_item               constant varchar2(100) := 'P14_WACHTWOORD';
  c_inline_with_field            constant varchar2(40):='INLINE_WITH_FIELD';
  c_inline_with_field_and_notif  constant varchar2(40):='INLINE_WITH_FIELD_AND_NOTIFICATION';
  c_inline_in_notification       constant varchar2(40):='INLINE_IN_NOTIFICATION';
  c_on_error_page                constant varchar2(40):='ON_ERROR_PAGE';

    -- function to generate a random salt
  function f_generate_salt return varchar2 is
    l_salt raw(32);
  begin
    l_salt:=   dbms_crypto.randombytes(32);
    return rawtohex(l_salt);
  end f_generate_salt;

    -- function to hash a password with a salt
  function f_hash_password(pi_password sta_user.password%type, pi_salt sta_user.salt%type) return varchar2 is
    l_hashed_password raw(64);
  begin
    l_hashed_password := dbms_crypto.hash(utl_raw.cast_to_raw(pi_password || pi_salt), dbms_crypto.hash_sh256);
    return rawtohex(l_hashed_password);
  end f_hash_password;

    -- function to validate a password
  function f_validate_password(pi_password sta_user.password%type, pi_salt sta_user.salt%type, pi_hashed_password varchar2) return boolean is
  begin
    return f_hash_password(pi_password, pi_salt) = pi_hashed_password;
  end f_validate_password;

  function f_get_salt_and_password(pi_email sta_user.email%type) return t_salt_password_rec
  is
    l_salt_password_rec t_salt_password_rec;
    
    cursor c_salt_password(b_email sta_user.email%type)
    is
      select  usr.salt
      ,       usr.password 
      from    sta_user usr
      where   lower(email) = lower(b_email)
      ;
  begin
    open  c_salt_password(b_email => pi_email);
    fetch c_salt_password into l_salt_password_rec;
    close c_salt_password;
    return l_salt_password_rec;

  exception
    when others then
      close c_salt_password;
    raise;
  end f_get_salt_and_password;


    -- function to check if user is authorized to access the application
  function f_is_usr_authenticated( p_username sta_user.email%type, p_password sta_user.password%type) return boolean
  is
    lc_salt_password_rec constant t_salt_password_rec  := f_get_salt_and_password(pi_email => p_username);
  begin
    return f_validate_password(pi_password => p_password, pi_salt => lc_salt_password_rec.salt, pi_hashed_password => lc_salt_password_rec.password);
  end f_is_usr_authenticated;


  function f_password_length_chk(pi_password sta_user.password%type) return boolean
  is
  begin
    if length(pi_password) not between 8 and 120 then
      apex_error.add_error ( p_message          => 'Het wachtwoord moet minimaal 8 karakters en maximaal 120 karakters zijn'
                           , p_display_location =>  c_inline_with_field_and_notif  
                           );
      return false;
    else
      return true;
    end if;
  end f_password_length_chk;

  function f_password_capital_chk(pi_password sta_user.password%type) return boolean
  is
  begin
    if (sys.ora_complexity_check(pi_password, uppercase => 1))
      then
        return true;
    end if;
      exception
        when others then
          apex_error.add_error ( p_message          => 'Het wachtwoord moet minimaal één hoofdletter bevatten'
                               , p_display_location =>  c_inline_with_field_and_notif  
                               );
          return false;
  end f_password_capital_chk;

  function f_password_letter_chk(pi_password sta_user.password%type) return boolean
  is
  begin
    if (sys.ora_complexity_check(pi_password, lowercase => 1))
      then
        return true;
    end if;
    exception
      when others then
        apex_error.add_error ( p_message          => 'Het wachtwoord moet minimaal één kleinletter bevatten'
                               , p_display_location =>  c_inline_with_field_and_notif  
                               );
        return false;
  end f_password_letter_chk;

  function f_password_numeric_chk(pi_password sta_user.password%type) return boolean
  is
  begin
    if (sys.ora_complexity_check(pi_password, digit => 1))
      then
        return true;
    end if;
    exception
      when others then
        apex_error.add_error ( p_message          => 'Het wachtwoord moet minimaal één cijfer bevatten'
                               , p_display_location =>  c_inline_with_field_and_notif  
                               );
        return false;
  end f_password_numeric_chk;
  
function f_password_special_chk(pi_password sta_user.password%type) return boolean
is
    l_result boolean := false;
begin
    begin
        -- Check for at least one special character
        if sys.ora_complexity_check(pi_password, special => 1) then
            l_result := true;
        end if;
    exception
        when others then
            IF SQLCODE = -20000 THEN
                apex_error.add_error (
                    p_message          => 'Het wachtwoord moet minimaal één speciale karakter bevatten',
                    p_display_location => c_inline_with_field_and_notif
                );
            else
                raise; -- Re-raise unexpected exceptions
            end if;
    end;
    
    return l_result;
end f_password_special_chk;



  function f_password_chk(pi_password sta_user.password%type) return boolean
  is
    l_valid_length boolean := true;
    l_valid_capital boolean := true;
    l_valid_letter boolean := true;
    l_valid_digital boolean := true;
    l_valid_special boolean := true;
  begin
    -- check password length
    l_valid_length := f_password_length_chk(pi_password => pi_password);

    -- check for at least one uppercase letter
    l_valid_capital := f_password_capital_chk(pi_password => pi_password);

    -- check for at least one lowercase letter
    l_valid_letter := f_password_letter_chk(pi_password => pi_password);

    -- check for at least one numeric character
    l_valid_digital := f_password_numeric_chk(pi_password => pi_password);

    --check for at least one special character;
    l_valid_special := f_password_special_chk(pi_password => pi_password);

    -- return true if all checks are valid
    return l_valid_length and l_valid_capital and l_valid_letter and l_valid_digital and l_valid_special;
  end f_password_chk;


  function f_is_component_authorized ( p_application_id in number
                                     , pi_apex_page_id  in number
                                     , p_component_type in varchar2
                                     , p_component_id   in number
                                     , pi_apex_component_name in sta_authorization.apex_component_name%type
                                     ) return boolean
  is
  begin
    null;
  end f_is_component_authorized;

  function f_generate_authorization_name( pi_apex_component_type varchar2
                                        , pi_apex_component_name sta_authorization.apex_component_name%type
                                        , pi_apex_page           sta_authorization.apex_page%type
                                        )return sta_authorization.name%type
  is
    l_generated_name sta_authorization.name%type;
    cursor c_get_navigation_name(b_entry_text apex_application_list_entries.entry_text%type)
    is
     select case
         when parent_entry_text is null then
             'Hoofdmenu: ' || entry_text
         else
             'Submenu: ' || entry_text || ' (' || parent_entry_text || ')'
     end as navigation_name
    from apex_application_list_entries
    where list_name in (
        select column_value
        from table(apex_string.split(sta_sypa.f_get_parameter(pi_parameter => 'P27_PARENT_LISTS'), ','))
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


    if pi_apex_component_type in ('REG', 'BUTTONS', 'PAGE_ITEMS', 'PAGE') then
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
      else
        l_generated_name := 'Unknown Component Type';
    end case;
    return l_generated_name;
  end f_generate_authorization_name;



end sta_auth;
/
