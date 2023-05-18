*** Settings ***
Library           SeleniumLibrary
Resource          resources/resource.resource

*** Variables ***
${math-game-title}    ${central_content-div}//h1
${ready?}         ${central_content-div}//p[text()="Ready?" or text()="Oletko valmis?"]
${start-button}    xpath: //button[text()="Start!" or text()="Aloita!"]
${start-over-button}    xpath: //button[text()="Start over." or text()="Aloita alusta."]
${result}         ${central_content-div}//p[text()="Time ended!" or text()="Correct!" or text()="Wrong!" or text()="Aika loppui!" or text()="Oikein!" or text()="Väärin!"]
${options-table-0}    xpath: //tbody[@data-testid="equation-options-table-tb-0"]
${options-table-1}    xpath: //tbody[@data-testid="equation-options-table-tb-1"]
${options-table-2}    xpath: //tbody[@data-testid="equation-options-table-tb-2"]
${options-table-3}    xpath: //tbody[@data-testid="equation-options-table-tb-3"]
${options-table-4}    xpath: //tbody[@data-testid="equation-options-table-tb-4"]








*** Test Cases ***
checking_components
    [Setup]    browser_opening
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
    Element Should Not Be Visible    xpath: //p[contains(text(), "Time left") or contains(text(), "Aikaa jäljellä")]\n
    Click Button    ${start-button}
    check_elements_after_start    0
    Element Text Should Be    xpath: //div[@class="flex gap-10 justify-center"]//p    0 / 5
    ${sum-0}    click_correct    0
    check_correct-count    ${sum-0}    0
    Element Should Not Be Visible    xpath: //tbody[@data-testid="equation-options-table-tb-0"]//img[@alt="incorrect"]
    check_result_&_click_next    Correct!    Oikein!    0
    check_elements_after_start    1
    ${sum-1}    calculate_sum    1
    ${first_option}    Get Text    xpath: //td[@data-testid="equation-options-table-td-1-0"]
    ${second_option}    Get Text    xpath: //td[@data-testid="equation-options-table-td-1-1"]
    ${third_option}    Get Text    xpath: //td[@data-testid="equation-options-table-td-1-2"]
    ${fourth_option}    Get Text    xpath: //td[@data-testid="equation-options-table-td-1-3"]
    IF    ${first_option} != ${sum-1}
        Click Element    xpath: //td[@data-testid="equation-options-table-td-1-0"]
        check_false-count    0    1
    ELSE IF    ${second_option} != ${sum-1}
        Click Element    xpath: //td[@data-testid="equation-options-table-td-1-1"]
        check_false-count    1    1
    ELSE IF    ${third_option} != ${sum-1}
        Click Element    xpath: //td[@data-testid="equation-options-table-td-1-2"]
        check_false-count    2    1
    ELSE IF    ${fourth_option} != ${sum-1}
        Click Element    xpath: //td[@data-testid="equation-options-table-td-1-3"]
        check_false-count    3    1
    END
    check_correct-count    ${sum-1}    1
    check_result_&_click_next    Wrong!    Väärin!    1
    check_elements_after_start    2
    Sleep    0.5
    FOR    ${i}    IN RANGE    ${8}
        Element Text Should Be    xpath: //div[@data-testid="equation-2"]//p[contains(text(), "Time left")]    Time left: ${8 - ${i}}
        Sleep    1
    END
    check_result_&_click_next    Time ended!    Aika loppui!    2
    check_elements_after_start    3
    ${sum-3}    click_correct    3
    check_result_&_click_next    Correct!    Oikein!    3
    check_elements_after_start    4
    ${sum-4}    click_correct    4
    Element Should Not Be Visible    xpath: //h2[contains(text(), "Your results")]
    check_result_&_click_next    Correct!    Oikein!    4
    Element Text Should Be    xpath: //h2[contains(text(), "Your results")]    Your results: 3 / 5
    FOR    ${i}    IN RANGE    ${5}
        FOR    ${j}    IN RANGE    ${3}
            Element Should Be Visible    xpath: //div[@data-testid="random-number-${i}-${j}"]
            Element Should Be Visible    xpath: //div[@class="progressbar-progress"]
        END
    END
    check_all_result-texts    Correct!    Wrong!    Time ended!
    select_other_language    'fi'
    check_all_result-texts    Oikein!    Väärin!    Aika loppui!
    select_other_language    'en'
    check_all_result-texts    Correct!    Wrong!    Time ended!
    Element Should Not Be Visible    ${ready?}
    Click Element    xpath: //button[text()="Start over."]
    check_start-page-elements    'en'

    [Teardown]    Close Browser

*** Keywords ***
calculate_sum
    [Arguments]    ${equation-number}
    [Documentation]    calculates sum from three random numbers
    ${random1}    Get Text    xpath: //div[@data-testid="random-number-${equation-number}-0"]
    ${random2}    Get Text    xpath: //div[@data-testid="random-number-${equation-number}-1"]
    ${random3}    Get Text    xpath: //div[@data-testid="random-number-${equation-number}-2"]
    ${sum}    evaluate    ${random1}+${random2}+${random3}
    [Return]    ${sum}

