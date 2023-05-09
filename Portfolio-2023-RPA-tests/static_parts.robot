*** Settings ***
Library           SeleniumLibrary
Resource          resources/resource.resource

*** Variables ***
${toggle-to-dark}    xpath: //img[@alt="moon"]
${toggle-to-light}    xpath: //img[@alt="sun"]

*** Test Cases ***
homepage-button
    browser_opening
    frontpage_opening
    Click Link    link: Sample 3
    Element Should Be Visible    ${sample3_title}
    Element Should Not Be Visible    ${first_slide}
    Click Image    ${logo}
    frontpage_opening

theme-toggler
    browser_opening
    Element Attribute Value Should Be    tag:body    class    \
    Click Image    ${toggle-to-dark}
    Element Attribute Value Should Be    tag:body    class    dark
    Click Image    ${toggle-to-light}
    Element Attribute Value Should Be    tag:body    class    \

*** Keywords ***
frontpage_opening
    Element Should Be Visible    ${first_slide}
    Element Should Not Be Visible    ${sample3_title}
