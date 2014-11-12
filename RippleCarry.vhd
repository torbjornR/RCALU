LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;

entity RippleCarry is
  
  Generic (width: integer := 8);
	Port (   a        : in  STD_LOGIC_VECTOR(width-1 downto 0);        -- this is vector a nBit 
			     b        : in  STD_LOGIC_VECTOR(width-1 downto 0);        -- this is vector b nBit
			     saturate : in  STD_LOGIC;                                 -- this is the saturate inpot
			     add_sub  : in  STD_LOGIC;                                 -- adder sub funktion
			     Cout     : out STD_LOGIC;                                 -- this is the carry ouut
           y        : out STD_LOGIC_VECTOR(width-1 downto 0));       -- this is the sum vector nBit
end RippleCarry;

architecture  structured of RippleCarry is
--------------------- components --------------------------------
  component FullAdder is 
    	Port (  a    : in  STD_LOGIC;       -- this is input a 
			        b    : in  STD_LOGIC;       -- this is input b 
			        cin  : in  STD_LOGIC;       -- this is the carry in 
			        AoS  : in  STD_LOGIC;       -- sub and non sub trigger
			        cout : out STD_LOGIC;       -- this is the carry ouut
              s    : out STD_LOGIC);      -- this is the sum
end component;
----------------- Signal dedications --------------------------
signal cint     : std_logic_vector(width-1 downto 0);
signal highlow  : std_logic_vector(2 downto 0);
signal sum      : std_logic_vector(width-1 downto 0);
signal sub      : std_logic;


begin

  sub <= not(add_sub);
   Cout <= cint(width-1); -- modified to be used as an Cout
   
   highlow <= saturate & cint(width-1 downto width-2);
   
 
--   
--   with highlow select
--    y <=  ('1' & (width-2 downto 0 => '0')) when "110",
--          ('0' & (width-2 downto 0 => '1')) when "101",
--          sum when others;
y<=sum;


G1: for i in 0 to width-1 generate
  
  LowBit: if i=0 generate
  bit0 : component FullAdder port map
        (a    => a(0),
         b    => b(0),
         cin  => sub,
         AoS  => add_sub,
         cout => cint(0),
         s => sum(0)
         );  
end generate LowBit;

 highBit: if i>0 generate
  midBit: component FullAdder port map
        (a => a(i),
         b => b(i),
         cin => cint(i-1),
         AoS => add_sub,
         cout => cint(i),
         s => sum(i)
       );
     end generate highBit;
     end generate G1;
     

       
                      
end structured;  