check_start-page-elements
    [Arguments]    ${language}
    [Documentation]    The keyword checks the start-page elements in the math game. Language is given as argument.
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
    [Documentation]    The keyword checks equation elements in the math game, that is four options table, three random numbers and progress-bar. Equation number is given as argument. If the equation number is 6 (i.e. the game hasn't started yet), no element should be visible. Else only the elements matching the equation number should be visible.
    IF    ${equation-number} == 6
        FOR    ${i}    IN RANGE    ${5}
            Element Should Not Be Visible    ${options-table-${i}}
        END
        FOR    ${i}    IN RANGE    ${5}
            FOR    ${j}    IN RANGE    ${3}
                Element Should Not Be Visible    xpath: //div[@data-testid="random-number-${i}-${j}"]
            END
        END
        Element Should Not Be Visible    xpath: //div[@class="progressbar-progress"]
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
        Element Should Be Visible    xpath: //div[@data-testid="equation-${equation-number}"]//div[@class="progressbar-progress"]
    END

check_elements_after_start
    [Arguments]    ${equation-number}
    [Documentation]    The keyword checks the elements of math game right after starting every new equation. The equation number is given as argument.
    Element Should Be Visible    ${math-game-title}
    Element Should Not Be Visible    ${ready?}
    Element Text Should Be    ${start-over-button}    Start over.
    Element Should Contain    xpath: //div[@data-testid="equation-${equation-number}"]//p[contains(text(), "Time left") or contains(text(), "Aikaa jäljellä")]    Time left
    select_other_language    'fi'
    Element Text Should Be    ${start-over-button}    Aloita alusta.
    Element Should Contain    xpath: //div[@data-testid="equation-${equation-number}"]//p[contains(text(), "Time left") or contains(text(), "Aikaa jäljellä")]    Aikaa jäljellä
    select_other_language    'en'
    Element Text Should Be    ${start-over-button}    Start over.
    Element Should Contain    xpath: //div[@data-testid="equation-${equation-number}"]//p[contains(text(), "Time left") or contains(text(), "Aikaa jäljellä")]    Time left
    check_equation-elements    ${equation-number}
    Element Should Not Be Visible    ${result}
    Element Should Be Disabled    xpath: //button[text()= "NEXT ❯"]

check_correct-count
    [Arguments]    ${sum}    ${equation-number}
    [Documentation]    The keyword checks count of correct numbers in the options table and ensures that there's also the same count of correct symbols that are also in the same table cells with the correct numbers. This is needed for there is a small possibility that there's by accident more than one correct numbers in the table. The sum and equation number are given as arguments.
    ${correct_count}    Get Element Count    xpath: //tbody[@data-testid="equation-options-table-tb-${equation-number}"]//td[text()="${sum}"]
    ${correct_symbol-count}    Get Element Count    xpath: //tbody[@data-testid="equation-options-table-tb-${equation-number}"]//img[@alt="correct"]
    ${correct_symbol_&_count}    Get Element Count    xpath: //tbody[@data-testid="equation-options-table-tb-${equation-number}"]//td[text()="${sum}"]//img[@alt="correct"]
    Wait For Condition    return ${correct_count} == ${correct_symbol-count}
    Wait For Condition    return ${correct_count} == ${correct_symbol_&_count}

check_false-count
    [Arguments]    ${option-index}    ${equation-number}
    [Documentation]    The keyword checks that there's only one incorrect-symbol in the options-table and that it's in the same table cell with the table cell that is clicked. The option index (i.e. the table-cell that is clicked) and equation number are given as arguments.
    ${false-count}    Get Element Count    xpath: //tbody[@data-testid="equation-options-table-tb-${equation-number}"]//img[@alt="incorrect"]
    Wait For Condition    return ${false-count} == 1
    Element Should Be Visible    xpath: //tbody[@data-testid="equation-options-table-tb-${equation-number}"]//td[@data-testid="equation-options-table-td-${equation-number}-${option-index}"]//img[@alt="incorrect"]

check_result_&_click_next
    [Arguments]    ${eng_result}    ${fin_result}    ${equation-number}
    [Documentation]    The keyword checks the equation elements in the mathgame after the options-table has been clicked and the result is shown. Then the NEXT-button will be clicked. The english and finnish result text and equation number are given as arguments.
    Element Should Not Be Visible    xpath: //p[contains(text(), "Time left") or contains(text(), "Aikaa jäljellä")]
    Element Text Should Be    xpath: //div[@data-testid="equation-${equation-number}"]//p    ${eng_result}
    select_other_language    'fi'
    Element Text Should Be    xpath: //div[@data-testid="equation-${equation-number}"]//p    ${fin_result}
    select_other_language    'en'
    Element Text Should Be    xpath: //div[@data-testid="equation-${equation-number}"]//p    ${eng_result}
    check_equation-elements    ${equation-number}
    Click Element    xpath: //button[text()="NEXT ❯"]

click_correct
    [Arguments]    ${equation-number}
    ${sum}    calculate_sum    ${equation-number}
    Click Element    xpath: //div[@data-testid="equation-${equation-number}"]//td[text()="${sum}"]
    [Return]    ${sum}

check_all_result-texts
    [Arguments]    ${correct}    ${incorrect}    ${time_ended}
    Element Text Should Be    xpath: //div[@data-testid="equation-0"]//p    ${correct}
    Element Text Should Be    xpath: //div[@data-testid="equation-1"]//p    ${incorrect}
    Element Text Should Be    xpath: //div[@data-testid="equation-2"]//p    ${time_ended}
    Element Text Should Be    xpath: //div[@data-testid="equation-3"]//p    ${correct}
    Element Text Should Be    xpath: //div[@data-testid="equation-4"]//p    ${correct}
