*** Settings ***
Library           SeleniumLibrary
Resource          resources/resource.resource

*** Variables ***







*** Test Cases ***
homepage-button
    browser_opening
    frontpage_opening
    Click Link    link: Sample 3
    Element Should Be Visible    ${sample3_title}
    Element Should Not Be Visible    ${first_slide}
    Click Image    ${logo}
    frontpage_opening


*** Keywords ***
frontpage_opening
    Element Should Be Visible    ${first_slide}
    Element Should Not Be Visible    ${sample3_title}
