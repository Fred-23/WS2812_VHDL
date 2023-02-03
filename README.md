# WS2812_VHDL
WS2812 Driver and Testbench in VHD. Use for LED CONTROL on Adafruit Neopixel.



Result : 

<img width="115" alt="image" src="https://user-images.githubusercontent.com/101244166/216690499-1892a004-0719-4492-8b2f-9529224d68d6.png">


| Pinout  | Description          | Setup |
| :--------------- |:---------------:| -----:|
| SDO |   NRZ SIGNAL use for LED CONTROL (DATA INPUT)      |  Should be connected to  DATA INPUT of your system|
| Clock  | 50 MHz only or you can easily change the timing constants             |   Input (Clock 50 MHz) |
| data  |  -- 24 bits of color data for the LEDS  --(RGB) 8 bit for each        |    STD_LOGIC_VECTOR(23 downto 0)  |
| NUM_LEDS  |  Number of leds you want to control       |    positive number (default 1)  |
| RESET_N  |  Reset Signal       |    Reset happening when the state is '0' |
