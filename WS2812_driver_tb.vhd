library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity WS2812_driver_tb is
end WS2812_driver_tb;

architecture Behavioral of WS2812_driver_tb is

component WS2812_driver is
    Port (  clk : in STD_LOGIC;  --Should be to 50Mhz --period 20ns
            reset_n : in STD_LOGIC;
            NUM_LEDS : positive := 1;
            data : in STD_LOGIC_VECTOR (23 downto 0); -- 24 bits of color data per LED
            SDO : out STD_LOGIC);
    end component;

signal clk : std_logic := '0';
signal reset_n : std_logic := '1';
signal data : std_logic_vector (23 downto 0) := (others => '0');

signal SDO : std_logic;

constant clk_period : time := 20 ns;

begin

uut: WS2812_driver
	port map (
		clk => clk,
		NUM_LEDS => 1,
		reset_n => reset_n,
		data => data,
		SDO => SDO
	);

clk_process : process
begin
	clk <= '0';
	wait for clk_period/2;
	clk <= '1';
	wait for clk_period/2;
end process;

reset_test : process
begin
	-- initial reset
	reset_n <= '0';
	wait for 1 * clk_period;
	reset_n <= '1';
	wait;
end process;

data_test : process
begin
	-- test data
	data <= "101010101010101010101010";
	wait for 1000 * clk_period;
	data <= "000000000000101010101010";
	wait;
end process;

end Behavioral;