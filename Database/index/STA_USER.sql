create unique index sta_usr_ix1
    on sta_user (lower("FIRST_NAME"), lower("LAST_NAME"), lower("ADDRESS1"))
/

create unique index sta_usr_ix2
    on sta_user (lower("EMAIL"))
/

