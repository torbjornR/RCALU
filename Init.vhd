library ieee;
use ieee.std_logic_1164.all;

entity Init is
  port (
    A  : in  std_logic;
    B : in  std_logic;
    G : out std_logic;
    P : out std_logic
  );
end entity Init;

architecture RTL of Init is
  
begin
  P <= A xor B;
  G <= A and B;

end architecture RTL;
