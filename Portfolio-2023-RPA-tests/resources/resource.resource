*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${logo}           xpath: //img[@alt="home"]
${first_slide}    xpath://img[@alt="slideshow-0"]


*** Keywords ***
browser_opening
    Open Browser    http://localhost:3000    firefox
    Maximize Browser Window
