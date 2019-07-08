
*** Settings ***
Library         Collections
Library         String
Library         REST
Library         BuiltIn

Resource        config.txt

*** Variables ***
#fix phoneNumber is 9999999997 , user_id is 1843
#Test-StoryLine-Correct
${cmd00034_Correct}                 {"cmd":"00034","param":["1843"]}

*** Settings ***
Library         Collections
Library         String
Library         REST
Library         BuiltIn

Resource        config.txt

*** Variables ***
#fix phoneNumber is 9999999997 , user_id is 1843
#Test-StoryLine-Correct
${cmd00034_Correct}                 {"cmd":"00034","param":["1843"]}
${new_value}                        2700
${cmd00033_Correct}                 {"cmd":"00033","param":["1843",{"tax_id":"","annual_income":${new_value} ,"less_expenses":${new_value} ,"income_less_expenses":${new_value} ,"deduction_taxpayer":60000.0,"deduction_spouse":${new_value} ,"deduction_child":${new_value} ,"deduction_parent":${new_value} ,"deduction_antenatal_confined":${new_value} ,"deduction_disabled":${new_value},"insurance_premium":${new_value},"health_insurance_parant":${new_value},"self_health_insurance":${new_value},"life_insurance_pensioners":${new_value},"ltf_purchase":${new_value},"rmf_purchase":${new_value},"national_savings_fund":${new_value},"social_security_money":${new_value},"provident_fund":${new_value},"interest_residence":${new_value},"social_donation":${new_value},"general_donation":${new_value},"first_house_project":${new_value},"first_house_project_62":${new_value},"shopping_for_nation":${new_value},"travel_core_visited_area":${new_value},"travel_less_visited_area":${new_value},"cctv_purchase":${new_value},"political_donation":${new_value},"invest_startup":${new_value},"fee_debit_card":${new_value},"home_repairs":${new_value},"car_repairs":${new_value},"otop_purchase":${new_value},"ebook_purchase":${new_value},"educational_purchase":${new_value},"oList_parant":[],"oList_child":[],"total_income_per_year":0.00000}]}

