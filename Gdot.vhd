library ieee;
use ieee.std_logic_1164.all;

entity Gdot is
  port (
        P1  : in  std_logic;
        G1  : in  std_logic;
        G2  : in  std_logic;  --G signal from the previous stage
        G   : out std_logic
  );
end entity Gdot;

architecture RTL of Gdot is
  
begin
  G <= (P1 and G2) or G1;

end architecture RTL;
