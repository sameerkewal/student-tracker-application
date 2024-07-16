create or replace trigger sta_semester_audit
  after insert or update or delete on sta_semester
  for each row
  begin
      if inserting then
      insert into sta_semester_audit
(
      naam      ,
      schooljaar,
      start_datum,
      eind_datum,
      actief    ,
      actie     ,
      actie_datum,
      gedaan_door
      ) values (
      :new.name      ,
      :new.schoolyear,
      :new.start_date,
      :new.end_date  ,
      :new.active_ind,
      'Toegevoegd',
      sysdate,
      coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
      );
      elsif updating then
      insert into sta_semester_audit
(
      naam      ,
      schooljaar,
      start_datum,
      eind_datum,
      actief    ,
      actie     ,
      actie_datum,
      gedaan_door
      ) values (
      :new.name      ,
      :new.schoolyear,
      :new.start_date,
      :new.end_date  ,
      :new.active_ind,
      'Gewijzigd',
      sysdate,
      coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
      );
      elsif deleting then
      insert into sta_semester_audit
(
      naam      ,
      schooljaar,
      start_datum,
      eind_datum,
      actief    ,
      actie     ,
      actie_datum,
      gedaan_door
      ) values (
      :old.name      ,
      :old.schoolyear,
      :old.start_date,
      :old.end_date  ,
      :old.active_ind,
      'Verwijderd',
      sysdate,
      coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
      );
      end if;
  end;
