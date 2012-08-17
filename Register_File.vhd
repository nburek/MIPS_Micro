----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:37:48 08/14/2012 
-- Design Name: 
-- Module Name:    Register_File - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Register_File is
    Port ( 	clk				:	in	STD_LOGIC;
				RegWrite			:	in	STD_LOGIC;
				WriteRegAdd		:	in	STD_LOGIC_VECTOR(4 downto 0);
				WriteRegData	:	in	STD_LOGIC_VECTOR(31 downto 0);
				ReadReg1Add		:	in STD_LOGIC_VECTOR(4 downto 0);
				ReadReg2Add		:	in	STD_LOGIC_VECTOR(4 downto 0);
				ReadData1		:	out STD_LOGIC_VECTOR(31 downto 0);
				ReadData2		:	out STD_LOGIC_VECTOR(31 downto 0)
				);
end Register_File;

architecture Behavioral of Register_File is
	type reg is array(31 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
	signal registers : reg := ("00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000",
										"00000000000000000001100000000000",
										"00000000000000000011111111111100",
										"00000000000000000000000000000000",
										"00000000000000000000000000000000"
										);
	
begin
	ReadData1 <= "00000000000000000000000000000000" WHEN ReadReg1Add="00000" ELSE registers(CONV_INTEGER(ReadReg1Add));
	ReadData2 <= "00000000000000000000000000000000" WHEN ReadReg2Add="00000" ELSE registers(CONV_INTEGER(ReadReg2Add));
	
	process (clk)
	begin
		IF (clk'EVENT AND clk='1') THEN
			IF (RegWrite = '1') THEN
				registers(CONV_INTEGER(WriteRegAdd)) <= WriteRegData;
			END IF;
		END IF;
	end process;
end Behavioral;

