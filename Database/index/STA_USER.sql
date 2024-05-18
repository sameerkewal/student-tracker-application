create unique index sta_usr_ix2
    on sta_user (lower("EMAIL"))
/

drop index sta_usr_ix1;