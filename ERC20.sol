// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

interface IERC20 {
    // 标准的接口
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function totalSupply() external view returns (uint256); // 函数修饰符在函数后进行修饰

    function balanceOf(address account) external view returns (uint256); // view就是只能看，不能更改状态

    function transfer(address to, uint256 amount) external returns (bool); // external就是外部(合约外或者继承的合约)可以访问，当前合约不能访问

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

contract ERC20 is
    IERC20 // is可以继承合约或接口
{
    mapping(address => uint256) public override balanceOf; // 子合约重写了父合约中的函数，需要加上override关键字在后作为修饰

    mapping(address => mapping(address => uint256)) public override allowance; // mapping本身也可以视为函数

    uint256 public override totalSupply; // 代币总供给量

    string public name; // 名称
    string public symbol; // 符号

    uint8 public decimals = 18; // 小数位数

    constructor(string memory name_, string memory symbol_) {
        name = name_;
        symbol = symbol_;
    }

    function transfer(
        address to,
        uint amount
    ) external override returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(
        address spender,
        uint amount
    ) external override returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address to,
        uint amount
    ) external override returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(sender, to, amount);
        return true;
    }

    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}
