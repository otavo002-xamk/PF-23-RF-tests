*** Settings ***
Library           SeleniumLibrary
Resource          resources/resource.resource

*** Variables ***
${nasa-api-title}    NASA API!
${sol-input}      id:sol-input
&{sol-input-label}    locator=input[@id="sol-input"]//preceding::label[@for="sol-input"]    en=Insert sol please (a value between 0 - 3495):    fi=Syötä sol kiitos (luku väliltä 0 - 3495):
${camera-select}    select[@id="camera-select"]
&{camera-select-label}    locator=select[@id="camera-select"]//preceding::label[@for="camera-select"]    en=Select camera please:    fi=Valitse kamera kiitos:
&{get-images-button}    locator=button[text()="Get images from NASA." or text()="Hae kuvat NASAlta."]    en=Get images from NASA.    fi=Hae kuvat NASAlta.
@{camera-option-texts}    Front Hazard Avoidance Camera    Rear Hazard Avoidance Camera    Mast Camera    Chemistry and Camera Complex    Mars Hand Lens Imager    Mars Descent Imager    Navigation Camera    Panoramic Camera    Miniature Thermal Emission Spectrometer (Mini-TES)
${nasa-api-loader}    div[@data-testid="nasa-api-loader"]

*** Test Cases ***
checking_components
    [Setup]    browser_opening
    Element Should Not Be Visible    xpath: //${central_content-div}
    Click Link    link: ${navbar-links}[nasa_api][en]
    check_text-elements    en
    select_other_language    'fi'
    check_text-elements    fi
    select_other_language    'en'
    check_text-elements    en
    Element Attribute Value Should Be    ${sol-input}    placeholder    122
    FOR    ${i}    IN RANGE    9
        Element Text Should Be    xpath: //${camera-select}/option[${i+1}]    ${camera-option-texts}[${i}]
    END
    Click Element    xpath: //${central_content-div}//${get-images-button}[locator]
    Element Should Be Visible    ${central_content-div}//${nasa-api-loader}

    [Teardown]    Close Browser

*** Keywords ***
check_text-elements
    [Arguments]    ${language}
    Element Text Should Be    xpath: //${central_content-div}//${content-title}    ${nasa-api-title}
    Element Text Should Be    xpath: //${central_content-div}//${sol-input-label}[locator]    ${sol-input-label}[${language}]
    Element Text Should Be    xpath: //${central_content-div}//${camera-select-label}[locator]    ${camera-select-label}[${language}]
    Element Text Should Be    xpath: //${get-images-button}[locator]    ${get-images-button}[${language}]
