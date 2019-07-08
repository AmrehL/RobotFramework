
*** Settings ***
Library         Collections
Library         String
Library         REST
Library         BuiltIn

Resource        config.txt

*** Variables ***
#Test-StoryLine-Correct
${cmd00028_Correct}                 {"cmd":"00028","param":{"first":"test01","second":"test02"}}

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
    Post            ${urlFirst}   

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

TestCmd00028
    [Arguments]         ${input}                        ${token}
    ${output}           CallCmd                         ${input}                        ${token} 
    Log To Console      <Output> ${output}
    ${length}           Get Length                      ${output}             
    Log To Console      <Length> ${length}
    [return]            ${output}

Show Test
    Log To Console      HelloWorld    

*** Test Cases ***   
Test-StoryLine-Correct
    #StartUpApplication
    ${token}                ASynceWorkerFirst
    #CallCmd00028-TestRobotFramework
    ${output00028}          TestCmd00028            ${cmd00028_Correct}             ${token}

