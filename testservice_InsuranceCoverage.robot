
*** Settings ***
Library         Collections
Library         String
Library         REST
Library         BuiltIn

Resource        config.txt

*** Variables ***
#fix Test-Correct phoneNumber is 9999999997 , user_id is 1843
#fix Test-Incorrect phoneNumber is 9999999996 , user_id is 1872

#Test-StoryLine-Correct
${cmd00026_Correct}                 {"cmd":"00026","param":["1843"]}
${myValue}                          15450
${cmd00030_Correct}                 {"cmd":"00030","param":["1843",{"reserve_money_id":0,"suggestion_of_cash_reserve_id":0,"reserve_money":${myValue},"insurance_coverage":{"insurance_coverage_id":0,"suggestion_of_insurance_coverage_id":0,"user_id":0,"expanse_for_family":0.0,"percent_expense_for_family":0.0,"list_life_insurance":[],"list_health_insurance":[]},"credit_buro":"N","list_home":[],"list_car":[],"list_cash_loan":[],"list_credit_card":[],"list_other":[],"list_other_dept":[],"list_land":[],"list_fund":[],"list_stock":[],"list_bond":[],"list_home_not_free_dept":[],"list_car_not_free_dept":[],"total_home":0.0,"total_car":0.0,"total_cash_loan":0.0,"total_credit_card":0.0,"total_other":0.0,"total_land":0.0,"total_fund":0.0,"total_stock":0.0,"total_bond":0.0,"total_home_not_free_dept":0.0,"total_car_not_free_dept":0.0,"total_cash_loan_not_free_dept":0.0,"total_credit_card_not_free_dept":0.0,"total_land_not_free_dept":0.0,"total_other_not_free_dept":0.0,"total_home_free_dept":0.0,"total_car_free_dept":0.0,"total_cash_loan_free_dept":0.0,"total_credit_card_free_dept":0.0,"total_land_free_dept":0.0,"total_other_free_dept":0.0}]}

#Test-StoryLine-InCorrect
${cmd00026_EmptyFull}               {"cmd":"00026","param":[""]}
${cmd00030_EmptyFull}               {"cmd":"00030","param":["1872",{"reserve_money_id":,"suggestion_of_cash_reserve_id":,"reserve_money":,"insurance_coverage":{"insurance_coverage_id":,"suggestion_of_insurance_coverage_id":,"user_id":,"expanse_for_family":,"percent_expense_for_family":,"list_life_insurance":[],"list_health_insurance":[]},"credit_buro":"N","list_home":[],"list_car":[],"list_cash_loan":[],"list_credit_card":[],"list_other":[],"list_other_dept":[],"list_land":[],"list_fund":[],"list_stock":[],"list_bond":[],"list_home_not_free_dept":[],"list_car_not_free_dept":[],"total_home":,"total_car":,"total_cash_loan":,"total_credit_card":,"total_other":,"total_land":,"total_fund":,"total_stock":,"total_bond":,"total_home_not_free_dept":,"total_car_not_free_dept":,"total_cash_loan_not_free_dept":,"total_credit_card_not_free_dept":,"total_land_not_free_dept":,"total_other_not_free_dept":,"total_home_free_dept":,"total_car_free_dept":,"total_cash_loan_free_dept":,"total_credit_card_free_dept":,"total_land_free_dept":,"total_other_free_dept":}]}
${cmd00030_InvalidData}             {"cmd":"00030","param":["1872",{"reserve_money_id":0,"suggestion_of_cash_reserve_id":0,"reserve_money":-123,"insurance_coverage":{"insurance_coverage_id":0,"suggestion_of_insurance_coverage_id":0,"user_id":0,"expanse_for_family":0.0,"percent_expense_for_family":0.0,"list_life_insurance":[],"list_health_insurance":[]},"credit_buro":"N","list_home":[],"list_car":[],"list_cash_loan":[],"list_credit_card":[],"list_other":[],"list_other_dept":[],"list_land":[],"list_fund":[],"list_stock":[],"list_bond":[],"list_home_not_free_dept":[],"list_car_not_free_dept":[],"total_home":0.0,"total_car":0.0,"total_cash_loan":0.0,"total_credit_card":0.0,"total_other":0.0,"total_land":0.0,"total_fund":0.0,"total_stock":0.0,"total_bond":0.0,"total_home_not_free_dept":0.0,"total_car_not_free_dept":0.0,"total_cash_loan_not_free_dept":0.0,"total_credit_card_not_free_dept":0.0,"total_land_not_free_dept":0.0,"total_other_not_free_dept":0.0,"total_home_free_dept":0.0,"total_car_free_dept":0.0,"total_cash_loan_free_dept":0.0,"total_credit_card_free_dept":0.0,"total_land_free_dept":0.0,"total_other_free_dept":0.0}]}


