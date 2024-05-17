create or replace package body sta_git
is
    --global variables

    function f_get_all_repos return varchar2
    is
    l_response CLOB;
    l_username VARCHAR2(100) := 'sameerkewal'; -- Replace 'octocat' with the GitHub username you want to retrieve information for
    lt_parm_names      apex_application_global.VC_ARR2; 
    lt_parm_values     apex_application_global.VC_ARR2; 
    l_names            varchar2(4000);
BEGIN
    -- lt_parm_names(1)  := 'Authorization'; 
    -- lt_parm_values(1) := 'token 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'; -- Replace 'YOUR_TOKEN' with your GitHub Personal Access Token
    -- lt_parm_names(2)  := 'User-Agent'; 
    -- lt_parm_values(2) := 'sameerkewal'; 
    
    apex_web_service.set_request_headers (
        p_name_01  => 'User-Agent', 
        p_value_01 => 'sameerkewal',
        p_name_02  => 'Authorization', 
        p_value_02 =>  sta_sypa.f_get_parameter(pi_parameter => 'GIT_TOKEN'),
        p_reset    => TRUE
    ); 
    
    apex_web_service.oauth_set_token(p_token => 'token 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');

    l_response := apex_web_service.make_rest_request(
        p_url => 'https://api.github.com/user/repos',
        p_http_method => 'GET',
        p_wallet_path => 'file:/opt/oracle/product/23c/dbhomeFree/admin/FREE/tls_wallet5',
        p_wallet_pwd => 'Sadk2005!'
    );

    -- Print the status code
    DBMS_OUTPUT.put_line('Status Code: ' || apex_web_service.g_status_code);

    -- Use JSON_TABLE to parse the response and extract repository names
    FOR rec IN (
        SELECT repo_name
        FROM JSON_TABLE(
            l_response,
            '$[*]' COLUMNS (
                repo_name VARCHAR2(4000) PATH '$.name'
            )
        )
    ) LOOP
        DBMS_OUTPUT.put_line('Repository Name: ' || rec.repo_name);
        l_names := l_names || CHR(13) || rec.repo_name;
    end loop;

    return l_names;

    exception
    when others then
        dbms_output.put_line('error: ' || sqlerrm);
    end f_get_all_repos;
end sta_git;