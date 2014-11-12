library ieee;
use ieee.std_logic_1164.all;

entity InitCarry is
  port (
      A : in  std_logic;
      B : in  std_logic;
      C : in  std_logic;
      G : out std_logic;
      P : out std_logic
  );
end entity InitCarry;

architecture RTL of InitCarry is
  signal B2 : std_logic;
  signal A2 : std_logic;
  
begin
  A2 <= A and B;
  B2 <= A xor B;
  P <= B2 and C;
  G <= A2 or (B2 and C);

end architecture RTL;