*** Keywords ***
ASynceWorkerFirst
    ${header}=  Create Dictionary   
    ...     lumpsum_unique_id       0bc8083eaecfb6f7
    ...     lumpsum_token_id	    1234
    ...     device                  GoogldAndroidSDK()
    ...     app_version             1.0
    ...     os_version              AndroidSDK25(7.1.1)
    ...     lang                    en
    ...     os_type                 android
    ...     lumpsum_email           test@test.com
    ...     automated_test          Y
    Set Headers                     ${header}
    Post    ${urlFirst}   

    ${out}              Output                          response body    string
    ${str}              Convert To String           ${out}
    ${str}              Replace String              ${str}      u'      "
    ${str}              Replace String              ${str}      "{      {
    ${str}              Replace String              ${str}      '}      }
    ${out}              Replace String              ${str}      '       "
    ${json}             evaluate                    json.loads('''${out}''')    json    
    ${json_string}      evaluate                    json.dumps(${json})         json
    ${token}            Convert To String           ${json['d']['token']}
    [return]            ${token}

CreateHeader
    [Arguments]         ${token} 
    ${headers}    Create Dictionary    
    ...    lumpsum_unique_id   0bc8083eaecfb6f7
    ...    lumpsum_token_id    ${token}
    ...    app_version         1.0
    ...    device              Samsung SM
    ...    os_version          Android
    ...    os_type             android
    ...    lumpsum_email       wasabiTitleTp@gmail.com
    ...    lang                en
    ...    automated_test      Y
    [return]            ${headers}    

CallCmd
    [Arguments]         ${input}                    ${token} 
    ${header}           CreateHeader                ${token}         
    ${header}           Convert To String           ${header}
    ${header}           Replace String              ${header}   u'      "
    ${header}           Replace String              ${header}   '       "

    #แบบ Non-Encrypt
    ${input}            Convert To String           ${input}
    ${input}=           Create Dictionary           param=${input}
    # log to console      <Input> ${input}
    Set Headers         ${header}
    Post                ${urlCmd}                   ${input}
    ${output}           Output                      response body    string
    ${output}           Convert To String           ${output}
    # log to console      <Output> ${Output} 
    [return]            ${output}

Get-From-Output
    [Arguments]         ${input}                    ${target}
    ${input}            Replace String              ${input}   \\'             1      
    ${input}            Replace String              ${input}   u'      "
    ${input}            Replace String              ${input}   '       "
    ${input}            Replace String              ${input}   {"d": "{        {
    ${input}            Replace String              ${input}   }"}             }
    ${input}            Replace String              ${input}   \\"""0\\"""     0 
    ${json}             evaluate                    json.loads('''${input}''')      json    
    ${json_string}      evaluate                    json.dumps(${json})             json
    ${output}           Convert To String           ${json${target}}
    ${output}           Replace String              ${output}   \\      ${EMPTY}
    # Log To Console      <output> ${output}
    [return]            ${output}     


TestInvalid
    [Arguments]         ${input}   
    ${token}            ASynceWorkerFirst
    ${output}           CallCmd                     ${input}                        ${token} 

TestCmd00026First
    [Arguments]         ${input}                    ${token}
    ${output}           CallCmd                     ${input}                        ${token}
    ${inner}            Get-From-Output             ${output}                       ['data']
    # Log To Console      \n<Old> ${inner}
    [return]            ${output}

TestCmd00030
    [Arguments]         ${input}                    ${inputToken}
    ${token}            Get-From-Output             ${inputToken}                   ['token']
    ${output}           CallCmd                     ${input}                        ${token}
    ${inner}            Get-From-Output             ${output}                       ['data']
    [return]            ${output}

TestCmd00026Second
    [Arguments]         ${input}                    ${inputToken}
    ${token}            Get-From-Output             ${inputToken}                   ['token']
    ${output}           CallCmd                     ${input}                        ${token}
    ${inner}            Get-From-Output             ${output}                       ['data']
    # Log To Console      \n<New> ${inner}
    [return]            ${output}

*** Test Cases ***   
Test-StoryLine-Correct
    #StartUpApplication
    ${token}            ASynceWorkerFirst
    #CallCmd00026-GetListQuestion_Insurance_Coverage
    ${output00026}      TestCmd00026First           ${cmd00026_Correct}             ${token}
    #CallCmd00030-SaveQuestion_Insurance_Coverage
    ${output00030}      TestCmd00030                ${cmd00030_Correct}             ${output00026}
    #CallCmd00026-GetListQuestion_Insurance_Coverage
    ${output00026}      TestCmd00026Second          ${cmd00026_Correct}             ${output00030}

Test-StoryLine-InCorrect
    #InCorrectCase-in-CallCmd00026
    TestInvalid         ${cmd00026_EmptyFull}
    #InCorrectCase-in-CallCmd00030
    TestInvalid         ${cmd00030_EmptyFull}
    TestInvalid         ${cmd00030_InvalidData}
