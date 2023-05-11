*** Settings ***
Library           SeleniumLibrary
Resource          resources/resource.resource

*** Test Cases ***
arrow-buttons
    browser_opening
    FOR    ${i}    IN RANGE    ${8}
        FOR    ${j}    IN RANGE    ${8}
            IF    ${i} == ${j}
                Element Should Be Visible    xpath: //img[@alt="slideshow-${j}"]
            ELSE
                Element Should Not Be Visible    xpath: //img[@alt="slideshow-${j}"]
            END
        END
        Click Button    xpath://button[@data-testid="slider-next-button"]
    END
    Element Should Be Visible    xpath: //img[@alt="slideshow-${0}"]
    FOR    ${i}    IN RANGE    ${8}
        Click Button    xpath://button[@data-testid="slider-prev-button"]
        FOR    ${j}    IN RANGE    ${8}
            IF    ${i} == ${j}
                Element Should Be Visible    xpath: //img[@alt="slideshow-${7 - ${j}}"]
            ELSE
                Element Should Not Be Visible    xpath: //img[@alt="slideshow-${7 - ${j}}"]
            END
        END
    END
    Close Browser
