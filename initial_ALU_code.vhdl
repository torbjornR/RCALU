  -----------------------------------------------------------------------------
  use std.textio.all; --this library is needed for textio functions

  -----------------------------------------------------------------------------
  -- Declarations
  -----------------------------------------------------------------------------

  constant Size    : integer := 10000;
  type Operand_array is array (Size downto 0) of std_logic_vector(31 downto 0);
  type OpCode_array is array (Size downto 0) of std_logic_vector(3 downto 0);

  -----------------------------------------------------------------------------
  -- Functions
  -----------------------------------------------------------------------------

  function bin (
    myChar : character)
    return std_logic is
    variable bin : std_logic;
  begin
    case myChar is
      when '0' => bin := '0';
      when '1' => bin := '1';
      when 'x' => bin := '0';
      when others => assert (false) report "no binary character read" severity failure;
    end case;
    return bin;
  end bin;

  function loadOperand (
    fileName : string)
    return Operand_array is
    file objectFile : text open read_mode is fileName;
    variable memory : Operand_array;
    variable L      : line;
    variable index  : natural := 0;
    variable myChar : character;
  begin
    while not endfile(objectFile) loop
      readline(objectFile, L);
      for i in 31 downto 0 loop
        read(L, myChar);
        memory(index)(i) := bin(myChar);
      end loop;
      index := index + 1;
    end loop;
    return memory;
  end loadOperand;


  function loadOpCode (
    fileName : string)
    return OpCode_array is
    file objectFile : text open read_mode is fileName;
    variable memory : OpCode_array;
    variable L      : line;
    variable index  : natural := 0;
    variable myChar : character;
  begin
    while not endfile(objectFile) loop
      readline(objectFile, L);
      for i in 3 downto 0 loop
        read(L, myChar);
        memory(index)(i) := bin(myChar);
      end loop;
      index := index + 1;
    end loop;
    return memory;
  end loadOpCode;
