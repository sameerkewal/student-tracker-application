--This view will be used to display all necessary columns for caretakers.


create or replace view sta_vw_caretaker
as
    with w_caretaker as(
        select usr.id 
        ,      usr.first_name     
        ,      usr.last_name      
        ,      usr.address1       
        ,      usr.address2       
        ,      usr.phone_number1  
        ,      usr.phone_number2
        ,      usr.remarks      
        from   sta_user usr
        join   sta_user_role usr_rle on usr.id = usr_rle.usr_id
        join   sta_role rle on usr_rle.rle_id = rle.id
        where  lower(rle.name) = lower('caretaker')
        and    usr.deleted_flg = false
    )
    select * from w_caretaker;
