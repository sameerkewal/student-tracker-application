create or replace trigger sta_grade_audit
  after insert or update or delete on sta_grade
  for each row
  begin
      if inserting then
      insert into sta_grade_audit
(
      naam          ,
      omschrijving  ,
      examen_leerjaar,
      actie         ,
      actie_datum   ,
      gedaan_door
      ) values (
      :new.name          ,
      :new.description   ,
      :new.exam_grade_flg,
      'Toegevoegd',
      sysdate,
      coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
      );
      elsif updating then
      insert into sta_grade_audit
(
      naam          ,
      omschrijving  ,
      examen_leerjaar,
      actie         ,
      actie_datum   ,
      gedaan_door
      ) values (
      :new.name          ,
      :new.description   ,
      :new.exam_grade_flg,
      'Gewijzigd',
      sysdate,
      coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
      );
      elsif deleting then
      insert into sta_grade_audit
(
      naam          ,
      omschrijving  ,
      examen_leerjaar,
      actie         ,
      actie_datum   ,
      gedaan_door
      ) values (
      :old.name          ,
      :old.description   ,
      :old.exam_grade_flg,
      'Verwijderd',
      sysdate,
      coalesce(regexp_substr(sys_context('userenv', 'client_identifier'), '^[^:]*'), user)
      );
      end if;
  end;
