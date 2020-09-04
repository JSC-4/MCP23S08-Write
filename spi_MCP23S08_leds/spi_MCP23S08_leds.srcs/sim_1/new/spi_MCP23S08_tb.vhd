-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;

entity spi_MCP23S08_tb is
end entity;

architecture sim of spi_MCP23S08_tb is
    signal c_CLOCKPERIOD : time := 100 ns;
    
	signal r_clk        : std_logic := '0';
    signal r_reset      : std_logic;
        
    -- mosi signals
    signal r_tx_pulse	: std_logic;

    -- spi interface
    signal r_spi_clk	: std_logic;
    signal r_spi_mosi 	: std_logic;
    signal w_cs         : std_logic;
    
    signal r_mosi_reg   : std_logic_vector(23 downto 0) := (others => '0');
begin

	spi_MCP23S08_inst: entity work.spi_MCP23S08(rtl)
    	port map (
        i_clk		=> r_clk,	
        i_reset		=> r_reset, 
        i_tx_pulse	=> r_tx_pulse,
        o_spi_clk	=> r_spi_clk,
        o_spi_mosi 	=> r_spi_mosi,
        o_cs 		=> w_cs);

    clk_gen : r_clk <= not r_clk after c_CLOCKPERIOD / 2;  	
    
    spi_mosi : process
    begin
        r_tx_pulse <= '0';
        r_reset <= '1';
        wait for 100 ns;
        r_reset <= '0';
        wait for 100 ns;
        r_tx_pulse <= '1';
        wait until rising_edge(r_clk);
        r_tx_pulse <= '0';
        
        for i in 23 downto 0 loop
            wait until rising_edge(r_clk);
            r_mosi_reg(i) <= r_spi_mosi;
        end loop;

        wait for 1000 ns;
        
        r_tx_pulse <= '1';
        wait until rising_edge(r_clk);
        r_tx_pulse <= '0';
        
        for i in 23 downto 0 loop
            wait until rising_edge(r_clk);
            r_mosi_reg(i) <= r_spi_mosi;
        end loop;
       
        wait for 1 us;
        
        report "simulation complete" severity failure;
    end process;
    
end sim;
