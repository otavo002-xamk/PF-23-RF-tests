*** Settings ***
Library           SeleniumLibrary
Resource          resources/resource.resource

*** Variables ***
${math-game-title}    xpath: //h1[text()="Math Game!"]
${ready?}         xpath: //p[text()="Ready?"]
${start-button}    xpath: //button[text()="Start!"]
${start-over-button}    xpath: //button[text()="Start over."]
${valmis?}        xpath: //p[text()="Oletko valmis?"]
${matikkapeli-title}    xpath: //h1[text()="Matikkapeli!"]




*** Test Cases ***
checking_components
    browser_opening
    Element Should Not Be Visible    ${math-game-title}
    Element Should Not Be Visible    ${ready?}
    Click Link    link: Math Game
    Element Should Be Visible    ${math-game-title}
    Element Should Be Visible    ${ready?}
    Element Should Not Be Visible    ${matikkapeli-title}
    Element Should Not Be Visible    ${valmis?}
    select_other_language    'fi'
    Element Should Not Be Visible    ${math-game-title}
    Element Should Not Be Visible    ${ready?}
    Element Should Be Visible    ${matikkapeli-title}
    Element Should Be Visible    ${valmis?}
    select_other_language    'en'
    Click Button    ${start-button}
    Element Should Be Visible    ${math-game-title}
    Element Should Not Be Visible    ${ready?}
    Element Should Be Visible    ${start-over-button}
    Element Should Be Disabled    xpath: //button[contains(text(), "NEXT ❯")]
    Element Should Not Be Visible    xpath: //p[contains(text(), "Correct!")]
    ${sum}    choose_correct    0
    Click Element    xpath: //td[text()="${sum}"]
    ${correct-count}    Get Element Count    xpath: //td[text()="${sum}"]
    Element Should Be Visible    xpath: //td[text()="${sum}"][1]//img[@alt="correct"]
    Element Should Not Be Visible    xpath: //td[text()="${sum}"][1]//preceding::td//img[@alt="correct"]
    Element Should Not Be Visible    xpath: //td[text()="${sum}"][${correct-count}]//following-sibling::td//img[@alt="correct"]
    Element Should Not Be Visible    xpath: //img[@alt="incorrect"]
    Element Should Be Visible    xpath: //p[text()="Correct!"]
    Click Element    xpath: //button[text()="NEXT ❯"]

*** Keywords ***
choose_correct
    [Arguments]    ${equation-number}
    ${random1}    Get Text    xpath: //div[@data-testid="random-number-${equation-number}-0"]
    ${random2}    Get Text    xpath: //div[@data-testid="random-number-${equation-number}-1"]
    ${random3}    Get Text    xpath: //div[@data-testid="random-number-${equation-number}-2"]
    ${sum}    evaluate    ${random1}+${random2}+${random3}







    [Return]    ${sum}
