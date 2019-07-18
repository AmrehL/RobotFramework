
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
${cmd00027_Correct}                 {"cmd":"00027","param":["1843"]}
${myValue}                          180750
${cmd00031_Correct}                 {"cmd":"00031","param":["1843",{\"list_home\":[],\"list_car\":[],\"list_cash_loan\":[],\"list_home_not_free_dept\":[{\"no\":1,\"free_of_debts\":\"N\",\"home_id\":0,\"home_value\":\"${myValue}\",\"installment_period_year\":\"20\",\"level\":1,\"year_of_the_installment\":\"2562\",\"monthly_installment\":\"20000\"}],\"list_car_not_free_dept\":[],\"list_credit_card\":[],\"list_other_dept\":[],\"credit_buro\":\"N\",\"total_home\":0,\"total_car\":0,\"total_cash_loan\":0,\"total_home_not_free_dept\":0,\"total_car_not_free_dept\":0,\"total_cash_loan_not_free_dept\":0,\"total_home_free_dept\":0,\"total_car_free_dept\":0,\"total_cash_loan_free_dept\":0}]}

#Test-StoryLine-InCorrect
${cmd00027_EmptyFull}               {"cmd":"00027","param":[""]}
${cmd00031_EmptyFull}               {"cmd":"00031","param":["1872","{\"list_home\":[],\"list_car\":[],\"list_cash_loan\":[],\"list_home_not_free_dept\":[],\"list_car_not_free_dept\":[],\"list_credit_card\":[],\"list_other_dept\":[],\"credit_buro\":\"N\",\"total_home\":,\"total_car\":,\"total_cash_loan\":,\"total_home_not_free_dept\":,\"total_car_not_free_dept\":,\"total_cash_loan_not_free_dept\":,\"total_home_free_dept\":,\"total_car_free_dept\":,\"total_cash_loan_free_dept\":}"]}
${cmd00031_InvalidData}             {"cmd":"00031","param":["1872",{\"list_home\":[],\"list_car\":[],\"list_cash_loan\":[],\"list_home_not_free_dept\":[{\"no\":1,\"free_of_debts\":\"N\",\"home_id\":0,\"home_value\":\"${myValue}\",\"installment_period_year\":\"20\",\"level\":1,\"year_of_the_installment\":\"2562\",\"monthly_installment\":\"-20000\"}],\"list_car_not_free_dept\":[],\"list_credit_card\":[],\"list_other_dept\":[],\"credit_buro\":\"N\",\"total_home\":0,\"total_car\":0,\"total_cash_loan\":0,\"total_home_not_free_dept\":0,\"total_car_not_free_dept\":0,\"total_cash_loan_not_free_dept\":0,\"total_home_free_dept\":0,\"total_car_free_dept\":0,\"total_cash_loan_free_dept\":0}]}



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

TestCmd00027First
    [Arguments]         ${input}                    ${token}
    ${output}           CallCmd                     ${input}                        ${token}
    ${inner}            Get-From-Output             ${output}                   ['data']
    # Log To Console      \n<Old> ${inner} 
    [return]            ${output}

TestCmd00031
    [Arguments]         ${input}                    ${inputToken}
    ${token}            Get-From-Output             ${inputToken}                   ['token']
    ${output}           CallCmd                     ${input}                        ${token}
    Get-From-Output     ${output}                   ['data']
    [return]            ${output}

TestCmd00027Second
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
    #CallCmd00027-GetListQuestion_CreditLoan
    ${output00027}      TestCmd00027First           ${cmd00027_Correct}             ${token}    
    #CallCmd00031-SaveQuestion_Credit_Loan
    ${output00031}      TestCmd00031                ${cmd00031_Correct}             ${output00027} 
    #CallCmd00027-GetListQuestion_CreditLoan
    ${output00027}      TestCmd00027Second          ${cmd00027_Correct}             ${output00031}    


Test-StoryLine-InCorrect
    #InCorrectCase-in-CallCmd00027
    TestInvalid         ${cmd00027_EmptyFull}
    #InCorrectCase-in-CallCmd00031
    TestInvalid         ${cmd00031_EmptyFull}
    TestInvalid         ${cmd00031_InvalidData}

    