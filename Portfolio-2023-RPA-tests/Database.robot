*** Settings ***
Library           SeleniumLibrary
Resource          resources/resource.resource
Library           JSONLibrary
Library           Collections

*** Variables ***
${table-select}    select[@id="table-select"]
&{table-select-text}    en=Select table!    fi=Valitse taulukko!
${db-table}       table[@data-testid="db-contents-table"]
&{no-connection_warning}    en=No connection!    fi=Yhteyttä ei ole!
&{no-data_warning}    en=no data    fi=ei dataa
${empty_table-name}    empty_table
${non-empty_table-name}    customers



*** Test Cases ***
dbtables&texts
    [Documentation]    This test will open the database page by clicking it in the menu. It then checks the text-elements and the options in table-select-dropdown-menu. The test compares the select-dropdown-menu-options to the values in the json file.
    [Setup]    ${browser-opening}
    Element Should Not Be Visible    xpath: //${central_content-div}
    Click Link    link: ${navbar-links}[data_base][en]
    check_text-elements    en
    select_other_language    'fi'
    check_text-elements    fi
    select_other_language    'en'
    check_text-elements    en
    Element Should Not Be Visible    xpath://p[text()="${no-data_warning}"]
    Element Should Not Be Visible    xpath://p[text()="${no-connection_warning}"]
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

table_items
    [Documentation]    This test opens the database page by clicking it in the menu. It first selects a database-table from the dropdown-select-menu. This sends a request to MySQL database, and then prints the result as a table to the page. Note, that the user must change the ${non-empty_table-name} to a different table name. Otherwise the test will fail. The test reads the json file located in the jsonfiles-folder if it exists and compares the values with the result in the table.
    [Setup]    ${browser-opening}
    Click Link    link: ${navbar-links}[data_base][en]
    Element Should Not Be Visible    xpath://${db-table}
    Select From List By Label    xpath: //${central_content-div}/${table-select}    ${non-empty_table-name}
    Wait Until Element Is Visible    xpath://${central_content-div}/${db-table}
    ${table-content_json}=    Load Json From File    ${CURDIR}${/}jsonfiles/table-content.json
    ${table-item}=    Get Value From Json    ${table-content_json}    [0]
    ${table-dict}=    Get From List    ${table-item}    0
    @{table-item-keys}=    Get Dictionary Keys    ${table-dict}
    FOR    ${key}    IN    @{table-item-keys}
        Element Should Be Visible    xpath://${central_content-div}/${db-table}/thead/tr/th[text()="${key}"]
    END
    ${table-content-length}=    Get Length    ${table-content_json}
    FOR    ${index}    IN RANGE    ${table-content-length}
        ${item-dict}=    Get From List    ${table-content_json}    ${index}
        @{table-item-values}=    Get Dictionary Values    ${item-dict}
        FOR    ${value}    IN    @{table-item-values}
            IF    "${value}" != "None"
                Element Should Be Visible    xpath://${central_content-div}/${db-table}/tbody/tr/th[text()="${value}"]
            END
        END
    END

    [Teardown]    Close Browser

with_no_connection
    [Documentation]    This test checks all the text elements in the database page when the database connection is off. The back-end Portfolio-Server or the MySQL database has to be shut off before running this test.
    [Setup]    ${browser-opening}
    Click Link    link: ${navbar-links}[data_base][en]
    Element Should Not Be Visible    xpath://${db-table}
    Element Should Not Be Visible    xpath: //${table-select}
    Element Should Be Visible    xpath://${central_content-div}/p[text()="${no-connection_warning}[en]"]
    select_other_language    'fi'
    Element Should Not Be Visible    xpath://p[text()="${no-connection_warning}[en]"]
    Element Should Be Visible    xpath://${central_content-div}/p[text()="${no-connection_warning}[fi]"]
    select_other_language    'en'
    Element Should Not Be Visible    xpath://p[text()="${no-connection_warning}[fi]"]
    Element Should Be Visible    xpath://${central_content-div}/p[text()="${no-connection_warning}[en]"]
    [Teardown]    Close Browser

with_no_data
    [Documentation]    This test will open the database page by clicking it in the menu. It then selects a table from the select-dropdown-menu. The aim is to test an empty table in the database and ensure that only a warning message is visible. Note, that the user must change the ${empty_table-name} to a different table name and the table must be empty.
    [Setup]    ${browser-opening}
    Click Link    link: ${navbar-links}[data_base][en]
    Element Should Not Be Visible    xpath://${db-table}
    Select From List By Label    xpath: //${central_content-div}/${table-select}    ${empty_table-name}
    Element Should Not Be Visible    xpath://${db-table}
    Element Should Be Visible    xpath://${central_content-div}/p[text()="${no-data_warning}[en]"]
    select_other_language    'fi'
    Element Should Not Be Visible    xpath://p[text()="${no-data_warning}[en]"]
    Element Should Be Visible    xpath://${central_content-div}/p[text()="${no-data_warning}[fi]"]
    select_other_language    'en'
    Element Should Not Be Visible    xpath://p[text()="${no-data_warning}[fi]"]
    Element Should Be Visible    xpath://${central_content-div}/p[text()="${no-data_warning}[en]"]
    [Teardown]    Close Browser

*** Keywords ***
check_text-elements
    [Arguments]    ${language}
    [Documentation]    This test checks the title and the select-dropdown-menu texts in the database page. It takes language as an argument.
    Element Text Should Be    xpath: //${central_content-div}/${database-title}[locator]    ${database-title}[${language}]
    Wait Until Element Is Visible   xpath: //${central_content-div}/${table-select}/option[1]
    Element Text Should Be    xpath: //${central_content-div}/${table-select}/option[1]    ${table-select-text}[${language}]
