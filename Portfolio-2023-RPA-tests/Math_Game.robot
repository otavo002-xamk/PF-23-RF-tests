*** Settings ***
Library           SeleniumLibrary
Resource          resources/resource.resource

*** Variables ***
${math-game-title}    ${central_content-div}//h1
${ready?}         ${central_content-div}//p[text()="Ready?" or text()="Oletko valmis?"]
${start-button}    xpath: //button[text()="Start!" or text()="Aloita!"]
${start-over-button}    xpath: //button[text()="Start over." or text()="Aloita alusta."]
${status}         ${central_content-div}//p[contains(text(), "Time left") or contains(text(), "Aikaa jäljellä")]
${progress-bar}    ${central_content-div}//div[@class="progressbar-progress"]
${result}         ${central_content-div}//p[text()="Time ended!" or text()="Correct!" or text()="Wrong!" or text()="Aika loppui!" or text()="Oikein!" or text()="Väärin!"]
${options-table-0}    xpath: //tbody[@data-testid="equation-options-table-tb-0"]
${options-table-1}    xpath: //tbody[@data-testid="equation-options-table-tb-1"]
${options-table-2}    xpath: //tbody[@data-testid="equation-options-table-tb-2"]
${options-table-3}    xpath: //tbody[@data-testid="equation-options-table-tb-3"]
${options-table-4}    xpath: //tbody[@data-testid="equation-options-table-tb-4"]




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
    Element Should Not Be Visible    ${start-over-button}
    check_equation-number-elements    6
    Element Should Not Be Visible    ${status}
    Element Should Not Be Visible    ${progress-bar}
    Click Button    ${start-button}
    Element Should Be Visible    ${math-game-title}
    Element Should Not Be Visible    ${ready?}
    Element Text Should Be    ${start-over-button}    Start over.
    Element Should Contain    ${status}    Time left
    select_other_language    'fi'
    Element Text Should Be    ${start-over-button}    Aloita alusta.
    Element Should Contain    ${status}    Aikaa jäljellä
    select_other_language    'en'
    Element Text Should Be    ${start-over-button}    Start over.
    Element Should Contain    ${status}    Time left
    check_equation-number-elements    0
    Element Should Be Visible    ${progress-bar}
    Element Should Not Be Visible    ${result}
    Element Should Be Disabled    xpath: //button[contains(text(), "NEXT ❯")]
    ${sum}    calculate_sum    0
    Click Element    xpath: //td[text()="${sum}"]
    ${correct-count}    Get Element Count    xpath: //td[text()="${sum}"]
    Element Should Be Visible    xpath: //td[text()="${sum}"][1]//img[@alt="correct"]
    Element Should Not Be Visible    xpath: //td[text()="${sum}"][1]//preceding::td//img[@alt="correct"]
    Element Should Not Be Visible    xpath: //td[text()="${sum}"][${correct-count}]//following-sibling::td//img[@alt="correct"]
    Element Should Not Be Visible    xpath: //img[@alt="incorrect"]
    Element Should Not Be Visible    ${status}
    Element Text Should Be    ${result}    Correct!
    select_other_language    'fi'
    Element Text Should Be    ${result}    Oikein!
    select_other_language    'en'
    Element Text Should Be    ${result}    Correct!
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

check_equation-number-elements
    [Arguments]    ${equation-number}
    IF    ${equation-number} == 6
        FOR    ${i}    IN RANGE    ${5}
            Element Should Not Be Visible    ${options-table-${i}}
        END
        FOR    ${i}    IN RANGE    ${5}
            FOR    ${j}    IN RANGE    ${3}
                Element Should Not Be Visible    xpath: //div[@data-testid="random-number-${i}-${j}"]
            END
        END
    ELSE
        FOR    ${i}    IN RANGE    ${5}
            IF    ${i} == ${equation-number}
                Element Should Be Visible    ${options-table-${i}}
                FOR    ${j}    IN RANGE    ${3}
                    Element Should Be Visible    xpath: //div[@data-testid="random-number-${i}-${j}"]
                END
            ELSE
                Element Should Not Be Visible    ${options-table-${i}}
                FOR    ${j}    IN RANGE    ${3}
                    Element Should Not Be Visible    xpath: //div[@data-testid="random-number-${i}-${j}"]
                END
            END
        END
    END
