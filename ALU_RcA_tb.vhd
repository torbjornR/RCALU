library ieee;
use ieee.std_logic_1164.all;

entity ALU_RcA_tb is
  generic(width:natural := 32);
end entity ALU_RcA_tb;

architecture RTL of ALU_RcA_tb is
  
  constant Size    : integer := 10000;
  type Operand_array is array (Size downto 0) of std_logic_vector(31 downto 0);
  type OpCode_array is array (Size downto 0) of std_logic_vector(3 downto 0); 
  signal AMem      : Operand_array := (others => (others => '0'));
  signal BMem      : Operand_array := (others => (others => '0'));
  signal OpMem     : OpCode_array := (others => (others => '0'));
  signal OutputMem : Operand_array := (others => (others => '0'));

begin
  testProcess: process
    for

end architecture RTL;
