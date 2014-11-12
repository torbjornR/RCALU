library ieee;
use ieee.std_logic_1164.all;

entity DOTs is
  port (
    P1  : in  std_logic;
    G1  : in  std_logic;
    P2  : in  std_logic;  --P signal from the previous stage
    G2  : in  std_logic;  --G signal from the previous stage
    P : out std_logic;
    G : out std_logic
    );
end entity DOTs;

architecture RTL of DOTs is
  
begin
  P <= P1 and P2;
  G <= (P1 and G2) or G1;
end architecture RTL;
