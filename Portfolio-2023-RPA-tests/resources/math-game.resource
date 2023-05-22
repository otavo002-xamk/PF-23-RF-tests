*** Variables ***
${math-game-bottom}    div[@class="flex gap-10 justify-center"]
&{status}         locator=p[contains(text(), "Time left") or contains(text(), "Aikaa jäljellä")]    en=Time left    fi=Aikaa jäljellä
&{start-over-button}    locator=button[text()="Start over." or text()="Aloita alusta."]    en=Start over.    fi=Aloita alusta.
&{ready?}         locator=p[text()='Ready?' or text()='Oletko valmis?']    en=Ready?    fi=Oletko valmis?
&{start-button}    locator=button[text()="Start!" or text()="Aloita!"]    en=Start!    fi=Aloita!
&{math-game-title}    locator=h1    en=Math Game!    fi=Matikkapeli!
${options-table-4}    tbody[@data-testid="equation-options-table-tb-4"]
${options-table-3}    tbody[@data-testid="equation-options-table-tb-3"]
${options-table-2}    tbody[@data-testid="equation-options-table-tb-2"]
${options-table-1}    tbody[@data-testid="equation-options-table-tb-1"]
${options-table-0}    tbody[@data-testid="equation-options-table-tb-0"]
${result}         p[text()="Time ended!" or text()="Correct!" or text()="Wrong!" or text()="Aika loppui!" or text()="Oikein!" or text()="Väärin!"]
${equation-div-0}    div[@data-testid="equation-0"]
${equation-div-1}    div[@data-testid="equation-1"]
${equation-div-2}    div[@data-testid="equation-2"]
${equation-div-3}    div[@data-testid="equation-3"]
${equation-div-4}    div[@data-testid="equation-4"]
&{correct}        en=Correct!    fi=Oikein!
&{incorrect}      en=Wrong!    fi=Väärin!
&{time-ended}     en=Time ended!    fi=Aika loppui!
&{end-results}    locator=h2[contains(text(), "Your results") or contains(text(), "Tuloksesi")]    en=Your results    fi=Tuloksesi

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
    Element Text Should Be    xpath: //${central_content-div}//${math-game-title}[locator]    ${math-game-title}[${language}]
    Element Text Should Be    xpath: //${central_content-div}//${ready?}[locator]    ${ready?}[${language}]
    Element Text Should Be    xpath: //${central_content-div}//${start-button}[locator]    ${start-button}[${language}]

