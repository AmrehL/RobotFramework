
*** Settings ***
Documentation     Test with SOAP 
Library         REST
Library         BuiltIn
Library         Process
Library         DatabaseLibrary
Library         RedisLibrary
Library         CassandraCQLLibrary
Library         ImapLibrary

Resource        config.txt


*** Variables ***


*** Test Cases ***
Server Connection Status
    ${result}           Run Process         ping -c 6 ${IPwebservice}   shell=True 
    Log                 all output: ${result.stdout}
    Should Contain      ${result.stdout}    time=  

Database Status
    Connect to Database         pymysql   lumpsum       ${Username}     ${Password}    ${DatabaseHost}    ${Port}

Redis Status
    ${redis_conn}               Connect To Redis        ${IPRedis}      ${PortRedis}     

Cassandra Status
    Connect To Cassandra        ${IPCassandra}          ${PortCassandra}
    Disconnect From Cassandra

Email Status
    ${result}           Run Process         ping -c 6 ${IPEmail}   shell=True 
    Log                 all output: ${result.stdout}
    Should Contain      ${result.stdout}    time= 
    # Open Mailbox    host=${IPEmail}    user=praiwan@efinancethai.com    password=123456  is_secure=False
    # Close Mailbox

OTP Server Status
    Post                ${urlOTP}   
    ${out}              Output              response body    string    
    Should Contain      ${out}              <Status>0</Status>
    # ${result} =     Run Process  ping www.thaibulksms.com   shell=True 
    # Log     all output: ${result.stdout}
    # Should Contain  ${result.stdout}    0% loss 

*** Keywords ***