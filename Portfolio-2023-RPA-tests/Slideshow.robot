*** Settings ***
Library           SeleniumLibrary
Resource          resources/resource.resource

*** Variables ***
${indicator-class-non-active}    react-any-slider-dots__dot react-any-slider-dots__dot--big
${indicator-class-active}    react-any-slider-dots__dot react-any-slider-dots__dot--big react-any-slider-dots__dot--active




*** Test Cases ***
arrow-buttons
    [Setup]    browser_opening
    FOR    ${i}    IN RANGE    ${8}
        FOR    ${j}    IN RANGE    ${8}
            check_correct_slideshow-index_is_visible    ${i}    ${j}
        END
        Click Button    xpath://button[@data-testid="slider-next-button"]
    END
    Element Should Be Visible    xpath: //img[@alt="slideshow-0"]
    FOR    ${i}    IN RANGE    ${8}
        Click Button    xpath://button[@data-testid="slider-prev-button"]
        FOR    ${j}    IN RANGE    ${8}
            check_correct_slideshow-index_is_visible    ${7 - ${i}}    ${7 - ${j}}
        END
    END
    [Teardown]    Close Browser

indicators
    [Setup]    browser_opening
    FOR    ${i}    IN RANGE    ${8}
        Click Element    id:sliderdot${i}
        FOR    ${j}    IN RANGE    ${8}
            check_correct_slideshow-index_is_visible    ${i}    ${j}
        END
    END
    [Teardown]    Close Browser

automatic_slide-change
    [Setup]    browser_opening
    FOR    ${i}    IN RANGE    ${8}
        FOR    ${j}    IN RANGE    ${8}
            check_correct_slideshow-index_is_visible    ${i}    ${j}
        END
            Builtin.Sleep    4s
        FOR    ${j}    IN RANGE    ${8}
            check_correct_slideshow-index_is_visible    ${i}    ${j}
        END
            Wait Until Element Is Not Visible    xpath: //img[@alt="slideshow-${i}"]
    END
    Element Should Be Visible    xpath: //img[@alt="slideshow-0"]
    [Teardown]    Close Browser

*** Keywords ***
check_correct_slideshow-index_is_visible
    [Arguments]    ${i}    ${j}
    IF    ${i} == ${j}
        Element Should Be Visible    xpath: //img[@alt="slideshow-${j}"]
        Element Attribute Value Should Be    id:sliderdot${j}    class    ${indicator-class-active}
    ELSE
        Element Should Not Be Visible    xpath: //img[@alt="slideshow-${j}"]
        Element Attribute Value Should Be    id:sliderdot${j}    class    ${indicator-class-non-active}
    END
