library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;

entity data_sink is
  port (
    CLK   : in std_logic;
    RST_n : in std_logic;
    VIN   : in std_logic;
    DIN_3K   : in std_logic_vector(6 downto 0);
    DIN_3K_1   : in std_logic_vector(6 downto 0);
    DIN_3K_2   : in std_logic_vector(6 downto 0));
end data_sink;

architecture beh of data_sink is

begin  -- beh

  process (CLK, RST_n)
    file res_fp : text open WRITE_MODE is "./results.txt";
    variable line_out_3K : line;
    variable line_out_3K_1 : line;
    variable line_out_3K_2 : line;    
  begin  -- process
    if RST_n = '0' then                 -- asynchronous reset (active low)
      null;
    elsif CLK'event and CLK = '1' then  -- rising clock edge
      if (VIN = '1') then
        write(line_out_3K, conv_integer(signed(DIN_3K)));
        write(line_out_3K_1, conv_integer(signed(DIN_3K_1)));
        write(line_out_3K_2, conv_integer(signed(DIN_3K_2)));
        writeline(res_fp, line_out_3K);
        writeline(res_fp, line_out_3K_1);
        writeline(res_fp, line_out_3K_2);
      end if;
    end if;
  end process;

end beh;
