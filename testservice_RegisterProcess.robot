
*** Settings ***
Library         Collections
Library         String
Library         REST
Library         BuiltIn

Resource        config.txt

*** Variables ***
#RegisterByOtp
#if every run program else edit phone and time in cmd00023_Correct
#and Test-StoryLine-Wrong-Special use to ditto cmd00023_Correct but different soap header
#Test-StoryLine-Correct
${newPhoneNumber}                   1111111807
${cmd00023_Correct}                 {"cmd":"00023","param":["${newPhoneNumber}","2019-06-26 11:33:01"]}
${pincode}                          987654
${cmd00002_Correct}                 {"cmd":"00002","param":{"birth_date":"2005-08-10","gender":"1","age":"0","retire_age":"61","income_per_month":"0","expense_per_month":"0","growth_rate_income":"0.03","growth_rate_expense":"0.01","inflation":"0.03","invest_after_retire":"0.06","age_die":"76","expense_after_retire":"0.06","buy_car":"","baby":"","buy_insurance":"","advance_calculate":"N","user_id":"user_id_value"}}
${cmd00022_Correct}                 {"cmd":"00022","param":{"":""}}


#Test-StoryLine-InCorrect
${cmd00023_Duplicate}               {"cmd":"00023","param":["1111111111","2019-06-26 11:33:01"]}
${cmd00023_EmptyFull}               {"cmd":"00023","param":["",""]}
${cmd00023_EmptyPhoneNumber}        {"cmd":"00023","param":["","2019-06-26 11:33:01"]}
${cmd00023_EmptyDateTime}           {"cmd":"00023","param":["1111111111",""]}
${cmd00024_Invalid}                 {"cmd":"00024","param":["1111111111","222222"]}
${cmd00024_EmptyFull}               {"cmd":"00024","param":["",""]}
${cmd00024_EmptyPhoneNumber}        {"cmd":"00024","param":["","222222"]}
${cmd00024_EmptyOtp}                {"cmd":"00024","param":["1111111111",""]}
${cmd00004_NotRegisterPhone}        {"cmd":"00004","param":["0","222222"]}
${cmd00004_OnceCreatePin}           {"cmd":"00004","param":["1111111270","222222"]}
${cmd00004_EmptyTotal}              {"cmd":"00004","param":["",""]}
${cmd00004_EmptyPhone}              {"cmd":"00004","param":["","222222"]}
${cmd00004_EmptyPincode}            {"cmd":"00004","param":["1111111111",""]}
${cmd00002_EmptyTotal}              {"cmd":"00002","param":[{"birth_date":"","gender":"","age":"","retire_age":"","income_per_month":"","expense_per_month":"","growth_rate_income":"","growth_rate_expense":"","inflation":"","invest_after_retire":"","age_die":"","expense_after_retire":"","buy_car":"","baby":"","buy_insurance":"","advance_calculate":"","user_id":""}]}
${cmd00032_Invalid}                 {"cmd":"00032","param":["0"]}


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
    ${str}              Convert To String               ${out}
    ${str}              Replace String                  ${str}      u'      "
    ${str}              Replace String                  ${str}      "{      {
    ${str}              Replace String                  ${str}      '}      }
    ${out}              Replace String                  ${str}      '       "
    ${json}             evaluate                        json.loads('''${out}''')    json    
    ${json_string}      evaluate                        json.dumps(${json})         json
    ${token}            Convert To String               ${json['d']['token']}
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
    [Arguments]         ${input}                        ${token} 
    ${header}           CreateHeader                    ${token}         
    ${header}           Convert To String               ${header}
    ${header}           Replace String                  ${header}   u'      "
    ${header}           Replace String                  ${header}   '       "

    #แบบ Non-Encrypt
    ${input}            Convert To String               ${input}
    ${input}=           Create Dictionary               param=${input}
    # log to console      <Input> ${input}
    Set Headers         ${header}
    Post                ${urlCmd}                          ${input}
    ${output}           Output                          response body    string
    ${output}           Convert To String               ${output}
    # log to console      <Output> ${Output} 
    [return]            ${output}

