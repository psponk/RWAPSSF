# RWAPSSF

ทำได้โดย
## 1. แก้ปัญหาการล๊อกเงิน ETH ที่ player ลงขันเข้ามา ให้กำหนดระยะเวลาว่าหลังจาก X minutes (หรือ hours หรือ days) ผ่านไปหลังจาก block.timestamp ที่มีการเรียก transaction ที่เกี่ยวข้อง ให้คืนเงิน ETH กลับไปให้ผู้เล่น หรือลงโทษผู้เล่นที่ไม่ทำตามกติกาโดยนำเงิน ETH ทั้งหมดให้กับผู้เล่นที่ทำตามกติกา

วิธีแก้ปัญหา
- เพิ่มตัวแปรสำหรับเก็บrefundTimeที่สามารถระบุได้ว่าเมื่อผ่านไปเวลาเท่าใดให้ระบบนั้น คืนเงินให้กับผู้เล่นหรือทำการลงโทษปรับผู้เล่น
- ตรวจสอบเวลาโดยใช้ block.timestamp
- หากเข้าเงื่อนไขให้ทำการคืนเงิน/ปรับตามกำหนด

## 2. ทำให้เกมส์มีความซับซ้อนมากยิ่งขึ้น โดยแทนที่จะมีตัวเลือกแค่ Rock Paper และ Scissors เราจะเป็นเกมส์ที่มีตัวเลือก 7 ตัว Rock Water Air Paper Sponge Scissors และ Fire โดยมีกฏเกณฑ์การแพ้ ชนะ ดังต่อไปนี้
ROCK POUNDS OUT FIRE, CRUSHES SCISSORS & SPONGE.
FIRE MELTS SCISSORS, BURNS PAPER & SPONGE.
SCISSORS SWISH THROUGH AIR, CUT PAPER & SPONGE.
SPONGE SOAKS PAPER, USES AIR POCKETS, ABSORBS WATER.
PAPER FANS AIR, COVERS ROCK, FLOATS ON WATER.
AIR BLOWS OUT FIRE, ERODES ROCK, EVAPORATES WATER.
WATER ERODES ROCK, PUTS OUT FIRE, RUSTS SCISSORS.

วิธีทำ
- เพิ่ม Choice ให้ครบ 7 ตัวโดยเรียงลำดับดังนี้ Rock, Fire, Scissors, Sponge, Paper, Air, Water,Start โดยที่ Choice ที่ i จะชนะ 3 Choice ที่ถัดจากตัวมันและแพ้ 3 Choice ก่อนหน้าตัวมัน

## 3.สร้าง function resetGame เพื่อให้ง่ายต่อการเล่นใหม่ไม่ต้อง Deploy ใหม่ทุกครั้ง
