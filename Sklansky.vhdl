library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.MATH_REAL.ALL;

entity sklansky is
   generic(width:integer := 32);
   port(
	OpA	    : in	std_logic_vector(width-1 downto 0);
	OpB	    : in	std_logic_vector(width-1 downto 0);
	Cin	    : in	std_logic;
	Cout	  : out	std_logic;
  Vout    : out std_logic;                                  -- ???
	Result	: out	std_logic_vector(width-1 downto 0));
end;

architecture RTL of sklansky is
  
       component InitCarry
	   port(
		A	: in	std_logic;
		B	: in	std_logic;
		C	: in	std_logic;
		G	: out	std_logic;
		P	: out	std_logic);
	end component;

	component Init
	   port(
		A	: in	std_logic;
		B	: in	std_logic;
		G	: out	std_logic;
		P	: out	std_logic);
	end component;
 
	component DOTs          --the dot operater
	   port(
		P1	: in	std_logic;
		G1	: in	std_logic;
		P2	: in	std_logic;  --P signal from the previous stage
		G2	: in	std_logic;  --G signal from the previous stage
		P	: out	std_logic;
		G	: out	std_logic);
	end component;

	component Gdot          --the Gray dot operator 
	   port(
		P1	: in	std_logic;
		G1	: in	std_logic;
		G2	: in	std_logic;  --G signal from the previous stage
		G	: out	std_logic);
	end component;

	component E             --
	   port(
		G	: in	std_logic;
		X	: in	std_logic;
		SUM	: out	std_logic);
	end component;

       constant depth : integer := INTEGER(CEIL(LOG2(REAL(width))));
      
       subtype int_signal is std_logic_vector(width-1 downto 0);
       type int_signal_vector is array (depth downto 0) of int_signal;

       signal P: int_signal_vector;
       signal G: int_signal_vector;

       
begin  -- RTL

  --full adder, initial Cin signal comes from the input port
  unit0 : InitCarry port map (
    A => OpA(0),
    B => OpB(0),
    C => Cin,
    G => G(0)(0),
    P => P(0)(0));
  
  --half adders, generate the initial P and G signals
  Initial_row: for i in 1 to width-1 generate
    uinit: Init port map (
      A=>OpA(i),
      B=>OpB(i),
      G=>G(0)(i),
      P=>P(0)(i));
  end generate Initial_row;
   
  --intermediate rows (between half adder and the final XORs)
  row: for i in 1 to depth generate
    column: for j in 0 to width-1 generate
      --if a component is needed put it, else forward the P and G signals
      
      a: if ((INTEGER(FLOOR(REAL(j)/REAL(2**(i-1))))) mod 2) = 1 generate
        -- Simpler dot operators can be used in these locations
        -- It is referred as Grey Cells in CMOS VLSI Design book
        b: if j < 2**(i) generate
          Gdotops: Gdot port map (
            P1=>P(i-1)(j),
            G1=>G(i-1)(j),
            G2=>G(i)(j),--!find the correct description!,
            G=>G(i)(j));
          --P does not need to be propagated, simpler dot operator (grey cell)
          --is always the last dot operator
        end generate b;

        --use regular dot cells referred as "Black cell" in CMOS VLSI Design book 
        --("else" can not be used in this context, use inverted condition)
        c: if j >= 2**(i) generate
          Dotops: DOTs port map(
            P1=>P(i-1)(j),
            G1=>G(i-1)(j),
            P2=>P(i)(j),--!find the correct description!,
            G2=>G(i)(j),--!find the correct description!,
            P=>P(i)(j),
            G=>G(i)(j));       
        end generate c;
      end generate a;
 
      --No operator, propagate the P and G signals to the next stage
      --("else" can not be used in this context use the inverted condition)
      d: if ((INTEGER(FLOOR(REAL(j)/REAL(2**(i-1))))) mod 2) /= 1 generate
        P(i)(j) <= P(i-1)(j);
        G(i)(j) <= G(i-1)(j);
      end generate d;
    end generate column;
  end generate row;

  --final result
  Result(0) <= P(0)(0);
  Final_row: for i in 1 to width-1 generate
    uE : E port map (
      G => G(depth)(i-1),
      X => P(0)(i),
      SUM => Result(i));
  end generate Final_row;


  Cout <= std_logic(G(depth));  --!find the correct description!;
  Vout <=  '0';                     --!find the coorect description!;
  
end RTL;
