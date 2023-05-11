*** Settings ***
Library           SeleniumLibrary
Resource          resources/resource.resource

*** Variables ***
${indicator-class-non-active}    react-any-slider-dots__dot react-any-slider-dots__dot--big
${indicator-class-active}    react-any-slider-dots__dot react-any-slider-dots__dot--big react-any-slider-dots__dot--active

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
    Element Should Be Visible    xpath: //img[@alt="slideshow-0"]
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

indicators
    browser_opening
    FOR    ${i}    IN RANGE    ${8}
        Click Element    id:sliderdot${i}
        FOR    ${j}    IN RANGE    ${8}
            IF    ${i} == ${j}
                Element Should Be Visible    xpath: //img[@alt="slideshow-${j}"]
                Element Attribute Value Should Be    id:sliderdot${j}    class    ${indicator-class-active}
            ELSE
                Element Should Not Be Visible    xpath: //img[@alt="slideshow-${j}"]
                Element Attribute Value Should Be    id:sliderdot${j}    class    ${indicator-class-non-active}
            END
        END
    END
    Close Browser
