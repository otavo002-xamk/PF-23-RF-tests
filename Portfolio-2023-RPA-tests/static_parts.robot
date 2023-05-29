*** Settings ***
Library           SeleniumLibrary
Resource          resources/resource.resource

*** Test Cases ***
homepage-button
    [Setup]    ${browser-opening}
    frontpage_opening
    ${navbar_is_not_visible?}=    Run Keyword And Return Status    Element Should Not Be Visible    link: ${navbar-links}[sample_3][en]
    IF    ${navbar_is_not_visible?}
        Click Element    xpath: //div[@data-testid="menu-container"]
    END
    Click Link    link: ${navbar-links}[sample_3][en]
    Element Text Should Be    xpath: //${central_content-div}/h1    ${sample3-title}
    Element Should Not Be Visible    xpath: //img[@alt="slideshow-0"]
    Click Image    xpath: //${header}/${top-left-corner}//${logo}
    frontpage_opening
    [Teardown]    Close Browser

theme-toggler
    [Setup]    ${browser-opening}
    Element Attribute Value Should Be    tag:body    class    \
    Click Image    xpath: //${header}/${top-right-corner}//${toggle-to-dark}
    Element Attribute Value Should Be    tag:body    class    dark
    Click Image    xpath: //${header}/${top-right-corner}//${toggle-to-light}
    Element Attribute Value Should Be    tag:body    class    \
    [Teardown]    Close Browser

language-toggler
    [Setup]    ${browser-opening}
    this_flag_should_be_visible    "en"
    check_menu_items    en
    select_other_language    "fi"
    this_flag_should_be_visible    "fi"
    check_menu_items    fi
    select_other_language    "en"
    this_flag_should_be_visible    "en"
    check_menu_items    en
    [Teardown]    Close Browser

navbar
    [Setup]    ${browser-opening}
    Click Element    xpath: //${header}/${top-left-corner}//${logo}
    Set Window Size    1023    952
    check_closed_menu-items

    Click Element    xpath: //div[@data-testid="menu-container"]
    check_menu_items    en
    Click Element    xpath: //div[@data-testid="menu-container"]
    check_closed_menu-items
    Click Element    xpath: //div[@data-testid="menu-container"]
    check_menu_items    en
    Click Element    xpath: //${header}/${top-left-corner}//${logo}
    check_closed_menu-items


    [Teardown]    Close Browser

*** Keywords ***
frontpage_opening
    Element Should Be Visible    xpath: //img[@alt="slideshow-0"]
    Element Should Not Be Visible    ${central_content-div}

this_flag_should_be_visible
    [Arguments]    ${flag}
    IF    ${flag} == "en"
        Element Should Be Visible    xpath: //${header}/${top-right-corner}//${english-flag}
        Element Should Not Be Visible    xpath: //${finnish-flag}
    ELSE
        Element Should Be Visible    xpath: //${header}/${top-right-corner}//${finnish-flag}
        Element Should Not Be Visible    xpath: //${english-flag}
    END

check_menu_items
    [Arguments]    ${language}
    [Documentation]    checks texts in each menu-item is in correct language
    FOR    ${link}    IN    &{navbar-links}
        Element Text Should Be    xpath:// a[@href="/${link[1]['path']}"]    ${link}[1][${language}]
    END

check_closed_menu-items
    FOR    ${link}    IN    &{navbar-links}
        Element Should Not Be Visible    ${link[1]['en']}
    END
