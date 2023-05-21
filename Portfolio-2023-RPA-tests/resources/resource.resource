*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${logo}           xpath: //img[@alt="home"]
${first_slide}    xpath://img[@alt="slideshow-0"]
${sample3_title}    xpath: //h1[text()="Sample 3!"]
${english-flag}    xpath: //img[@alt="en"]
${finnish-flag}    xpath: //img[@alt="fi"]
${dropdown-icon}    class:css-tj5bde-Svg    # language-toggler's dropdown-icon
${eng-flag-dropdown-item}    xpath: //img[@data-testid="english-flag"]
${fin-flag-dropdown-item}    xpath: //img[@data-testid="finnish-flag"]
${central_content-div}    div[@class="p-12 lg:p-0"]
&{math-game-link}    en=Math Game    fi=Matikkapeli    path=MathGame
&{nasa-api-link}    en=NASA API    fi=NASA API    path=nasaAPI
&{sample3-link}    en=Sample 3    fi=Näyte 3    path=sample3
&{sample4-link}    en=Sample 4    fi=Näyte 4    path=sample4
&{navbar-links}    math_game=${math-game-link}    nasa_api=${nasa-api-link}    sample_3=${sample3-link}    sample_4=${sample4-link}
${content-title}    ${central_content-div}//h1

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
