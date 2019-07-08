*** Settings ***
Documentation     Test with SOAP 
Library         REST
Library         BuiltIn
Library         Process
Library         DatabaseLibrary
Library         RedisLibrary
Library         CassandraCQLLibrary
Library         ImapLibrary


*** Variables ***
#Database
${Port}             3306
${Username}         efinFP
${DatabaseHost}     192.168.241.72
${Password}         efinFP

#Webservice
${IPwebservice}	    10.88.40.96

#Redis
${IPRedis}	    192.168.68.26
${PortRedis}	    6380

#Cassandra
${IPCassandra}	    192.168.241.74
${PortCassandra}    9042

#Email
${IPEmail}	    10.88.0.9

#OTP
${urlOTP}	    http://www.thaibulksms.com/sms_api.php


*** Test Cases ***
Server Connection Status
    ${result} =     Run Process  ping ${IPwebservice}   shell=True 
    Log     all output: ${result.stdout}
    Should Contain  ${result.stdout}    0% loss  

Database Status
    Connect to Database      pymysql   lumpsum    ${Username}    ${Password}    ${DatabaseHost}    ${Port}

Redis Status
    ${redis_conn}           Connect To Redis        ${IPRedis}       ${PortRedis}     

Cassandra Status
    Connect To Cassandra    ${IPCassandra}    ${PortCassandra}
    Disconnect From Cassandra

Email Status
    ${result} =     Run Process  ping ${IPEmail}   shell=True 
    Log     all output: ${result.stdout}
    Should Contain  ${result.stdout}    0% loss 
    # Open Mailbox    host=${IPEmail}    user=praiwan@efinancethai.com    password=123456  is_secure=False
    # Close Mailbox

OTP Server Status
    Post                ${urlOTP}   
    ${out}              Output                  response body    string    
    Should Contain  ${out}    <Status>0</Status>
    # ${result} =     Run Process  ping www.thaibulksms.com   shell=True 
    # Log     all output: ${result.stdout}
    # Should Contain  ${result.stdout}    0% loss 

*** Keywords ***