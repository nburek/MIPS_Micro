--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:33:33 08/16/2012
-- Design Name:   
-- Module Name:   C:/workspace/MIPS_Micro/testBench.vhd
-- Project Name:  MIPS_Micro
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY testBench IS
END testBench;
 
ARCHITECTURE behavior OF testBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top
    PORT(
         clk100MHz : IN  std_logic;
         rst : IN  std_logic;
         led : OUT  std_logic_vector(7 downto 0);
			sw	 : in	STD_LOGIC_VECTOR(7 downto 0);
			btn : in	STD_LOGIC_VECTOR(4 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk100MHz : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal led : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top PORT MAP (
          clk100MHz => clk100MHz,
          rst => rst,
          led => led,
			 sw => "00000010",
			 btn => "00010"
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk100MHz <= '0';
		wait for clk_period/2;
		clk100MHz <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
