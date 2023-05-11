*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${logo}           xpath: //img[@alt="home"]
${first_slide}    xpath://img[@alt="slideshow-0"]
${sample3_title}    xpath: //*[contains(text(), "Sample 3!")]
${english-flag}    xpath: //img[@alt="en"]
${finnish-flag}    xpath: //img[@alt="fi"]
${dropdown-icon}    class:css-tj5bde-Svg    # language-toggler's dropdown-icon
${eng-flag-dropdown-item}    xpath: //img[@data-testid="english-flag"]
${fin-flag-dropdown-item}    xpath: //img[@data-testid="finnish-flag"]


*** Keywords ***
browser_opening
    Open Browser    http://localhost:3000    firefox
    Maximize Browser Window

select_other_language
    [Arguments]    ${language}    # 'en' for english and 'fi' for finnish
    Click Element    ${dropdown-icon}
    IF    ${language} == 'en'
        Click Image    ${eng-flag-dropdown-item}
    ELSE
        Click Image    ${fin-flag-dropdown-item}
    END
