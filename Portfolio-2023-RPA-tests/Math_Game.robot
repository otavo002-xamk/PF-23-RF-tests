*** Settings ***
Library           SeleniumLibrary
Resource          resources/resource.resource

*** Variables ***
${math-game-title}    ${central_content-div}//h1
${ready?}         ${central_content-div}//p[text()="Ready?" or text()="Oletko valmis?"]
${start-button}    xpath: //button[text()="Start!" or text()="Aloita!"]
${start-over-button}    xpath: //button[text()="Start over." or text()="Aloita alusta."]
${status}         ${central_content-div}//p[contains(text(), "Time left") or contains(text(), "Aikaa jäljellä")]
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
    check_equation-elements    6
    Element Should Not Be Visible    ${status}
    Element Should Not Be Visible    ${central_content-div}//div[@class="progressbar-progress"]
    Click Button    ${start-button}
    check_elements_after_start    0
    ${sum}    calculate_sum    0
    Click Element    xpath: //td[text()="${sum}"]
    check_correct-count    ${sum}    0
    Element Should Not Be Visible    xpath: //tbody[@data-testid="equation-options-table-tb-0"]//img[@alt="incorrect"]
    check_result_&_click_next    Correct!    Oikein!    0
    check_elements_after_start    1
    ${sum1}    calculate_sum    1
    ${first_option}    Get Text    xpath: //td[@data-testid="equation-options-table-td-1-0"]
    ${second_option}    Get Text    xpath: //td[@data-testid="equation-options-table-td-1-1"]
    ${third_option}    Get Text    xpath: //td[@data-testid="equation-options-table-td-1-2"]
    ${fourth_option}    Get Text    xpath: //td[@data-testid="equation-options-table-td-1-3"]
    IF    ${first_option} != ${sum1}
        Click Element    xpath: //td[@data-testid="equation-options-table-td-1-0"]
        check_false-count    0    1
    ELSE IF    ${second_option} != ${sum1}
        Click Element    xpath: //td[@data-testid="equation-options-table-td-1-1"]
        check_false-count    1    1
    ELSE IF    ${third_option} != ${sum1}
        Click Element    xpath: //td[@data-testid="equation-options-table-td-1-2"]
        check_false-count    2    1
    ELSE IF    ${fourth_option} != ${sum1}
        Click Element    xpath: //td[@data-testid="equation-options-table-td-1-3"]
        check_false-count    3    1
    END
    check_correct-count    ${sum1}    1
    check_result_&_click_next    Wrong!    Väärin!    1

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

check_equation-elements
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

check_elements_after_start
    [Arguments]    ${equation-number}
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
    check_equation-elements    ${equation-number}
    Element Should Be Visible    ${central_content-div}//div[@data-testid="equation-${equation-number}"]//div[@class="progressbar-progress"]
    Element Should Not Be Visible    ${result}
    Element Should Be Disabled    xpath: //button[text()= "NEXT ❯"]

check_correct-count
    [Arguments]    ${sum}    ${equation-number}
    ${correct_count}    Get Element Count    xpath: //tbody[@data-testid="equation-options-table-tb-${equation-number}"]//td[text()="${sum}"]
    ${correct_symbol-count}    Get Element Count    xpath: //tbody[@data-testid="equation-options-table-tb-${equation-number}"]//img[@alt="correct"]
    ${correct_symbol_&_count}    Get Element Count    xpath: //tbody[@data-testid="equation-options-table-tb-${equation-number}"]//td[text()="${sum}"]//img[@alt="correct"]
    Wait For Condition    return ${correct_count} == ${correct_symbol-count}
    Wait For Condition    return ${correct_count} == ${correct_symbol_&_count}

check_false-count
    [Arguments]    ${option-index}    ${equation-number}
    ${false-count}    Get Element Count    xpath: //tbody[@data-testid="equation-options-table-tb-${equation-number}"]//img[@alt="incorrect"]
    Wait For Condition    return ${false-count} == 1
    Element Should Be Visible    xpath: //tbody[@data-testid="equation-options-table-tb-${equation-number}"]//td[@data-testid="equation-options-table-td-${equation-number}-${option-index}"]//img[@alt="incorrect"]



check_result_&_click_next
    [Arguments]    ${eng_result}    ${fin_result}    ${equation-number}
    Element Should Not Be Visible    xpath: //p[contains(text(), "Time left") or contains(text(), "Aikaa jäljellä")]
    Element Text Should Be    xpath: //div[@data-testid="equation-${equation-number}"]//p    ${eng_result}
    select_other_language    'fi'
    Element Text Should Be    xpath: //div[@data-testid="equation-${equation-number}"]//p    ${fin_result}
    select_other_language    'en'
    Element Text Should Be    xpath: //div[@data-testid="equation-${equation-number}"]//p    ${eng_result}
    Element Should Be Visible    xpath: //div[@data-testid="random-number-${equation-number}-0"]
    Element Should Be Visible    xpath: //div[@data-testid="random-number-${equation-number}-1"]
    Element Should Be Visible    xpath: //div[@data-testid="random-number-${equation-number}-2"]
    Element Should Be Visible    xpath: //div[@data-testid="equation-${equation-number}"]//div[@class="progressbar-progress"]
    Click Element    xpath: //button[text()="NEXT ❯"]
