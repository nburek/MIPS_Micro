----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:16:17 08/13/2012 
-- Design Name: 
-- Module Name:    ALU_Control - Behavioral 
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

entity ALU_Control is
    Port ( ALUOp			: in	STD_LOGIC_VECTOR(1 downto 0);
           Instruction	: in	STD_LOGIC_VECTOR(5 downto 0);
           FuncCode		: out	STD_LOGIC_Vector(3 downto 0)
			);
end ALU_Control;

architecture Behavioral of ALU_Control is

begin
	--FuncCode <=	"0010" WHEN (Instruction = "100000" OR ALUOp = "00") ELSE
	--				"0110" WHEN (Instruction = "100010" OR ALUOp = "01") ELSE
	--				"0000" WHEN (Instruction = "100100") ELSE
	--				"0001" WHEN (Instruction = "100101") ELSE
	--				"0111" WHEN (Instruction = "101010") ELSE
	--				"1111";
	
	FuncCode(3) <= '0';
	FuncCode(2) <= (ALUOp(0) OR (ALUOp(1) AND Instruction(1)));
	FuncCode(1) <= ((NOT ALUOp(1)) OR (NOT Instruction(2)));
	FuncCode(0) <= (ALUOp(1) AND (Instruction(3) OR Instruction(0)));

end Behavioral;

