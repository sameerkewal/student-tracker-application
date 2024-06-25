create unique index sta_evnt_ix1
    on sta_event (lower(name), start_date, end_date)
/

