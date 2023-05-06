*** Settings ***
Library           SeleniumLibrary

*** Test Cases ***
homepage-button
    browser_opening

*** Keywords ***
browser_opening
    Open Browser    http://localhost:3000    firefox
    Maximize Browser Window
