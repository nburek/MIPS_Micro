----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:15:24 08/13/2012 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( DataIn1			: in  STD_LOGIC_VECTOR(31 downto 0);
           DataIn2			: in  STD_LOGIC_VECTOR(31 downto 0);
           FuncCode			: in  STD_LOGIC_VECTOR(3 downto 0);
           Zero				: out	STD_LOGIC;
           DataOut	 		: out STD_LOGIC_VECTOR(31 downto 0)
			);
end ALU;

architecture Behavioral of ALU is
	signal DataOutBuffer : STD_LOGIC_VECTOR(31 downto 0);
begin
	DataOut <= DataOutBuffer;
	DataOutBuffer <= 	(DataIn1 AND DataIn2) WHEN FuncCode = "0000" ELSE
					(DataIn1 OR DataIn2) WHEN FuncCode = "0001" ELSE
					std_logic_vector(signed(DataIn1) + signed(DataIn2)) WHEN FuncCode = "0010" ELSE
					std_logic_vector(signed(DataIn1) - signed(DataIn2)) WHEN FuncCode = "0110" ELSE
					("00000000000000000000000000000001") WHEN (DataIn1 < DataIn2 AND FuncCode = "0111") ELSE 
					(NOT (DataIn1 OR DataIn2)) WHEN FuncCode = "1010" ELSE
					("00000000000000000000000000000000");
	Zero <= '1' WHEN DataOutBuffer = "00000000000000000000000000000000" ELSE '0';

end Behavioral;

