create or replace trigger sta_event_audit
  after insert or update or delete on sta_event
  for each row
  begin
      if inserting then
      insert into sta_event_audit
(
      id        ,
      naam      ,
      start_datum,
      eind_datum  ,
      actie,
      actie_datum,
      gedaan_door
      ) values (
      :new.id        ,
      :new.name      ,
      :new.start_date,
      :new.end_date  ,
      'Ingevoerd',
      sysdate,
      coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
      );
      elsif updating then
      insert into sta_event_audit
(
      id        ,
      naam      ,
      start_datum,
      eind_datum  ,
      actie,
      actie_datum,
      gedaan_door
      ) values (
      :new.id        ,
      :new.name      ,
      :new.start_date,
      :new.end_date  ,
      'Gewijzigd',
      sysdate,
      coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
      );
      elsif deleting then
      insert into sta_event_audit
(
      id        ,
      naam      ,
      start_datum,
      eind_datum  ,
      actie,
      actie_datum,
      gedaan_door
      ) values (
      :old.id        ,
      :old.name      ,
      :old.start_date,
      :old.end_date  ,
      'Verwijderd',
      sysdate,
      coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
      );
      end if;
  end;
