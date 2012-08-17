----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:17:14 08/14/2012 
-- Design Name: 
-- Module Name:    Mux - Behavioral 
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

entity Mux is
    Port ( DataIn0 	: in  STD_LOGIC_VECTOR(31 downto 0);
           DataIn1 	: in  STD_LOGIC_VECTOR(31 downto 0);
           Selector 	: in	STD_LOGIC;
           DataOut 	: out STD_LOGIC_VECTOR(31 downto 0));
end Mux;

architecture Behavioral of Mux is

begin
	DataOut <= DataIn0 WHEN Selector='0' ELSE DataIn1;

end Behavioral;

