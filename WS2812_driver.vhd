library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity WS2812_driver is
   
    Port (  clk : in STD_LOGIC;  --Should be to 50Mhz --period 20ns
            reset_n : in STD_LOGIC;
            NUM_LEDS : positive := 1;
            data : in STD_LOGIC_VECTOR (23 downto 0); -- 24 bits of color data for the LED (RGB) -- 8 bit for each
            SDO : out STD_LOGIC);   --NRZ DATA for the Adafruit Neopixel WS2812
    end WS2812_driver;

architecture Behavioral of WS2812_driver is

--Pas oublier le reset
type state_type is (IDLE, SEND_DATA, SEND_RESET,SEND_T1H,SEND_T1L,SEND_TOH,SEND_TOL,NUMBER_LEDS);
signal F_state: state_type := SEND_RESET;
signal cnt_send_data : natural:= 24;
signal cnt_reset : natural:= 5000;--2499; -- 50us
signal cnt_T0H : natural:= 17;
signal cnt_T0L : natural:= 39;
signal cnt_T1L : natural:= 30;
signal cnt_T1H : natural:= 34;
signal test_data : std_logic := '0';
signal cnt_send_NUM_LEDS : natural:= 0;
signal SDO_temp : std_logic;

begin
SDO<=SDO_temp;



process (clk, reset_n)
begin
    if (reset_n = '0') then
        SDO_temp <= '0';
        cnt_send_data <= 24;
        cnt_reset <= 5000;--2499;
        cnt_T0H <= 17;
        cnt_T0L <= 39;
        cnt_T1L <= 30;
        cnt_T1H <= 34;
        cnt_send_NUM_LEDS <= 0;
		F_state <= SEND_RESET;
    elsif (rising_edge(clk)) then
  
    case F_state is
    
        when IDLE =>
            SDO_TEMP <= '0'z
            
            F_State <= NUMBER_LEDS;
            
        when SEND_RESET =>
			--if counter == 50 us
                 if(cnt_reset = 0) then
                 cnt_reset <=5000;-- 2499;  --100 us for the reset or 2499
                 SDO_temp <= '0';
                cnt_send_data <= 24;
                cnt_T0H <= 17;
                cnt_T0L <= 39;
                cnt_T1L <= 30;
                cnt_T1H <= 34;
                cnt_send_NUM_LEDS <= 0;
                 F_state <= NUMBER_LEDS;
                 else 
                    
                    SDO_temp <= '0';
                    cnt_reset <= cnt_reset -1;
                    F_state <= SEND_RESET;
                 end if;
             
		
			
        when NUMBER_LEDS =>
			--Not Equal
		    if(cnt_send_NUM_LEDS/=NUM_LEDS) then
		      cnt_send_NUM_LEDS <= cnt_send_NUM_LEDS +1;
		      cnt_send_data <= 24;
		      F_state <= SEND_DATA;
		    elsif(cnt_send_NUM_LEDS=NUM_LEDS) then
		      F_state <= SEND_RESET;
		    else
		      F_state <= IDLE;
		    end if;

        when SEND_DATA =>
            
            if(cnt_send_data>0) then
                --Envoie des 24 bits
                test_data <=data(cnt_send_data-1);
                if(data(cnt_send_data-1)='0') then
                     F_state <= SEND_TOH;
                elsif(data(cnt_send_data-1)='1')then
                     F_state <= SEND_T1H;
                end if;
				cnt_send_data <= cnt_send_data - 1;
					
			elsif(cnt_send_data=0) then
			    F_state <= NUMBER_LEDS;			
			end if;      
			   
		when SEND_TOH =>
		    --0.35us TOh et 0.8us TOl
	
		    if(cnt_T0H = 0) then
		           cnt_T0H <= 17;
                   F_state <= SEND_TOL;   
                 else 
                    SDO_temp <= '1';
                    cnt_T0H <= cnt_T0H -1;
                    F_state <= SEND_TOH;
                 end if;
                 
        when SEND_TOL =>
		    --0.35us TOh et 0.8us TOl

		    if(cnt_T0L = 0) then    
                   cnt_T0L <= 39;      
                   F_state <= SEND_DATA;
                 else 
                    SDO_temp <= '0';
                    cnt_T0L <= cnt_T0L -1;
                    F_state <= SEND_TOL;
                 end if;
		    
		when SEND_T1H=>
		    --0.7us T1h and 0.6us T1l
             if(cnt_T1H = 0) then
                   cnt_T1H <= 34;
                   F_state <= SEND_T1L;
                 else 
                    SDO_temp <= '1';
                    cnt_T1H <= cnt_T1H -1;
                    F_state <= SEND_T1H;
                 end if;
			
			
        when SEND_T1L =>
		    --0.35us TOh and 0.8us TOl
		    
		    if(cnt_T1L = 0) then
		           cnt_T1L <= 30;
                   F_state <= SEND_DATA;
                 else 
                    SDO_temp <= '0';
                    cnt_T1L <= cnt_T1L -1;
                    F_state <= SEND_T1L;
                 end if;
        when others =>
            cnt_send_data <= 24;
            cnt_send_NUM_LEDS <= 0;    
            cnt_reset <= 5000;--2499;
            cnt_T0H <= 17;
            cnt_T0L <= 39;
            cnt_T1L <= 30;
            cnt_T1H <= 34;
            SDO_Temp <= '0';   
            F_state <= SEND_RESET;       
        end case;               
   end if;
end process;               
                                     
                   
end Behavioral;             