*** Settings ***
Library           SeleniumLibrary
Resource          resources/resource.resource

*** Variables ***
${nasa-api-title}    NASA API!
${sol-input}      id:sol-input
&{sol-input-label}    locator=input[@id="sol-input"]/preceding::label[@for="sol-input"]    en=Insert sol please (a value between 0 - 4099):    fi=Syötä sol kiitos (luku väliltä 0 - 4099):
${camera-select}    select[@id="camera-select"]
&{camera-select-label}    locator=select[@id="camera-select"]/preceding::label[@for="camera-select"]    en=Select camera please:    fi=Valitse kamera kiitos:
&{get-images-button}    locator=button[text()="Get images from NASA." or text()="Hae kuvat NASAlta."]    en=Get images from NASA.    fi=Hae kuvat NASAlta.
@{camera-option-texts}    Front Hazard Avoidance Camera    Rear Hazard Avoidance Camera    Mast Camera    Chemistry and Camera Complex    Mars Hand Lens Imager    Mars Descent Imager    Navigation Camera    Panoramic Camera    Miniature Thermal Emission Spectrometer (Mini-TES)
${nasa-api-loader}    div[@data-testid="nasa-api-loader"]
&{no_pictures_found}    en=No pictures found. Try again with a different sol or different camera.    fi=Valitettavasti kuvia ei löytynyt. Kokeile toista solia tai toista kameraa.
&{too_big_number}    en=Too big number!    fi=Liian suuri luku!
${play-slider-btn}    button/img[@alt="play-slider-button"]
${pause-slider-btn}    button/img[@alt="pause-slider-button"]
${following-sibling_curiosity-minislider-div}    following-sibling::div

*** Test Cases ***
checking_components
    [Documentation]    checks all the start components of the NASA API -page without going deeper to the functionalities of it
    [Setup]    ${browser-opening}
    Element Should Not Be Visible    xpath: //${central_content-div}
    Click Link    link: ${navbar-links}[nasa_api][en]
    Element Attribute Value Should Be    ${sol-input}    placeholder    122
    FOR    ${i}    IN RANGE    9
        Element Text Should Be    xpath: //${central_content-div}/${camera-select}/option[${i+1}]    ${camera-option-texts}[${i}]
    END
    Element Should Not Be Visible    xpath: //${nasa-api-loader}
    Element Should Not Be Visible    xpath: //${get-images-button}[locator]//following-sibling::p
    Click Element    xpath: //${central_content-div}/${get-images-button}[locator]
    Element Should Be Visible    xpath: //${central_content-div}/${nasa-api-loader}
    Wait Until Element Is Not Visible    xpath: //${central_content-div}/${nasa-api-loader}    10
    check_text-elements    en
    select_other_language    'fi'
    check_text-elements    fi
    select_other_language    'en'
    check_text-elements    en
    [Teardown]    Close Browser

invalid_sol
    [Documentation]    checks the error-message when too large value is inserted to the sol-input
    [Setup]    ${browser-opening}
    Click Link    ${nasa-api-link}[en]
    Input Text    ${sol-input}    4100
    Element Should Not Be Visible    ${get-images-button}[locator]//following-sibling::p
    Click Button    xpath: //${central_content-div}/${get-images-button}[locator]
    Element Text Should Be    xpath: //${central_content-div}/${get-images-button}[locator]/following-sibling::p    ${too_big_number}[en]
    select_other_language    'fi'
    Element Text Should Be    xpath: //${central_content-div}/${get-images-button}[locator]/following-sibling::p    ${too_big_number}[fi]
    select_other_language    'en'
    Element Text Should Be    xpath: //${central_content-div}/${get-images-button}[locator]/following-sibling::p    ${too_big_number}[en]
    [Teardown]    Close Browser

