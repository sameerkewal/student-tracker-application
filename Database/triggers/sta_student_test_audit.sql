create or replace trigger sta_student_test_audit
  after insert or update or delete on sta_student_test
  for each row
  declare
  lv_full_name varchar2(4000) := sta_usr.f_get_usr(nvl(:new.usr_id, :old.usr_id)).first_name || ' ' || sta_usr.f_get_usr(nvl(:new.usr_id, :old.usr_id)).last_name;
  cursor c_get_test_name
  is
    select  name
    from    sta_test
    where   id = nvl(:new.tst_id, :old.tst_id);
  lv_test_name varchar2(4000);

  begin
      open  c_get_test_name;
      fetch c_get_test_name into lv_test_name;
      close c_get_test_name;
      if inserting then
      insert into sta_student_test_audit
(
      student,
      repetitite,
      resultaat,
      actie ,
      actie_datum,
      gedaan_door
      ) values (
      lv_full_name,
      lv_test_name,
      :new.result,
      'Toegevoegd',
      sysdate,
      coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
      );
      elsif updating then
      insert into sta_student_test_audit
(
      student,
      repetitite,
      resultaat,
      actie ,
      actie_datum,
      gedaan_door
      ) values (
      lv_full_name,
      lv_test_name,
      :new.result,
      'Gewijzigd',
      sysdate,
      coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
      );
      elsif deleting then
      insert into sta_student_test_audit
(
      student,
      repetitite,
      resultaat,
      actie ,
      actie_datum,
      gedaan_door
      ) values (
      lv_full_name,
      lv_test_name,
      :old.result,
      'Verwijderd',
      sysdate,
      coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
      );
      end if;
  end;
