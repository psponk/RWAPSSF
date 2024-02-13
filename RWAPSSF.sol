// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;
import "./CommitReveal.sol";

contract RPS is CommitReveal {
    struct Player {
        uint choice; // 0 - Rock, 1 - Fire, 2 - Scissors, 3 - Sponge, 4 - Paper, 5 - Air, 6 - Water, 7 - Start
        address payable addr;
        uint timestamp; // เวลาที่ผู้เล่นลงทะเบียนเข้าร่วมเกม
        bool input;
    }
    uint public numPlayer = 0;
    uint public reward = 0;
    mapping (uint => Player) public player;
    uint public numInput = 0;
    uint public refundTime = 1 days; // เวลาลิมิตที่ใช้กำหนดเวลาในการเล่นถ้าเกินกว่านี้จะลงโทษหรือคืนเงิน

    function addPlayer() public payable {
        require(numPlayer < 2);
        require(msg.value == 1 ether);
        reward += msg.value;
        player[numPlayer].addr = payable(msg.sender);
        player[numPlayer].choice = 7; // กำหนดให้เริ่มต้นที่เลือก 7 สำหรับการเริ่มเกม
        player[numPlayer].timestamp = block.timestamp;
        numPlayer++;
    }

    function input(uint choice, uint idx) public  {
        require(numPlayer == 2);
        require(msg.sender == player[idx].addr);
        require(choice >= 0 && choice <= 6); // ตรวจสอบว่าค่า choice อยู่ใน range ที่ถูกต้อง
        player[idx].choice = choice;
        numInput++;
        if (numInput == 2) {
            _checkWinnerAndPay();
            resetGame(); // เรียกใช้ฟังก์ชัน reset เมื่อเกมจบ
        }
    }

    function _checkWinnerAndPay() private {
        uint p0Choice = player[0].choice;
        uint p1Choice = player[1].choice;
        address payable account0 = payable(player[0].addr);
        address payable account1 = payable(player[1].addr);
        if ( (p0Choice + 1) % 7 == p1Choice || (p0Choice + 2) % 7 == p1Choice || (p0Choice + 3) % 7 == p1Choice ) {
            // to pay player[0]
            account0.transfer(reward);
        }
        else if ( (p1Choice + 1) % 7 == p0Choice || (p1Choice + 2) % 7 == p0Choice || (p1Choice + 3) % 7 == p0Choice ) {
            // to pay player[1]
            account1.transfer(reward);    
        }
        else {
            // to split reward
            account0.transfer(reward / 2);
            account1.transfer(reward / 2);
        }
        resetGame();
    }

    // ฟังก์ชันสำหรับคืนเงินหลังจากผ่านไประยะเวลาที่กำหนดหลังจากที่ผู้เล่นลงทะเบียนเข้าร่วมเกม
    function refund() public {
        require(numPlayer == 2 && numInput < 2);
        require(block.timestamp >= player[0].timestamp + refundTime && block.timestamp >= player[1].timestamp + refundTime);
        address payable account0 = player[0].addr;
        address payable account1 = player[1].addr;
        account0.transfer(reward);
        account1.transfer(reward);
        resetGame(); // เรียกใช้ฟังก์ชัน reset เมื่อเกมจบ
    }

    // ฟังก์ชันสำหรับรีเซ็ตเกม
    function resetGame() private {
        numPlayer = 0;
        reward = 0;
        numInput = 0;
    }
}
