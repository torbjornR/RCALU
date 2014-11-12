library ieee;
use ieee.std_logic_1164.all;

entity E is
  port (
    G : in  std_logic;
    X : in  std_logic;
    SUM : out std_logic
  );
end entity E;

architecture RTL of E is
  
begin
  SUM <= G xor X;

end architecture RTL;
