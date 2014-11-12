LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

--entity fulladder is
	--Port (   a    : in  STD_LOGIC;       -- this is input a 
	--		     b    : in  STD_LOGIC;       -- this is input b 
	--		     cin  : in  STD_LOGIC;       -- this is the carry in 
	--		     cout : out STD_LOGIC;       -- this is the carry ouut
  --         s    : out STD_LOGIC);       -- this is the sum
--end fulladder;

--architecture structured of fulladder is 

--begin 
  --s     <= a xor b xor cin;
  --cout  <= (a and b) or (a and cin) or (b and cin);
--end structured;




entity fulladder is
	Port (   a    : in  STD_LOGIC;       -- this is input a 
			     b    : in  STD_LOGIC;       -- this is input b 
			     cin  : in  STD_LOGIC;       -- this is the carry in 
			     AoS  : in  STD_LOGIC;       -- sub and non sub trigger
			     cout : out STD_LOGIC;       -- this is the carry ouut
           s    : out STD_LOGIC);      -- this is the sum
end fulladder;

architecture structured of fulladder is 

signal bshadow : std_logic;

begin 
  bshadow <= not(AoS) xor b;  -- This inverts the b bitt iff we hawe an 0 in on a/s.
  s     <= a xor bshadow xor cin;
  cout  <= (a and bshadow) or (a and cin) or (bshadow and cin);
end structured;

