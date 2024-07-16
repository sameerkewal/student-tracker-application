create or replace trigger sta_test_audit
  after insert or update or delete on sta_test
  for each row
    declare
  cursor c_get_smsr_name
  is
    select name from sta_semester where id = nvl(:new.smsr_id, :old.smsr_id);
    l_smsr_name varchar2(4000);

  cursor c_get_grde_name
  is
     select name from sta_grade where id = nvl(:new.grde_id, :old.grde_id);
  l_grde_name varchar2(4000);

  cursor c_get_crse
  is
        select name from sta_course where id = nvl(:new.crse_id, :old.crse_id);
  l_crse_name varchar2(4000);
  begin
      -- Fetch the semester name
      open c_get_smsr_name;
      fetch c_get_smsr_name into l_smsr_name;
      close c_get_smsr_name;

      -- Fetch the grade name
      open c_get_grde_name;
      fetch c_get_grde_name into l_grde_name;
      close c_get_grde_name;

      -- Fetch the course name
      open c_get_crse;
      fetch c_get_crse into l_crse_name;
      close c_get_crse;
      if inserting then
      insert into sta_test_audit
(
      naam            ,
      kwartaal        ,
      leerjaar        ,
      vak             ,
      gepland_op      ,
      actie,
      actie_datum,
      gedaan_door
      ) values (
      :new.name          ,
      l_smsr_name        ,
      l_grde_name        ,
      l_crse_name        ,
      :new.datetime_planned      ,
      'Ingevoerd',
      sysdate,
      coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
      );
      elsif updating then
      insert into sta_test_audit
(
      naam            ,
      kwartaal        ,
      leerjaar        ,
      vak             ,
      gepland_op      ,
      actie           ,
      actie_datum     ,
      gedaan_door
      ) values (
      :new.name            ,
      l_smsr_name        ,
      l_grde_name        ,
      l_crse_name        ,
      :new.datetime_planned      ,
      'Gewijzigd',
      sysdate,
      coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
      );
      elsif deleting then
      insert into sta_test_audit
(
      naam            ,
      kwartaal        ,
      leerjaar        ,
      vak             ,
      gepland_op      ,
      actie           ,
      actie_datum     ,
      gedaan_door
      ) values (
      :old.name            ,
      l_smsr_name        ,
      l_grde_name        ,
      l_crse_name        ,
      :old.datetime_planned      ,
      'Verwijderd',
      sysdate,
      coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
      );
      end if;
  end;
