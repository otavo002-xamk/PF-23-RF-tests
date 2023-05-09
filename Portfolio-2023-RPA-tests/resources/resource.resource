*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${logo}           xpath: //img[@alt="home"]
${first_slide}    xpath://img[@alt="slideshow-0"]
${sample3_title}    xpath: //*[contains(text(), "Sample 3!")]

*** Keywords ***
browser_opening
    Open Browser    http://localhost:3000    firefox
    Maximize Browser Window
