
*** Settings ***
Library         Collections
Library         String
Library         REST
Library         BuiltIn
Library         DateTime

Resource        config.txt

*** Variables ***
#fix phoneNumber is 9999999998 , user_id is 1822
#Test-StoryLine-Correct
${cmd00023_Correct}                 {"cmd":"00023","param":["9999999998","now_datetime_value"]}
${user_id}      1822
${pincode}      222222

#Test-StoryLine-InCorrect
${cmd00023_EmptyFull}               {"cmd":"00023","param":["",""]}
${cmd00023_EmptyPhoneNumber}        {"cmd":"00023","param":["","2019-06-26 11:33:01"]}
${cmd00023_EmptyDateTime}           {"cmd":"00023","param":["1111111111",""]}
${cmd00005_NoPhoneNumberInSys}      {"cmd":"00005","param":["0","222222"]}
${cmd00005_NotRegisterPhoneNumber}  {"cmd":"00005","param":["0","222222"]}
${cmd00005_InvalidPincode}          {"cmd":"00005","param":["9999999998","222223"]}


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

CreateInputUserid
    [Arguments]         ${cmd}                      ${userid}      
    ${output}           Convert To String           {"cmd":"${cmd}","param":["${userid}"]} 
    [return]            ${output} 

CreateInputTwoInput
    [Arguments]         ${cmd}                      ${phone}                       ${otp}      
    ${output}           Convert To String           {"cmd":"${cmd}","param":["${phone}","${otp}"]} 
    [return]            ${output} 

Get-Phone
    [Arguments]         ${input}   
    ${output}           Convert To String           ${input} 
    ${output}           Replace String              ${output}   [       ${EMPTY}        count=1          
    ${output}           Replace String              ${output}   ]       ${EMPTY}        count=1          
    ${output}           Replace String              ${output}   u'      ${EMPTY}        count=2         
    ${output}           Replace String              ${output}   '       ${EMPTY}        count=2     
    @{arrOutput}        Split String                ${output}   ,
    ${output}           Convert To String           ${arrOutput[0]}
    [return]            ${output}

TestInvalid
    [Arguments]         ${input}   
    ${token}            ASynceWorkerFirst
    ${output}           CallCmd                     ${input}                        ${token} 
    ${data}             Get-From-Output             ${output}                       ['data']

TestCmd00023
    [Arguments]         ${input}                    ${token}
    ${date} =           DateTime.Get Current Date   
    ${date}             Convert To String           ${date} 
    ${date}             Get Substring               ${date}         0           19
    ${input}            Replace String              ${input}                        now_datetime_value          ${date}
    ${output}           CallCmd                     ${input}                        ${token} 
    Get-From-Output     ${output}                   ['data']['msg']
    [return]            ${output}      

TestCmd00005
    [Arguments]         ${input}                    ${inputToken}
    ${token}            Get-From-Output             ${inputToken}                  ['token']
    ${param}            Get-From-Output             ${input}                       ['param']
    ${phone}            Get-Phone                   ${param}      
    ${data}             CreateInputTwoInput         00005                          ${phone}                        ${pincode} 
    ${output}           CallCmd                     ${data}                        ${token}    
    Get-From-Output     ${output}                   ['data']['msg']
    [return]            ${output}

TestCmd00025
    [Arguments]         ${input}                    ${inputToken}
    ${token}            Get-From-Output             ${inputToken}                   ['token']
    ${data}             CreateInputUserid           00025                           ${input}  
    ${output}           CallCmd                     ${data}                         ${token}
    Get-From-Output     ${output}                   ['data']['msg']
    [return]            ${output}

TestCmd00029
    [Arguments]         ${input}                    ${inputToken}
    ${token}            Get-From-Output             ${inputToken}                   ['token']
    ${data}             CreateInputUserid           00029                           ${input}  
    ${output}           CallCmd                     ${data}                         ${token}
    Get-From-Output     ${output}                   ['data']
    [return]            ${output}    


*** Test Cases ***   
Test-StoryLine-Correct
    #StartUpApplication
    ${token}            ASynceWorkerFirst
    #CallCmd00023-RegisterByOtp
    #00023 return data->status is error (because this phone number used to register)
    ${output00023}      TestCmd00023            ${cmd00023_Correct}             ${token}
    #CallCmd00005-SignInWithPincodeByMobile
    ${output00005}      TestCmd00005            ${output00023}                  ${output00023} 
    #CallCmd00025-GetInformation
    ${output00025}      TestCmd00025            ${user_id}                      ${output00005}
    #CallCmd00029-GetListSuggestions
    ${output00029}      TestCmd00029            ${user_id}                      ${output00025}
  

Test-StoryLine-InCorrect
    #InCorrectCase-in-CallCmd00023
    TestInvalid             ${cmd00023_EmptyFull}
    TestInvalid             ${cmd00023_EmptyPhoneNumber}
    TestInvalid             ${cmd00023_EmptyDateTime}
    #InCorrectCase-in-CallCmd00005
    TestInvalid             ${cmd00005_NoPhoneNumberInSys}
    TestInvalid             ${cmd00005_NotRegisterPhoneNumber}
    TestInvalid             ${cmd00005_InvalidPincode}