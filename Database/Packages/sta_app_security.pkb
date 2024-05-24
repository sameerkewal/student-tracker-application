create or replace package body sta_app_security
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


    -- main function to check if user is authorized to access the application
  function f_is_usr_authenticated( p_username sta_user.email%type, p_password sta_user.password%type) return boolean
  is
    lc_salt_password_rec constant t_salt_password_rec  := f_get_salt_and_password(pi_email => p_username);
  begin
    -- if user is deleted, return false
  if sta_usr.f_get_usr_by_email(pi_email => p_username).deleted_flg then
    return false;
  end if;
    --
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


  function f_is_component_authorized ( pi_application_id      in number
                                     , pi_email               in sta_user.email%type
                                     , pi_apex_page_id        in number
                                     , p_component_type       in varchar2
                                     , pi_component_id        in number
                                     , pi_apex_component_name in sta_authorization.apex_component_name%type
                                     , pi_read_only           in sta_authorization.read_only%type default false
                                     , pi_auth_type            in varchar2
                                     ) return boolean
  is
    l_result number := 0;

    cursor c_usr_auths( b_email               sta_user.email%type
                      , b_apex_page_id        sta_authorization.apex_page%type
                      , b_apex_component_name sta_authorization.apex_component_name%type
                      , b_read_only           boolean                      
                      )
    is
      select 1
      from   sta_vw_user_authentication usr_auth
      where  lower(usr_auth.usr_email)                        = lower(b_email)
      and    coalesce(usr_auth.auth_apex_page, 0)             = coalesce(b_apex_page_id, usr_auth.auth_apex_page, 0)
      and    coalesce(usr_auth.auth_apex_component_name, 'x') = coalesce(b_apex_component_name, usr_auth.auth_apex_component_name, 'x')
      and    coalesce(usr_auth.auth_read_only, false)         = coalesce(b_read_only, usr_auth.auth_read_only, false)
      ;


  begin
  
    -- debugging start
    apex_debug.message('Authorization starting for ' || pi_auth_type);

    apex_debug.message('pi_application_id     => '|| pi_application_id);
    apex_debug.message('pi_email              => '|| pi_email);
    apex_debug.message('pi_apex_page_id       => '|| pi_apex_page_id);
    apex_debug.message('p_component_type      => '|| p_component_type);
    apex_debug.message('pi_component_id       => '|| pi_component_id);
    apex_debug.message('pi_apex_component_name=> '|| pi_apex_component_name);
    apex_debug.message('pi_read_only          => '|| case when pi_read_only then 'true' else 'false' end);
    -- debugging end


    open c_usr_auths( b_email               => pi_email
                    , b_apex_page_id        => pi_apex_page_id
                    , b_apex_component_name => pi_apex_component_name
                    , b_read_only           => pi_read_only
                    );
    fetch c_usr_auths into l_result;
    close c_usr_auths;

    if l_result = 1 then
      return true;
    else
      return false;
    end if;
    
  end f_is_component_authorized;

  -- function is_page_authorized( pi_application_id in number
  --                            , pi_email in sta_user.email%type, pi_apex_page_id in number
  --                            , pi_apex_page_id sta_user.apex_page%type
  --                            ) return boolean
  -- is
    
  -- begin
    
  -- end;





end sta_app_security;
/
