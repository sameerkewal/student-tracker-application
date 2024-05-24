declare
    l_salt   sta_user.salt%type := sta_app_security.f_generate_salt;
    l_usr_id sta_user.id%type;
begin
insert into sta_user(     first_name
                        , last_name
                        , address1
                        , phone_number1
                        , email
                        , password
                        , salt
    )values(
            'Admin'
          , 'Admin'
          , 'Admin Street'
          , '7298604'
          , 'admin@gmail.com'
          , sta_app_security.f_hash_password(pi_password => 'Admin', pi_salt=> l_salt)
          , l_salt
    )returning id into l_usr_id;
    -- select id into l_usr_id from sta_user where email = 'admim@gmail.com';

    dbms_output.put_line('Inserted with id: ' || l_usr_id);
    insert into sta_user_role
                          (
                            usr_id
                          , rle_id
                          )values(
                               l_usr_id
                             , (select id from sta_role where name = 'Admin')
                         );
end;
/

-- Verification
-- select  *
-- from    sta_user
-- where   email = 'admin@gmail.com';   

-- select *
-- from    STA_USER_ROLE usr_rle
-- join    sta_user usr on usr_rle.usr_id = usr.id
-- where   usr.email = 'admin@gmail.com';

-- Delete???
-- delete from sta_user
-- where   email = 'admin@gmail.com';   

commit;