# RobotFramework

Test-Case ประกอบไปด้วย
1. testservice_RegisterProcess.robot เป็นการทดสอบตั้งแต่เริ่มสมัครแอพถึงออกจากแอพ
(ผ่านการกรอกเบอร์โทรศัพท์ , ขอOTP ,ยืนยันOTP ,ตั้งรหัสPinCode ,กรอกข้อมูลพื้นฐาน ,โหลดข้อมูลหน้าหลัก และออกจากระบบ)
*ไม่สามารถรันได้ในขณะนี้ เนื่องจากทุกครั้งที่รันต้องมีการไปเคลียร์รายการข้อมูลในฐานข้อมูล
คำสั่งในการรันคือ robot testservice_RegisterProcess.robot

2. testservice_KillToLogin.robot เป็นการทดสอบเมื่อคิลแอพแล้วกลับเข้ามาล็อคอิคใหม่ <ผ่านการสมัครไอดีแล้ว>
(ผ่านการยืนยันPincode และการโหลดข้อมูลหน้าหลัก)
คำสั่งในการรันคือ robot testservice_KillToLogin.robot

3. testservice_LogoutToLogin.robot เป็นการทดสอบเมื่อออกจากระบบแล้วกลับมาเข้าล็อคอินใหม่ <ผ่านการสมัครไอดีแล้ว>
(ผ่านการออกจากระบบ , การกรอกเบอร์โทรศัพท์ ,การยืนยันOTP ,การยืนยันPincode และการโหลดข้อมูลหน้าหลัก)
คำสั่งในการรันคือ robot testservice_LogoutToLogin.robot

4. testservice_ReduceTax.robot เป็นการทดสอบเมื่อกรอกข้อมูลการลดภาษีแล้วกดยืนยัน
(ผ่านการแสดงข้อมูลภาษี ,การรับข้อมูลภาษี และการแสดงข้อมูลภาษีใหม่ที่รับมา)
คำสั่งในการรันคือ robot testservice_ReduceTax.robot

5. testservice_CreditLoan.robot เป็นการทดสอบเมื่อกรอกข้อมูลเกี่ยวกับประกันชีวิตในส่วนของเงินสำรอง
(ผ่านการแสดงผลเงินสำรอง และการรับข้อมูลเงินสำรอง)
คำสั่งในการรันคือ robot testservice_CreditLoan.robot

6. testservice_InsuranceCoverage.robot เป็นการทดสอบเมื่อกรอกข้อมูลเกี่ยวกับหนี้สินในส่วนของหนี้สิน
คำสั่งในการรันคือ robot testservice_InsuranceCoverage.robot 

7. testservice_CheckServerStatus.root เป็นการทดสอบเชื่อมต่อ server ต่างๆที่แอพพลิเคชั่นเกี่ยวข้อง
*อาจจะมีปัญหาในการเชื่อมต่อ (บังคับต่อตรง)
คำสั่งในการรันคือ robot testservice_CheckServerStatus.root


***นอกจากเหนือจากนี้ จะมีไฟล์ config.txt เป็นไฟล์ประกาศตัวแปรร่วมของ testcase 
และไฟล์ chromedriver ไว้สำหรับรันแบบ selenium (หากพึงมี)