#Test-StoryLine-InCorrect
${cmd00033_EmptyFull}               {"cmd":"00033","param":["1843",{"tax_id":"","annual_income":abc ,"less_expenses": ,"income_less_expenses": ,"deduction_taxpayer":60000.0,"deduction_spouse": ,"deduction_child": ,"deduction_parent": ,"deduction_antenatal_confined": ,"deduction_disabled":,"insurance_premium":,"health_insurance_parant":,"self_health_insurance":,"life_insurance_pensioners":,"ltf_purchase":,"rmf_purchase":,"national_savings_fund":,"social_security_money":,"provident_fund":,"interest_residence":,"social_donation":,"general_donation":,"first_house_project":,"first_house_project_62":,"shopping_for_nation":,"travel_core_visited_area":,"travel_less_visited_area":,"cctv_purchase":,"political_donation":,"invest_startup":,"fee_debit_card":,"home_repairs":,"car_repairs":,"otop_purchase":,"ebook_purchase":,"educational_purchase":,"oList_parant":[],"oList_child":[],"total_income_per_year":0.00000}]}
${cmd00033_Alphabet}                {"cmd":"00033","param":["1843",{"tax_id":"","annual_income":abc ,"less_expenses":abc ,"income_less_expenses":abc ,"deduction_taxpayer":60000.0,"deduction_spouse":abc ,"deduction_child":abc ,"deduction_parent":abc ,"deduction_antenatal_confined":abc ,"deduction_disabled":abc,"insurance_premium":abc,"health_insurance_parant":abc,"self_health_insurance":abc,"life_insurance_pensioners":abc,"ltf_purchase":abc,"rmf_purchase":abc,"national_savings_fund":abc,"social_security_money":abc,"provident_fund":abc,"interest_residence":abc,"social_donation":abc,"general_donation":abc,"first_house_project":abc,"first_house_project_62":abc,"shopping_for_nation":abc,"travel_core_visited_area":abc,"travel_less_visited_area":abc,"cctv_purchase":abc,"political_donation":abc,"invest_startup":abc,"fee_debit_card":abc,"home_repairs":abc,"car_repairs":abc,"otop_purchase":abc,"ebook_purchase":abc,"educational_purchase":abc,"oList_parant":[],"oList_child":[],"total_income_per_year":0.00000}]}
${cmd00033_LessThanNegative1}       {"cmd":"00033","param":["1843",{"tax_id":"","annual_income":-123 ,"less_expenses":-123 ,"income_less_expenses":-123 ,"deduction_taxpayer":60000.0,"deduction_spouse":-123 ,"deduction_child":-123 ,"deduction_parent":-123 ,"deduction_antenatal_confined":-123 ,"deduction_disabled":-123,"insurance_premium":-123,"health_insurance_parant":-123,"self_health_insurance":-123,"life_insurance_pensioners":-123,"ltf_purchase":-123,"rmf_purchase":-123,"national_savings_fund":-123,"social_security_money":-123,"provident_fund":-123,"interest_residence":-123,"social_donation":-123,"general_donation":-123,"first_house_project":-123,"first_house_project_62":-123,"shopping_for_nation":-123,"travel_core_visited_area":-123,"travel_less_visited_area":-123,"cctv_purchase":-123,"political_donation":-123,"invest_startup":-123,"fee_debit_card":-123,"home_repairs":-123,"car_repairs":-123,"otop_purchase":-123,"ebook_purchase":-123,"educational_purchase":-123,"oList_parant":[],"oList_child":[],"total_income_per_year":0.00000}]}



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
    [Arguments]         ${cmd}                      ${userid}                       ${data}      
    ${output}           Convert To String           {"cmd":"${cmd}","param":["${userid}","${data}"]} 
    [return]            ${output}


TestInvalid
    [Arguments]         ${input}   
    ${token}            ASynceWorkerFirst
    ${output}           CallCmd                     ${input}                        ${token} 
    ${msg}              Get-From-Output             ${output}                       ['msg']
    ${data}             Get-From-Output             ${output}                       ['data']

TestCmd00034First
    [Arguments]         ${input}                    ${token}
    ${output}           CallCmd                     ${input}                        ${token}
    Get-From-Output     ${output}                   ['data']
    [Return]            ${output}

TestCmd00033
    [Arguments]         ${input}                    ${inputToken}
    ${token}            Get-From-Output             ${inputToken}                   ['token']
    ${output}           CallCmd                     ${input}                        ${token}
    [Return]            ${output}

TestCmd00034Second
    [Arguments]         ${input}                    ${inputToken}
    ${token}            Get-From-Output             ${inputToken}                   ['token']
    ${output}           CallCmd                     ${input}                        ${token}
    [Return]            ${output}

*** Test Cases ***   
Test-StoryLine-Correct
    #StartUpApplication
    ${token}            ASynceWorkerFirst
    #CallCmd00034-GetTaxList-ShowFirst
    ${output00034}      TestCmd00034First           ${cmd00034_Correct}             ${token}
    Log To Console      \n\n ${output00034}
    #CallCmd00033-AddTaxList
    ${output00033}      TestCmd00033                ${cmd00033_Correct}             ${output00034}
    Log To Console      \n\n ${output00033}
    #CallCmd00034-GetTaxList-ShowSecond
    ${output00034}      TestCmd00034Second          ${cmd00034_Correct}             ${output00033}
    Log To Console      \n\n ${output00034}

Test-StoryLine-InCorrect
    #InCorrectCase-in-CallCmd00033
    TestInvalid         ${cmd00033_EmptyFull}
    TestInvalid         ${cmd00033_Alphabet}        
    TestInvalid         ${cmd00033_LessThanNegative1}








    