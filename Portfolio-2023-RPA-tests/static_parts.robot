*** Settings ***
Library           SeleniumLibrary
Resource          resources/resource.resource

*** Test Cases ***
homepage-button
    [Documentation]    checks the home-button-logo in the top-left corner works as expected and navigates to the front page
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
    [Documentation]    checks the theme-toggler button in the top-right corner works as expected and changes the color-theme of the webpage
    [Setup]    ${browser-opening}
    Element Attribute Value Should Be    tag:body    class    \
    Click Image    xpath: //${header}/${top-right-corner}//${toggle-to-dark}
    Element Attribute Value Should Be    tag:body    class    dark
    Click Image    xpath: //${header}/${top-right-corner}//${toggle-to-light}
    Element Attribute Value Should Be    tag:body    class    \
    [Teardown]    Close Browser

language-toggler
    [Documentation]    checks the language toggler in the top-right corner works as expected and changes the language of the page
    [Setup]    ${browser-opening}
    this_flag_should_be_visible    "en"
    Element Should Not Be Visible    xpath: //${eng-flag-dropdown-item}
    Element Should Not Be Visible    xpath: //${fin-flag-dropdown-item}
    Click Element    ${dropdown-icon}
    Element Should Be Visible    xpath: //${header}/${top-right-corner}//${eng-flag-dropdown-item}
    Element Should Be Visible    xpath: //${header}/${top-right-corner}//${fin-flag-dropdown-item}
    Click Element    ${dropdown-icon}
    Element Should Not Be Visible    xpath: //${eng-flag-dropdown-item}
    Element Should Not Be Visible    xpath: //${fin-flag-dropdown-item}
    check_menu_items    en
    select_other_language    "fi"
    this_flag_should_be_visible    "fi"
    check_menu_items    fi
    select_other_language    "en"
    this_flag_should_be_visible    "en"
    check_menu_items    en
    [Teardown]    Close Browser

navbar
    [Documentation]    The test checks that the navbar works as expected in the small screen. It should open and close from the burger-menu-button and also close automatically when path gets updated.
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
    [Documentation]    checks only the front page is visible
    Element Should Be Visible    xpath: //img[@alt="slideshow-0"]
    Element Should Not Be Visible    ${central_content-div}

this_flag_should_be_visible
    [Arguments]    ${flag}
    [Documentation]    checks the flag given in argument is visible and no other flag
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
    [Documentation]    checks the navbar menu-items are not visible when the menu is closed
    FOR    ${link}    IN    &{navbar-links}
        Element Should Not Be Visible    ${link[1]['en']}
    END