curiosity-minislider
    [Documentation]    The test checks that the curiosity-minislider works as expected. With the given sol-value it should show 10 pictures. Also pause-button should stop the slider and change to a play button.
    [Setup]    ${browser-opening}
    Click Link    ${nasa-api-link}[en]
    Input Text    ${sol-input}    1444
    Element Should Not Be Visible    xpath: //${nasa-api-loader}
    Element Should Not Be Visible    xpath: //${get-images-button}[locator]//${following-sibling_curiosity-minislider-div}
    Click Button    xpath: //${central_content-div}/${get-images-button}[locator]
    Element Should Be Visible    xpath: //${central_content-div}/${nasa-api-loader}
    Wait Until Element Is Not Visible    xpath: //${nasa-api-loader}    10
    Element Should Be Visible    xpath: //${get-images-button}[locator]/${following-sibling_curiosity-minislider-div}/${pause-slider-btn}
    FOR    ${i}    IN RANGE    ${10}
        Element Attribute Value Should Be    xpath: //${get-images-button}[locator]/${following-sibling_curiosity-minislider-div}/img    alt    curiosity-${i}
        Sleep    1
    END
    Element Attribute Value Should Be    xpath: //${get-images-button}[locator]/${following-sibling_curiosity-minislider-div}/img    alt    curiosity-0
    Element Should Not Be Visible    xpath: //${play-slider-btn}
    Click Element    xpath: //${get-images-button}[locator]/${following-sibling_curiosity-minislider-div}/${pause-slider-btn}
    Element Should Not Be Visible    xpath: //${pause-slider-btn}
    Sleep    2
    Element Attribute Value Should Be    xpath: //${get-images-button}[locator]/${following-sibling_curiosity-minislider-div}/img    alt    curiosity-0
    Click Element    xpath: //${get-images-button}[locator]/${following-sibling_curiosity-minislider-div}/${play-slider-btn}
    Sleep    1
    Element Attribute Value Should Be    xpath: //${get-images-button}[locator]/${following-sibling_curiosity-minislider-div}/img    alt    curiosity-1
    [Teardown]    Close Browser

camera-trials
    [Documentation]    checks that selecting different camera options work as expected
    [Setup]    ${browser-opening}
    Click Link    ${nasa-api-link}[en]
    Input Text    ${sol-input}    0
    test_camera    3    2
    Input Text    ${sol-input}    1
    test_camera    2    4
    test_camera    4    8
    test_camera    6    4
    Input Text    ${sol-input}    21
    test_camera    5    7
    [Teardown]    Close Browser

*** Keywords ***
check_text-elements
    [Arguments]    ${language}
    [Documentation]    checks the text elements are correct and in the language that is given in arguments
    Element Text Should Be    xpath: //${central_content-div}/h1    ${nasa-api-title}
    Element Text Should Be    xpath: //${central_content-div}/${sol-input-label}[locator]    ${sol-input-label}[${language}]
    Element Text Should Be    xpath: //${central_content-div}/${camera-select-label}[locator]    ${camera-select-label}[${language}]
    Element Text Should Be    xpath: //${central_content-div}/${get-images-button}[locator]    ${get-images-button}[${language}]
    Element Text Should Be    xpath: //${get-images-button}[locator]//following-sibling::p    ${no_pictures_found}[${language}]

test_camera
    [Arguments]    ${camera-index}    ${expected_img-amount}
    [Documentation]    The keyword first selects from the camera-select the one that corresponds to the camera-index given in arguments. It then gets the pictures and checks that the amount matches to the expected img amount given as the second argument.
    Select From List By Label    xpath: //${central_content-div}/${camera-select}    ${camera-option-texts}[${camera-index}]
    Click Button    xpath: //${central_content-div}/${get-images-button}[locator]
    Wait Until Element Is Visible    xpath: //${get-images-button}[locator]/${following-sibling_curiosity-minislider-div}/img    10
    FOR    ${i}    IN RANGE    ${expected_img-amount}
        Element Attribute Value Should Be    xpath: //${get-images-button}[locator]/${following-sibling_curiosity-minislider-div}/img    alt    curiosity-${i}
        Sleep    1
    END
    Element Attribute Value Should Be    xpath: //${get-images-button}[locator]/${following-sibling_curiosity-minislider-div}/img    alt    curiosity-0
