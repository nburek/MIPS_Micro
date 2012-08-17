----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:12:35 08/13/2012 
-- Design Name: 
-- Module Name:    Control - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Control is
    Port ( Instruction : in  STD_LOGIC_VECTOR(31 downto 26);
           RegDst : out  STD_LOGIC;
           Jump : out  STD_LOGIC;
           Branch : out  STD_LOGIC;
           MemRead : out  STD_LOGIC;
           MemtoReg : out  STD_LOGIC;
           ALUOp : out  STD_LOGIC_VECTOR(1 downto 0);
           MemWrite : out  STD_LOGIC;
           ALUSrc : out  STD_LOGIC;
           RegWrite : out  STD_LOGIC);
end Control;

architecture Behavioral of Control is
	signal isRFormat : STD_LOGIC;
	signal isLW : STD_LOGIC;
	signal isSW : STD_LOGIC;
	signal isBEQ : STD_LOGIC;
	signal isJump : STD_LOGIC;
	signal isAddi : STD_LOGIC;
	
begin
	--Uses a PLA design to determine the outputs
	
	isRFormat <= (	(NOT Instruction(31)) AND 
						(NOT Instruction(30)) AND 
						(NOT Instruction(29)) AND 
						(NOT Instruction(28)) AND 
						(NOT Instruction(27)) AND 
						(NOT Instruction(26))
					);
	isLW <= (		(Instruction(31)) AND 
						(NOT Instruction(30)) AND 
						(NOT Instruction(29)) AND 
						(NOT Instruction(28)) AND 
						(Instruction(27)) AND 
						(Instruction(26))
					);
	isSW <= (		(Instruction(31)) AND 
						(NOT Instruction(30)) AND 
						(Instruction(29)) AND 
						(NOT Instruction(28)) AND 
						(Instruction(27)) AND 
						(Instruction(26))
					);
	isBEQ <= (		(NOT Instruction(31)) AND 
						(NOT Instruction(30)) AND 
						(NOT Instruction(29)) AND 
						(Instruction(28)) AND 
						(NOT Instruction(27)) AND 
						(NOT Instruction(26))
					);
	isJump <= (		(NOT Instruction(31)) AND 
						(NOT Instruction(30)) AND 
						(NOT Instruction(29)) AND 
						(NOT Instruction(28)) AND 
						(Instruction(27)) AND 
						(NOT Instruction(26))
					);
	isAddi <= (		(NOT Instruction(31)) AND 
						(NOT Instruction(30)) AND 
						(Instruction(29)) AND 
						(NOT Instruction(28)) AND 
						(NOT Instruction(27)) AND 
						(NOT Instruction(26))
					);
	
	RegDst <= isRFormat;
	Jump <= isJump;
	ALUSrc <= (isLW OR isSW OR isAddi);
	MemtoReg <= isLW;
	RegWrite <= (isRFormat OR isLW OR isAddi);
	MemRead <= isLW;
	MemWrite <= isSW;
	Branch <= isBEQ;
	ALUOp(1) <= isRFormat;
	ALUOp(0) <= isBEQ;

end Behavioral;

