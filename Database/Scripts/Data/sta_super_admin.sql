declare
    l_salt varchar2(64) := sta_app_security.f_generate_salt;
begin
    insert into sta_user(
                          first_name
                        , last_name
                        , date_of_birth
                        , address1
                        , phone_number1
                        , email
                        , password
                        , salt
    )
    values ( 'Super Admin'
           , 'Super Admin'
           , to_date('1-1-1970', 'dd-mm-yyyy')
           , 'Hindilaan'
           , '7298604'
           , 'sameerkewal1@gmail.com'
           , sta_app_security.f_hash_password(pi_password => 'SuperAdmin', pi_salt=> l_salt)
           , l_salt
           );
end;
/
--couple super admin role with super admin user
insert into sta_user_role
                         (
                           usr_id
                         , rle_id
                         )values(
                              (select id from sta_user where email = 'sameerkewal1@gmail.com')
                            , (select id from sta_role where name = 'Super Admin')
                        );
commit;




---Verify if user was added
-- select  *
-- from    sta_user
-- where   email = 'sameerkewal1@gmail.com'
-- ;


----Delete user for some reason?
-- delete from sta_user
-- where  email = 'sameerkewal1@gmail.com'
-- ;