Get-From-Output
    [Arguments]         ${input}                        ${target}
    ${input}            Replace String                  ${input}   \\'             1      
    ${input}            Replace String                  ${input}   u'      "
    ${input}            Replace String                  ${input}   '       "
    ${input}            Replace String                  ${input}   {"d": "{        {
    ${input}            Replace String                  ${input}   }"}             }
    ${input}            Replace String                  ${input}   \\"""0\\"""     0 
    ${json}             evaluate                        json.loads('''${input}''')      json    
    ${json_string}      evaluate                        json.dumps(${json})             json
    ${output}           Convert To String               ${json${target}}
    # Log To Console      <output> ${output}
    [return]            ${output}

Get-Phone
    [Arguments]         ${input}   
    ${output}           Convert To String               ${input} 
    ${output}           Replace String                  ${output}   [       ${EMPTY}        count=1          
    ${output}           Replace String                  ${output}   ]       ${EMPTY}        count=1          
    ${output}           Replace String                  ${output}   u'      ${EMPTY}        count=2         
    ${output}           Replace String                  ${output}   '       ${EMPTY}        count=2     
    @{arrOutput}        Split String                    ${output}   ,
    ${output}           Convert To String               ${arrOutput[0]}
    [return]            ${output}

Get-Otp
    [Arguments]         ${input}   
    ${output}           Convert To String               ${input} 
    @{arrOutput}        Split String                    ${output}   |
    ${output}           Convert To String               ${arrOutput[1]}
    [return]            ${output}

CreateInputUserid
    [Arguments]         ${cmd}                          ${userid}                        
    ${output}           Convert To String               {"cmd":"${cmd}","param":["${userid}"]} 
    [return]            ${output} 

CreateInputTwoInput
    [Arguments]         ${cmd}                          ${phone}                       ${otp}      
    ${output}           Convert To String               {"cmd":"${cmd}","param":["${phone}","${otp}"]} 
    [return]            ${output} 

TestInvalid
    [Arguments]         ${input}   
    ${token}            ASynceWorkerFirst
    ${output}           CallCmd                         ${input}                        ${token} 
    ${data}             Get-From-Output                 ${output}                       ['data']

TestCmd00023
    [Arguments]         ${input}                    ${token}   
    ${output}           CallCmd                     ${input}                        ${token} 
    Get-From-Output     ${output}                   ['data']['msg']
    [return]            ${output}

TestCmd00024     
    [Arguments]         ${input}
    ${param}            Get-From-Output             ${input}                       ['param']
    ${phone}            Get-Phone                   ${param}  
    ${msg}              Get-From-Output             ${input}                       ['data']['msg']    
    ${otp}              Get-Otp                     ${msg}
    ${token}            Get-From-Output             ${input}                       ['token']
    ${data}             CreateInputTwoInput         00024                          ${phone}                        ${otp}
    ${output}           CallCmd                     ${data}                        ${token} 
    Get-From-Output     ${output}                   ['data']['msg']
    [return]            ${output}

TestCmd00004
    [Arguments]         ${input}
    ${param}            Get-From-Output             ${input}                       ['param']
    ${phone}            Get-Phone                   ${param}  
    ${data}             CreateInputTwoInput         00004                          ${phone}                        ${pincode}
    ${token}            Get-From-Output             ${input}                       ['token']
    ${output}           CallCmd                     ${data}                        ${token} 
    Get-From-Output     ${output}                   ['data']['msg']
    [return]            ${output}

TestCmd00022
    [Arguments]         ${input}                    ${inputToken}
    ${token}            Get-From-Output             ${inputToken}                   ['token']
    ${output}           CallCmd                     ${input}                         ${token}
    Get-From-Output     ${output}                   ['data']
    [return]            ${output}           

TestCmd00002   
    [Arguments]         ${input}                    ${inputToken}
    ${token}            Get-From-Output             ${inputToken}                   ['token']
    ${msg}              Get-From-Output             ${input}                        ['data']['msg']
    @{arrOutput}        Split String                ${msg}   |
    ${userid}           Convert To String           ${arrOutput[1]}
    ${input}            Convert To String           ${cmd00002_Correct}
    ${input}            Replace String              ${input}                        user_id_value                   ${userid} 
    ${output}           CallCmd                     ${input}                        ${token} 
    [return]            ${output}

