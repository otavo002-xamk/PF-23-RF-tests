*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${logo}           img[@alt="home"]
${english-flag}    img[@alt="en"]
${finnish-flag}    img[@alt="fi"]
${dropdown-icon}    class:css-tj5bde-Svg    # language-toggler's dropdown-icon
${eng-flag-dropdown-item}    img[@data-testid="english-flag"]
${fin-flag-dropdown-item}    img[@data-testid="finnish-flag"]
${central_content-div}    div[@class="p-12 lg:p-0"]
&{math-game-link}    en=Math Game    fi=Matikkapeli    path=MathGame
&{nasa-api-link}    en=NASA API    fi=NASA API    path=nasaAPI
&{database-link}    en=Database    fi=Tietokanta    path=dataBase
&{sample4-link}    en=Sample 4    fi=Näyte 4    path=sample4
&{navbar-links}    math_game=${math-game-link}    nasa_api=${nasa-api-link}    data_base=${database-link}    sample_4=${sample4-link}
${toggle-to-dark}    img[@alt="moon"]
${toggle-to-light}    img[@alt="sun"]
${header}         div[@class="p-2 bg-header bg-cover absolute w-full bg-red-600 h-40 shadow-header"]
${top-left-corner}    div[@class="float-left"]
${top-right-corner}    div[@class="float-right"]
${browser-opening}    full-width_opening
&{database-title}    locator=h1    en=Database!    fi=TIetokanta!

*** Keywords ***
full-width_opening
    [Documentation]    opens the browser and maximizes the browser window in full-screen width
    Open Browser    http://localhost:3000    firefox
    Maximize Browser Window

select_other_language
    [Arguments]    ${language}    # 'en' for english and 'fi' for finnish
    [Documentation]    uses the language-dropdown-icon in the top-right corner of the page and selects the language that is given as argument
    Click Element    ${dropdown-icon}
    IF    ${language} == 'en'
        Click Image    xpath: //${header}/${top-right-corner}//${eng-flag-dropdown-item}
    ELSE
        Click Image    xpath: //${header}/${top-right-corner}//${fin-flag-dropdown-item}
    END

small-width_opening
    [Documentation]    opens the browser, then shrinks the browser width so that the responsive layout changes, then opens the navbar-menu
    Open Browser    http://localhost:3000    firefox
    Set Window Size    1023    952
    Set Window Position    0    0
    Click Element    xpath: //div[@data-testid="menu-container"]
