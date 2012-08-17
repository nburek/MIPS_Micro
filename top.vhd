----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:38:23 08/13/2012 
-- Design Name: 
-- Module Name:    top - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    Port ( 	clk100MHz 	: in	STD_LOGIC;
				rst 			: in	STD_LOGIC;
				led 			: out	STD_LOGIC_VECTOR(7 downto 0);
				sw				: in	STD_LOGIC_VECTOR(7 downto 0);
				btn			: in	STD_LOGIC_VECTOR(4 downto 0)
			);
end top;

architecture Behavioral of top is
	
	signal clk : STD_LOGIC := '0'; 

	signal PC : STD_LOGIC_VECTOR(31 downto 0) := "11111111111111111111111111111100";
	
	--signals from the ALU control unit
	signal funcCode : STD_LOGIC_VECTOR(3 downto 0);
	
	--signals from the control unit
	signal regDst : STD_LOGIC;
	signal jump : STD_LOGIC;
	signal branch : STD_LOGIC;
	signal memRead : STD_LOGIC;
	signal memToReg : STD_LOGIC;
	signal aluOp : STD_LOGIC_VECTOR(1 downto 0);
	signal memWrite : STD_LOGIC;
	signal aluSrc : STD_LOGIC;
	signal regWrite : STD_LOGIC;
	
	--signals from the register file unit
	signal regData0 : STD_LOGIC_VECTOR(31 downto 0);
	signal regData1 : STD_LOGIC_VECTOR(31 downto 0);
	
	--signals from the ALU unit
	signal zero : STD_LOGIC;
	signal aluResult : STD_LOGIC_VECTOR(31 downto 0);
	
	--signals from the memory unit
	signal currentInstruction : STD_LOGIC_VECTOR(31 downto 0);
	signal memoryReadData : STD_LOGIC_VECTOR(31 downto 0);
	
	--mux signal outs
	signal writeRegMuxDataOut : STD_LOGIC_VECTOR(31 downto 0);
	signal writeDataMuxDataOut : STD_LOGIC_VECTOR(31 downto 0);
	signal aluDataMuxDataOut : STD_LOGIC_VECTOR(31 downto 0);
	signal pcBranchMuxDataOut : STD_LOGIC_VECTOR(31 downto 0);
	signal pcJumpMuxDataOut : STD_LOGIC_VECTOR(31 downto 0);
	
	
	--other signal lines
	signal signExtendedLowerInstruction : STD_LOGIC_VECTOR(31 downto 0);
	signal pcPlusFour : STD_LOGIC_VECTOR(31 downto 0);
	signal jumpAddress : STD_LOGIC_VECTOR(31 downto 0);
	
	component Mux
	 Port ( DataIn0 	: in  STD_LOGIC_VECTOR(31 downto 0);
           DataIn1 	: in  STD_LOGIC_VECTOR(31 downto 0);
           Selector 	: in	STD_LOGIC;
           DataOut 	: out STD_LOGIC_VECTOR(31 downto 0)
			);
	end component;

	component ALU
    Port ( DataIn1			: in  STD_LOGIC_VECTOR(31 downto 0);
           DataIn2			: in  STD_LOGIC_VECTOR(31 downto 0);
           FuncCode			: in  STD_LOGIC_VECTOR(3 downto 0);
           Zero				: out	STD_LOGIC;
           DataOut	 		: out STD_LOGIC_VECTOR(31 downto 0)
			);
	end component;
	
	component ALU_Control
    Port ( ALUOp			: in	STD_LOGIC_VECTOR(1 downto 0);
           Instruction	: in	STD_LOGIC_VECTOR(5 downto 0);
           FuncCode		: out	STD_LOGIC_Vector(3 downto 0)
			);
	end component;
	
	component Memory_Controller
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
	end component;
	
	component Register_File
    Port ( 	clk				:	in	STD_LOGIC;
				RegWrite			:	in	STD_LOGIC;
				WriteRegAdd		:	in	STD_LOGIC_VECTOR(4 downto 0);
				WriteRegData	:	in	STD_LOGIC_VECTOR(31 downto 0);
				ReadReg1Add		:	in STD_LOGIC_VECTOR(4 downto 0);
				ReadReg2Add		:	in	STD_LOGIC_VECTOR(4 downto 0);
				ReadData1		:	out STD_LOGIC_VECTOR(31 downto 0);
				ReadData2		:	out STD_LOGIC_VECTOR(31 downto 0)
			);
	end component;
	
	component Control
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
	end component;

