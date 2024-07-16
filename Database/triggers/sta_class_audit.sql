create or replace trigger sta_class_audit
  after insert or update or delete on sta_class
  for each row
  declare
    lv_full_name varchar2(4000) := sta_usr.f_get_usr(nvl(:new.usr_id, :old.usr_id)).first_name || ' ' || sta_usr.f_get_usr(nvl(:new.usr_id, :old.usr_id)).last_name;
    cursor c_get_grde_name
    is
     select name from sta_grade where id = nvl(:new.grde_id, :old.grde_id);
    l_grde_name varchar2(4000);
  begin
      open  c_get_grde_name;
      fetch c_get_grde_name into l_grde_name;
      close c_get_grde_name;
      if inserting then
      insert into sta_class_audit
(
      naam   ,
      leerjaar,
      klassevoogd,
      actie  ,
      actie_datum,
      gedaan_door
      ) values (
      :new.name   ,
      l_grde_name,
      lv_full_name ,
      'Toegevoegd',
      sysdate,
      coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
      );
      elsif updating then
      insert into sta_class_audit
(
      naam   ,
      leerjaar,
      klassevoogd,
      actie  ,
      actie_datum,
      gedaan_door
      ) values (
      :new.name   ,
      l_grde_name,
      lv_full_name ,
      'Gewijzigd',
      sysdate,
      coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
      );
      elsif deleting then
      insert into sta_class_audit
(
      naam   ,
      leerjaar,
      klassevoogd,
      actie  ,
      actie_datum,
      gedaan_door
      ) values (
      :old.name   ,
      l_grde_name,
     lv_full_name ,
      'Verwijderd',
      sysdate,
      coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
      );
      end if;
  end;
