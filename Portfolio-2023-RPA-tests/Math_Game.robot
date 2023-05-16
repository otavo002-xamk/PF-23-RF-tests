*** Settings ***
Library           SeleniumLibrary
Resource          resources/resource.resource

*** Variables ***
${math-game-title}    ${central_content-div}//h1
${ready?}         ${central_content-div}//p[text()="Ready?" or text()="Oletko valmis?"]
${start-button}    xpath: //button[text()="Start!" or text()="Aloita!"]
${start-over-button}    xpath: //button[text()="Start over." or text()="Aloita alusta."]
${status_or_result}    ${central_content-div}//p[contains(text(), "Time left") or text()="Time ended!" or text()="Correct!" or text()="Wrong!" or contains(text(), "Aikaa jäljellä") or text()="Aika loppui!" or text()="Oikein!" or text()="Väärin!"]

*** Test Cases ***
checking_components
    browser_opening
    Element Should Not Be Visible    ${math-game-title}
    Element Should Not Be Visible    ${ready?}
    Click Link    link: Math Game
    check_start-page-elements    'en'
    select_other_language    'fi'
    check_start-page-elements    'fi'
    select_other_language    'en'
    check_start-page-elements    'en'
    Click Button    ${start-button}
    Element Should Be Visible    ${math-game-title}
    Element Should Not Be Visible    ${ready?}
    Element Text Should Be    ${start-over-button}    Start over.
    Element Should Contain    ${status_or_result}    Time left:
    select_other_language    'fi'
    Element Text Should Be    ${start-over-button}    Aloita alusta.
    Element Should Contain    ${status_or_result}    Aikaa jäljellä
    select_other_language    'en'
    Element Text Should Be    ${start-over-button}    Start over.
    Element Should Contain    ${status_or_result}    Time left
    Element Should Be Disabled    xpath: //button[contains(text(), "NEXT ❯")]
    ${sum}    calculate_sum    0
    Click Element    xpath: //td[text()="${sum}"]
    ${correct-count}    Get Element Count    xpath: //td[text()="${sum}"]
    Element Should Be Visible    xpath: //td[text()="${sum}"][1]//img[@alt="correct"]
    Element Should Not Be Visible    xpath: //td[text()="${sum}"][1]//preceding::td//img[@alt="correct"]
    Element Should Not Be Visible    xpath: //td[text()="${sum}"][${correct-count}]//following-sibling::td//img[@alt="correct"]
    Element Should Not Be Visible    xpath: //img[@alt="incorrect"]
    Element Text Should Be    ${status_or_result}    Correct!
    select_other_language    'fi'
    Element Text Should Be    ${status_or_result}    Oikein!
    select_other_language    'en'
    Element Text Should Be    ${status_or_result}    Correct!
    Click Element    xpath: //button[text()="NEXT ❯"]

*** Keywords ***
calculate_sum
    [Arguments]    ${equation-number}
    ${random1}    Get Text    xpath: //div[@data-testid="random-number-${equation-number}-0"]
    ${random2}    Get Text    xpath: //div[@data-testid="random-number-${equation-number}-1"]
    ${random3}    Get Text    xpath: //div[@data-testid="random-number-${equation-number}-2"]
    ${sum}    evaluate    ${random1}+${random2}+${random3}
    [Return]    ${sum}

check_start-page-elements
    [Arguments]    ${language}
    IF    ${language} == "en"
        Element Text Should Be    ${math-game-title}    Math Game!
        Element Text Should Be    ${ready?}    Ready?
        Element Text Should Be    ${start-button}    Start!
    ELSE
        Element Text Should Be    ${math-game-title}    Matikkapeli!
        Element Text Should Be    ${ready?}    Oletko valmis?
        Element Text Should Be    ${start-button}    Aloita!
    END
