*** Settings ***
Library           SeleniumLibrary
Resource          resources/resource.resource

*** Variables ***
${toggle-to-dark}    xpath: //img[@alt="moon"]
${toggle-to-light}    xpath: //img[@alt="sun"]
@{navbar-items}    &{mathgame-item}    &{nasa-api-item}    &{sample3-item}    &{sample4-item}
&{mathgame-item}    path=MathGame    en=Math Game    fi=Matikkapeli
&{nasa-api-item}    path=nasaAPI    en=NASA API    fi=NASA API
&{sample3-item}    path=sample3    en=Sample 3    fi=Näyte 3
&{sample4-item}    path=sample4    en=Sample 4    fi=Näyte 4




*** Test Cases ***
homepage-button
    browser_opening
    frontpage_opening
    Click Link    link: ${navbar-links}[sample_3][en]
    Element Should Be Visible    ${sample3_title}
    Element Should Not Be Visible    ${first_slide}
    Click Image    ${logo}
    frontpage_opening
    Close Browser

theme-toggler
    browser_opening
    Element Attribute Value Should Be    tag:body    class    \
    Click Image    ${toggle-to-dark}
    Element Attribute Value Should Be    tag:body    class    dark
    Click Image    ${toggle-to-light}
    Element Attribute Value Should Be    tag:body    class    \
    Close Browser

language-toggler
    browser_opening
    this_flag_should_be_visible    "en"
    check_menu_items    en
    select_other_language    "fi"
    this_flag_should_be_visible    "fi"
    check_menu_items    fi
    select_other_language    "en"
    this_flag_should_be_visible    "en"
    check_menu_items    en
    Close Browser

*** Keywords ***
frontpage_opening
    Element Should Be Visible    ${first_slide}
    Element Should Not Be Visible    ${sample3_title}

this_flag_should_be_visible
    [Arguments]    ${flag}
    IF    ${flag} == "en"
        Element Should Be Visible    ${english-flag}
        Element Should Not Be Visible    ${finnish-flag}
    ELSE
        Element Should Be Visible    ${finnish-flag}
        Element Should Not Be Visible    ${english-flag}
    END

check_menu_items
    [Arguments]    ${language}
    [Documentation]    checks texts in each menu-item is in correct language
    FOR    ${link}    IN    &{navbar-links}
        Element Text Should Be    xpath:// a[@href="/${link[1]['path']}"]    ${link}[1][${language}]
    END
