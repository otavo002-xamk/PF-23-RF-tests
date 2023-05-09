*** Settings ***
Library           SeleniumLibrary
Resource          resources/resource.resource

*** Variables ***






*** Test Cases ***
homepage-button
    browser_opening
    Element Should Be Visible    ${first_slide}
    Click Link    link: Sample 3
    Click Image    ${logo}

*** Keywords ***
