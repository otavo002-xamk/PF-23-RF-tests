*** Settings ***
Library           SeleniumLibrary
Resource          resources/resource.resource
Library           JSONLibrary
Library           Collections

*** Variables ***
${table-select}    select[@id="table-select"]




*** Test Cases ***
with_connection
    [Setup]    ${browser-opening}
    Element Should Not Be Visible    xpath: //${central_content-div}
    Click Link    link: ${navbar-links}[data_base][en]
    Element Text Should Be    xpath: //${central_content-div}/${database-title}[locator]    ${database-title}[en]
    ${tables_json}=    Load Json From File    ${CURDIR}${/}jsonfiles/alltables.json
    ${table_length}=    Get Length    ${tables_json}
    FOR    ${i}    IN RANGE    ${table_length}
    ${current_item}=    Get Value From Json    ${tables_json}    [${i}]
    ${current_dict}=    Get From List    ${current_item}    0
    ${current_list}=    Get Dictionary Values    ${current_dict}
    ${current_value}=    Get From List    ${current_list}    0
        Element Text Should Be    xpath: //${central_content-div}/${table-select}/option[${i+2}]    ${current_value}
    END
    [Teardown]    Close Browser