TestCmd00025
    [Arguments]         ${input}                    ${token}
    ${msg}              Get-From-Output             ${input}                        ['data']['msg']
    @{arrOutput}        Split String                ${msg}      |
    ${userid}           Convert To String           ${arrOutput[1]}
    ${data}             CreateInputUserid           00025                           ${userid}                       
    ${output}           CallCmd                     ${data}                         ${token}
    Get-From-Output     ${output}                   ['data']
    [return]            ${output}           

TestCmd00029
    [Arguments]         ${input}                    ${inputToken}
    ${token}            Get-From-Output             ${inputToken}                   ['token']
    ${msg}              Get-From-Output             ${input}                        ['data']['msg']
    @{arrOutput}        Split String                ${msg}      |
    ${userid}           Convert To String           ${arrOutput[1]}
    ${data}             CreateInputUserid           00029                           ${userid}  
    ${output}           CallCmd                     ${data}                         ${token}
    Get-From-Output     ${output}                   ['data']
    [return]            ${output} 

TestCmd00032
    [Arguments]         ${input}                    ${inputToken}
    ${token}            Get-From-Output             ${inputToken}                   ['token']
    ${msg}              Get-From-Output             ${input}                        ['data']['msg']
    @{arrOutput}        Split String                ${msg}      |
    ${userid}           Convert To String           ${arrOutput[1]}
    ${data}             CreateInputUserid           00032                           ${userid}  
    ${output}           CallCmd                     ${data}                         ${token}
    Get-From-Output     ${output}                   ['data']['msg']
    [return]            ${output}

*** Test Cases ***   
Test-StoryLine-Correct
    #StartUpApplication
    ${token}                ASynceWorkerFirst
    #CallCmd00023-RegisterByOtp
    ${output00023}          TestCmd00023            ${cmd00023_Correct}             ${token}
    #CallCmd00024-ConfirmRegisterByOtp
    ${output00024}          TestCmd00024            ${output00023}
    #CallCmd00004-SetNewPincodeByMobile
    ${output00004}          TestCmd00004            ${output00024}
    #CallCmd00022-GetDefaultData
    ${output00022}          TestCmd00022            ${cmd00022_Correct}             ${output00004}
    #CallCmd00002-CalculateRetirement
    #return-value-of-00002 is very long then robot-framework have read problem 
    ${output00002}          TestCmd00002            ${output00024}                  ${output00022}

    #StartUpApplication
    ${token}                ASynceWorkerFirst
    #CallCmd00025-GetInformation
    ${output00025}          TestCmd00025            ${output00024}                  ${token} 
    #CallCmd00029-GetListSuggestions
    ${output00029}          TestCmd00029            ${output00024}                  ${output00025}
    #CallCmd00032-Logout
    ${output00032}          TestCmd00032            ${output00024}                  ${output00029}        


Test-StoryLine-InCorrect
    #InCorrectCase-in-CallCmd00023
    TestInvalid             ${cmd00023_Duplicate}
    TestInvalid             ${cmd00023_EmptyFull}
    TestInvalid             ${cmd00023_EmptyPhoneNumber}
    TestInvalid             ${cmd00023_EmptyDateTime}
    #InCorrectCase-in-CallCmd00024
    TestInvalid             ${cmd00024_Invalid}
    TestInvalid             ${cmd00024_EmptyFull}
    TestInvalid             ${cmd00024_EmptyPhoneNumber}
    TestInvalid             ${cmd00024_EmptyOtp}
    #InCorrectCase-in-CallCmd00004
    TestInvalid             ${cmd00004_NotRegisterPhone}
    TestInvalid             ${cmd00004_OnceCreatePin}
    TestInvalid             ${cmd00004_EmptyTotal}
    TestInvalid             ${cmd00004_EmptyPhone}
    TestInvalid             ${cmd00004_EmptyPincode}
    #InCorrectCase-in-CallCmd00002
    TestInvalid             ${cmd00002_EmptyTotal}
    #InCorrectCase-in-CallCmd00032
    TestInvalid             ${cmd00032_Invalid}