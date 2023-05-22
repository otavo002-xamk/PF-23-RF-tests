*** Settings ***
Library           SeleniumLibrary
Resource          resources/resource.resource
Resource          resources/math-game.resource

*** Variables ***


*** Test Cases ***
checking_components
    [Setup]    browser_opening
    Element Should Not Be Visible    xpath: //h1
    Element Should Not Be Visible    xpath: //${ready?}[locator]
    Click Link    link: ${navbar-links}[math_game][en]
    check_start-page-elements    en
    select_other_language    'fi'
    check_start-page-elements    fi
    select_other_language    'en'
    check_start-page-elements    en
    Element Should Not Be Visible    xpath: //${start-over-button}[locator]
    check_equation-elements    6
    Element Should Not Be Visible    xpath: //${status}[locator]
    Click Button    xpath: //${central_content-div}//${start-button}[locator]
    check_elements_after_start    0
    Element Text Should Be    xpath: //${math-game-bottom}//p    0 / 5
    ${sum-0}=    click_correct    0
    check_correct-count    ${sum-0}    0
    Element Should Not Be Visible    xpath: //${options-table-0}//img[@alt="incorrect"]
    check_result_&_click_next    ${correct}    0
    check_elements_after_start    1
    ${sum_1}=    calculate_sum    1
    FOR    ${i}    IN RANGE    ${4}
        ${option}    Get Text    xpath: //td[@data-testid="equation-options-table-td-1-${i}"]
        IF    ${option} != ${sum_1}
            Click Element    xpath: //td[@data-testid="equation-options-table-td-1-${i}"]
            check_false-count    ${i}    1
            BREAK
        END
    END
    check_correct-count    ${sum_1}    1
    check_result_&_click_next    ${incorrect}    1
    check_elements_after_start    2
    Sleep    0.5
    FOR    ${i}    IN RANGE    ${8}
        Element Text Should Be    xpath: //${central_content-div}//${equation-div-2}//${status}[locator]    Time left: ${8 - ${i}}
        Sleep    1
    END
    check_result_&_click_next    ${time-ended}    2
    check_elements_after_start    3
    ${sum_3}=    click_correct    3
    check_result_&_click_next    ${correct}    3
    check_elements_after_start    4
    ${sum_4}=    click_correct    4
    Element Should Not Be Visible    xpath: //${end-results}[locator]
    check_result_&_click_next    ${correct}    4
    FOR    ${i}    IN RANGE    ${5}
        FOR    ${j}    IN RANGE    ${3}
            Element Should Be Visible    xpath: //div[@data-testid="random-number-${i}-${j}"]
            Element Should Be Visible    xpath: //div[@class="progressbar-progress"]
        END
    END
    check_all_result-texts    Correct!    Wrong!    Time ended!    Your results
    select_other_language    'fi'
    check_all_result-texts    Oikein!    Väärin!    Aika loppui!    Tuloksesi
    select_other_language    'en'
    Element Should Not Be Visible    ${ready?}[locator]
    Click Button    xpath: //button[text()="Start over."]
    check_start-page-elements    en
    [Teardown]    Close Browser

choosing_correctly
    [Setup]    browser_opening
    Click Link    link: Math Game
    Click Button    ${start-button}
    FOR    ${i}    IN RANGE    ${5}
        Element Text Should Be    xpath: //div[@class="flex gap-10 justify-center"]//p    ${i} / 5
        click_correct    ${i}
        Element Text Should Be    xpath: //div[@class="flex gap-10 justify-center"]//p    ${i+1} / 5
        Click Button    xpath: //button[text()="NEXT ❯"]
    END
    Element Text Should Be    xpath: //h2[contains(text(), "Your results")]    Your results: 5 / 5
    Element Should Be Visible    xpath: //div[@class="p-12 lg:p-0"]//h2[text()="YOU DID IT!!!"]
    Element Should Not Be Visible    xpath: //div[@class="p-12 lg:p-0"]//h2[text()="KAIKKI OIKEIN!!!"]
    select_other_language    'fi'
    Element Should Be Visible    xpath: //div[@class="p-12 lg:p-0"]//h2[text()="KAIKKI OIKEIN!!!"]
    Element Should Not Be Visible    xpath: //div[@class="p-12 lg:p-0"]//h2[text()="YOU DID IT!!!"]
    [Teardown]    Close Browser
