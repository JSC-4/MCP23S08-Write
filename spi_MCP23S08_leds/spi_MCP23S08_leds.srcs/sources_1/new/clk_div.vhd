library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_div is
    generic ( 
        g_fin  : integer := 100e6;
        g_fout : integer := 10e6);
    port ( 
        i_clk : in STD_LOGIC;
        i_reset : in STD_LOGIC;
        o_clk : out STD_LOGIC);
end clk_div;

architecture rtl of clk_div is
    signal r_tmp : std_logic := '0';
    signal r_counter : integer range 0 to (g_fin / g_fout) / 2 := 0;
begin

    freq_div : process (i_clk, i_reset)
    begin
        if (i_reset = '1') then
            r_tmp <= '0';
            r_counter <= 0;
        elsif (rising_edge(i_clk)) then
            if (r_counter = 0) then
                r_tmp <= not r_tmp;
                r_counter <= 0;
            else
                r_counter <= r_counter + 1;
            end if;
        end if;
    end process;

    o_clk <= r_tmp;

end rtl;