check_equation-elements
    [Arguments]    ${equation-number}
    [Documentation]    The keyword checks equation elements in the math game, that is four options table, three random numbers and progress-bar. Equation number is given as argument. If the equation number is 6 (i.e. the game hasn't started yet), no element should be visible. Else only the elements matching the equation number should be visible.
    IF    ${equation-number} == 6
        FOR    ${i}    IN RANGE    ${5}
            Element Should Not Be Visible    xpath: //${options-table-${i}}
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
                Element Should Be Visible    xpath: //${central_content-div}//${options-table-${i}}
                FOR    ${j}    IN RANGE    ${3}
                    Element Should Be Visible    xpath: //${central_content-div}//div[@data-testid="random-number-${i}-${j}"]
                END
            ELSE
                Element Should Not Be Visible    ${options-table-${i}}
                FOR    ${j}    IN RANGE    ${3}
                    Element Should Not Be Visible    xpath: //div[@data-testid="random-number-${i}-${j}"]
                END
            END
        END
        Element Should Be Visible    xpath: //${central_content-div}//${equation-div-${equation-number}}//div[@class="progressbar-progress"]
    END

check_elements_after_start
    [Arguments]    ${equation-number}
    [Documentation]    The keyword checks the elements of math game right after starting every new equation. The equation number is given as argument.
    Element Should Be Visible    xpath: //${central_content-div}//${math-game-title}[locator]
    Element Should Not Be Visible    xpath: //${central_content-div}//${ready?}[locator]
    Element Text Should Be    xpath: //${central_content-div}//${start-over-button}[locator]    ${start-over-button}[en]
    Element Should Contain    xpath: //${central_content-div}//${status}[locator]    ${status}[en]
    select_other_language    'fi'
    Element Text Should Be    xpath: //${central_content-div}//${start-over-button}[locator]    ${start-over-button}[fi]
    Element Should Contain    xpath: //${central_content-div}//${status}[locator]    Aikaa jäljellä
    select_other_language    'en'
    Element Text Should Be    xpath: //${central_content-div}//${start-over-button}[locator]    ${start-over-button}[en]
    Element Should Contain    xpath: //${central_content-div}//${status}[locator]    ${status}[en]
    check_equation-elements    ${equation-number}
    Element Should Not Be Visible    xpath: //${result}
    Element Should Be Disabled    xpath: //button[text()= "NEXT ❯"]

check_correct-count
    [Arguments]    ${sum}    ${equation-number}
    [Documentation]    The keyword checks count of correct numbers in the options table and ensures that there's also the same count of correct symbols that are also in the same table cells with the correct numbers. This is needed for there is a small possibility that there's by accident more than one correct numbers in the table. The sum and equation number are given as arguments.
    ${correct_count}=    Get Element Count    xpath: //${options-table-${equation-number}}//td[text()="${sum}"]
    ${correct_symbol-count}=    Get Element Count    xpath: //${options-table-${equation-number}}//img[@alt="correct"]
    ${correct_symbol_&_count}=    Get Element Count    xpath: //${options-table-${equation-number}}//td[text()="${sum}"]//img[@alt="correct"]
    Wait For Condition    return ${correct_count} == ${correct_symbol-count}
    Wait For Condition    return ${correct_count} == ${correct_symbol_&_count}

check_false-count
    [Arguments]    ${option-index}    ${equation-number}
    [Documentation]    The keyword checks that there's only one incorrect-symbol in the options-table and that it's in the same table cell with the table cell that is clicked. The option index (i.e. the table-cell that is clicked) and equation number are given as arguments.
    ${false-count}=    Get Element Count    xpath: //${options-table-${equation-number}}//img[@alt="incorrect"]
    Wait For Condition    return ${false-count} == 1
    Element Should Be Visible    xpath: //${options-table-${equation-number}}//td[@data-testid="equation-options-table-td-${equation-number}-${option-index}"]//img[@alt="incorrect"]

check_result_&_click_next
    [Arguments]    ${result-message}    ${equation-number}
    [Documentation]    The keyword checks the equation elements in the mathgame after the options-table has been clicked and the result is shown. Then the NEXT-button will be clicked. The english and finnish result text and equation number are given as arguments.
    Element Should Not Be Visible    xpath: //${status}[locator]
    Element Text Should Be    xpath: //${central_content-div}//${equation-div-${equation-number}}//p    ${result-message}[en]
    select_other_language    'fi'
    Element Text Should Be    xpath: //${central_content-div}//${equation-div-${equation-number}}//p    ${result-message}[fi]
    select_other_language    'en'
    Element Text Should Be    xpath: //${central_content-div}//${equation-div-${equation-number}}//p    ${result-message}[en]
    check_equation-elements    ${equation-number}
    Click Button    xpath: //button[text()="NEXT ❯"]

click_correct
    [Arguments]    ${equation-number}
    ${sum}    calculate_sum    ${equation-number}
    Click Element    xpath: //${central_content-div}//${equation-div-${equation-number}}//${options-table-${equation-number}}//td[text()="${sum}"]
    [Return]    ${sum}

check_all_result-texts
    [Arguments]    ${correct}    ${incorrect}    ${time_ended}    ${your_results}
    Element Text Should Be    xpath: //div[@data-testid="equation-0"]//p    ${correct}
    Element Text Should Be    xpath: //div[@data-testid="equation-1"]//p    ${incorrect}
    Element Text Should Be    xpath: //div[@data-testid="equation-2"]//p    ${time_ended}
    Element Text Should Be    xpath: //div[@data-testid="equation-3"]//p    ${correct}
    Element Text Should Be    xpath: //div[@data-testid="equation-4"]//p    ${correct}
    Element Text Should Be    xpath: //h2[contains(text(), "Your results") or contains(text(), "Tuloksesi")]    ${your_results}: 3 / 5
