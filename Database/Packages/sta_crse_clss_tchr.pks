    create or replace package sta_crse_clss_tchr
    is
        type t_crse_clss_tchr_rec is record( crse_id     sta_course.id%type
                                        , classes_ids varchar2(4000)  -- Colon-delimited clss_ids
                                        , action      varchar2(1)
                                        );
        type t_crse_clss_tchr_tab is table of t_crse_clss_tchr_rec;

        procedure upsert_crse_clss_tchr( pi_usr_id             in sta_user.id%type
                                    , pi_crse_clss_tchr_tab in t_crse_clss_tchr_tab
                                        );
        
        function f_tchr_subj_cnt(pi_id           in sta_user.id%type)
        return number;
    end sta_crse_clss_tchr;