begin

	signExtendedLowerInstruction(15 downto 0) <= currentInstruction(15 downto 0);
	signExtendedLowerInstruction(31 downto 16) <= (others => currentInstruction(15)); --sign extend the lower 16 bits of the instruction
	pcPlusFour <= PC + "00000000000000000000000000000100";
	jumpAddress <= pcPlusFour(31 downto 28) & currentInstruction(25 downto 0) & "00";
	
	aluDataMux : Mux
		port map (	DataIn0 => regData1,
						DataIn1 => signExtendedLowerInstruction,
						Selector => aluSrc,
						DataOut => aluDataMuxDataOut
					);
					
	aluUnit : ALU
		port map (	DataIn1 => regData0,
						DataIn2 => aluDataMuxDataOut,
						FuncCode => funcCode,
						Zero => zero,
						DataOut => aluResult
					);
					
	aluControl : ALU_Control
		port map (	ALUOp => aluOp,
						Instruction => currentInstruction(5 downto 0),
						FuncCode => funcCode
					);
	
	writeDataMux : Mux
		port map (	DataIn0 => aluResult,
						DataIn1 => memoryReadData,
						Selector => memToReg,
						DataOut => writeDataMuxDataOut
					);
	
	memory : Memory_Controller
		port map (	clk => clk,
						instructionAddress => PC,
						instruction => currentInstruction,
						dataAddress => aluResult,
						dataOut => memoryReadData,
						dataIn => regData1,
						memWrite => memWrite,
						memRead => memRead,
						LEDs => led,
						switches => sw,
						buttons => btn
					);
	
	controller : Control
		port map (	Instruction => currentInstruction(31 downto 26),
						RegDst => regDst,
						Jump => jump,
						Branch => branch,
						MemRead => memRead,
						MemtoReg => memToReg,
						ALUOp => aluOp,
						MemWrite => memWrite,
						ALUSrc => aluSrc,
						RegWrite => regWrite
					);
	
	writeRegMux : Mux
		port map (	DataIn0 => "000000000000000000000000000" & currentInstruction(20 downto 16),
						DataIn1 => "000000000000000000000000000" & currentInstruction(15 downto 11),
						Selector => regDst,
						DataOut => writeRegMuxDataOut
					);
	
	registers : Register_File
		port map (	clk => clk,
						RegWrite => regWrite,
						WriteRegAdd => writeRegMuxDataOut(4 downto 0),
						WriteRegData => writeDataMuxDataOut,
						ReadReg1Add	=> currentInstruction(25 downto 21),
						ReadReg2Add	=> currentInstruction(20 downto 16),
						ReadData1 => regData0,
						ReadData2 => regData1
					);
						
	pcBranchMux : Mux
		port map (	DataIn0 => pcPlusFour,
						DataIn1 => (pcPlusFour + (signExtendedLowerInstruction(29 downto 0) & "00")),
						Selector => (branch and zero),
						DataOut => pcBranchMuxDataOut
					);
	
	pcJumpMux : Mux
		port map (	DataIn0 => pcBranchMuxDataOut,
						DataIn1 => jumpAddress,
						Selector => jump,
						DataOut => pcJumpMuxDataOut
					);
	
	--update the PC every clock tick
	process (clk)
	begin
		IF (clk'EVENT and clk='0') THEN
			PC <= pcJumpMuxDataOut;
		END IF;
	end process;
	
	process (clk100MHz)
	begin
		IF(clk100MHz'EVENT and clk100MHz='1') THEN
			clk <= NOT clk;
		END IF;
	end process;
end Behavioral;

