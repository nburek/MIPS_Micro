----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:46:14 08/14/2012 
-- Design Name: 
-- Module Name:    Memory_Controller - Behavioral 
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

entity Memory_Controller is
    Port ( clk 					: in  STD_LOGIC;
           instructionAddress : in  STD_LOGIC_VECTOR(31 downto 0);
           instruction 			: out STD_LOGIC_VECTOR(31 downto 0);
           dataAddress 			: in	STD_LOGIC_VECTOR(31 downto 0);
           dataOut 				: out STD_LOGIC_VECTOR(31 downto 0);
           dataIn 				: in  STD_LOGIC_VECTOR(31 downto 0);
           memWrite 				: in  STD_LOGIC;
           memRead 				: in  STD_LOGIC;
			  LEDs					: out STD_LOGIC_VECTOR(7 downto 0);
			  switches				: in	STD_LOGIC_VECTOR(7 downto 0);
			  buttons				: in	STD_LOGIC_VECTOR(4 downto 0)
			);
end Memory_Controller;

architecture Behavioral of Memory_Controller is
	signal writeEnable : STD_LOGIC_VECTOR(0 downto 0);
	signal invertedClock : STD_LOGIC;
	signal dOut : STD_LOGIC_VECTOR(31 downto 0);
	
	component Memory
	  PORT (
		 clka : IN STD_LOGIC;
		 wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		 addra : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
		 dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 clkb : IN STD_LOGIC;
		 web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		 addrb : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
		 dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	  );
	END component;

begin
	writeEnable(0) <= memWrite;
	invertedClock <= NOT clk;
	
	dataOut <= 	("000000000000000000000000" & switches) WHEN dataAddress(14 downto 0) = "111111100000100" ELSE
					("000000000000000000000000000" & buttons) WHEN dataAddress(14 downto 0) = "111111100001000" ELSE
					dOut;
	
	mem : Memory
		port map (	clka => clk,
						wea => "0",
						addra => instructionAddress(14 downto 2),
						dina => "00000000000000000000000000000000",
						douta => instruction,
						clkb => invertedClock,
						web => writeEnable,
						addrb => dataAddress(14 downto 2),
						dinb => dataIn,
						doutb => dOut
					);

	process (clk)
	begin
		IF (clk'EVENT AND clk='1') THEN
			-- if you're writting out to the memory mapped I/O LED lights at 0x7F00
			IF ( memWrite='1' AND dataAddress(14 downto 0) = "111111100000000") THEN
				LEDs <= dataIn(7 downto 0);
			END IF;
		END IF;
	end process;

end Behavioral;

