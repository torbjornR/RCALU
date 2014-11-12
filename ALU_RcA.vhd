library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ALU_RcA is
  generic (width: integer := 8);
  port (
    Clk : in std_logic;
    Reset : in std_logic;
    A : in std_logic_vector(width-1 downto 0);
    B : in std_logic_vector(width-1 downto 0);
    Op: in std_logic_vector(3 downto 0) ;
    Outs: out std_logic_vector(width-1 downto 0) 
  );
end entity ALU_RcA;

architecture RTL of ALU_RcA is
  signal AMem : std_logic_vector(width-1 downto 0);
  signal BMem : std_logic_vector(width-1 downto 0);
  signal OpMem : std_logic_vector(3 downto 0);
  signal ShiftWalue : integer;
  signal Cflag : std_logic;
  signal sum0000 : std_logic_vector(width-1 downto 0);
  signal sum0001 : std_logic_vector(width-1 downto 0);
  signal sum0010 : std_logic_vector(width-1 downto 0);
  signal sum0011 : std_logic_vector(width-1 downto 0);
  signal trach : STD_LOGIC;
  signal temp_cflag:std_logic;
 
begin
temp_cflag<=not(cflag);
LoadRegisters: process (clk,Reset)
begin
  if Reset = '1'then
    AMem  <= (others => '0');
    BMem  <= (others => '0');
    OpMem <= (others => '0');
  elsif rising_edge(Clk) then
    AMem <= A;
    BMem <= B;
    OpMem <= Op;
  end if;
end process LoadRegisters;


cortroller: process(OpMem, AMem, BMem, ShiftWalue, sum0000, sum0001, sum0010, sum0011)
  begin
   ShiftWalue <= to_integer(unsigned(BMem(2 downto 0)));
  case OpMem is
    when "0000" => 
      Outs <= sum0000;    
    when "0001" => 
      Outs <= sum0001;
    when "0010" => 
      Outs <= sum0010;
    when "0011" => 
      Outs <= sum0011;
    when "0100" => 
      Outs <= AMem and BMem;   
    when "0101" => 
      Outs <= AMem or BMem;   
    when "0110" => 
      Outs <= AMem nor BMem; 
    when "0111" =>
      Outs <= AMem xor BMem; 
    when "1000" => 
      Outs <= std_logic_vector(shift_left((signed(Amem)) , ShiftWalue));
    when "1010" => 
      Outs <= std_logic_vector(shift_right((signed(Amem)) , ShiftWalue));
    when "1011" =>  
      Outs <= AMem(width-1) & std_logic_vector(shift_right((signed(Amem(width-1 downto 1))) , ShiftWalue));
 	when others =>
	null;
 end case;
end process cortroller;  
    
  
adder0000: entity work.RippleCarry      --ADD
  generic map(width => width)
  port map(a        => A,
           b        => B,
           saturate => '0',
           add_sub  => '1',
           Cout => trach,
           y        => sum0000
           );
           
adder0001: entity work.RippleCarry      --ADDS
  generic map(width => width)
  port map(a        => A,
           b        => B,
           saturate => '0',
           add_sub  => '1',
           Cout => Cflag,
           y        => sum0001
           );  
           
adder0010: entity work.RippleCarry     --ADDC
  generic map(width => width)
  port map(a        => A,
           b        => B,
           saturate => '0',
           add_sub  => temp_cflag,
           Cout => trach,
           y        => sum0010
           );  
           
adder0011: entity work.RippleCarry     -- sub
  generic map(width => width)
  port map(a        => A,
           b        => B,
           saturate => '0',
           add_sub  => '0',
           Cout => trach,
           y        => sum0011
           );       
               
end architecture RTL;