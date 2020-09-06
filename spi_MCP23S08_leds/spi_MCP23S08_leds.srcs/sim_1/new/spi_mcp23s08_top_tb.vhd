-- This testbench is to test the complete MCP23S08 ic.
-- An input triggers the process to send the iodir and
-- gpio commands.
--
-- FPGA: Nexys-4 DDR
-- Author: Jerome Samuels-Clarke
-- Website: www.jscblog.com

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity spi_mcp23s08_top_tb is
end spi_mcp23s08_top_tb;

architecture sim of spi_mcp23s08_top_tb is
    signal c_CLOCKPERIOD : time := 10 ns;
    
	signal r_clk        : std_logic := '0';
    signal r_reset      : std_logic;
    signal r_sw         : std_logic;
    signal r_spi_clk	: std_logic;
    signal r_spi_mosi 	: std_logic;
    signal w_cs         : std_logic;
    
begin

	spi_MCP23S08_top_inst: entity work.spi_MCP23S08_top(rtl)
    	port map (
        i_clk		=> r_clk,	
        i_reset		=> r_reset, 
        i_sw        => r_sw,
        o_spi_clk	=> r_spi_clk,
        o_spi_mosi 	=> r_spi_mosi,
        o_cs 		=> w_cs);

    clk_gen : r_clk <= not r_clk after c_CLOCKPERIOD / 2;  	

    process
    begin
        -- reset 
        r_sw <= '0';
        r_reset <= '1';
        wait for 100 ns;
        r_reset <= '0';
        
        -- send first command (iodir)
        wait for 100 ns;
        r_sw <= '1';
        wait for 100 ns;
        r_sw <= '0';
        
        -- send second command (gpio)
        wait for 10000 ns;
        r_sw <= '1';
        wait for 100 ns;
        r_sw <= '0';   
        
        wait for 1000 ns;  
        
       report "simulation complete" severity failure;
       
    end process;
    
end sim;
