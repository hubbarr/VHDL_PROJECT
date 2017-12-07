--------------------------------------------------------------------------------
--
--   FileName:         hw_image_generator.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 64-bit Version 12.1 Build 177 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 05/10/2013 Scott Larson
--     Initial Public Release
--    
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY hw_image_generator IS
	GENERIC(
		pixels_y :	INTEGER := 1280;    --row that first color will persist until
		pixels_x	:	INTEGER := 1024);   --column that first color will persist until

	PORT(
		clk			:	IN		STD_LOGIC;
		up				:	IN		STD_LOGIC;
		down			:	IN		STD_LOGIC;
		lt				:	IN		STD_LOGIC;
		rt				:	IN		STD_LOGIC;
		disp_ena		:	IN		STD_LOGIC;	--display enable ('1' = display time, '0' = blanking time)
		row			:	IN		INTEGER;		--row pixel coordinate
		column		:	IN		INTEGER;		--column pixel coordinate
		red			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
		green			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
		blue			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0'); --blue magnitude output to DAC
		
		SW0			:	IN STD_LOGIC;
		SW1			:	IN STD_LOGIC;
		SW2			:	IN STD_LOGIC;
		SW3			:	IN STD_LOGIC;
		reset			:	IN STD_LOGIC;
		ps2_clock	: 	IN	STD_LOGIC;
		ps2_data		: 	IN STD_LOGIC);
		
	END hw_image_generator;

ARCHITECTURE behavior OF hw_image_generator IS

signal counter : std_logic_vector(24 downto 0);
signal ps2_code_new : std_LOGIC;
signal keyin : std_LOGIC_VECTOR(8 downto 1);
signal reset1 : std_LOGIC;

BEGIN

Keyboard: entity work.ps2_keyboard 
	GENERIC map(
			clk_freq		=> 50_000_000,
			debounce_counter_size => 9)
	Port map(
			clk		=> clk,
			ps2_clk => ps2_clock,
			ps2_data => ps2_data,
			ps2_code_new => ps2_code_new,
			ps2_code => keyin);


	
	PROCESS(clk, disp_ena, row, column, keyin, SW0, SW1)
		Variable pposX			:    INTEGER := 102;
		Variable pposY			:    INTEGER := 35;
		Variable kposX			:	  INTEGER := 987;
		Variable kposY			:	  INTEGER := 675;
		Variable gposX			:	  INTEGER := 1179;
		Variable gposY			:	  INTEGER := 883;
		Variable key			:	  INTEGER := 0;
		VAriable room			:	  INTEGER := 0;
		Variable counter1		:	  INTEGER := 0;
		VAriable temp			:	  INTEGER := 0;
		Variable prevx			:	  INTEGER := 0;
		Variable prevy       :    INTEGER := 0; 
		
		
		
	BEGIN
	
	if (SW0 = '1') then
		room := 1;
	elsif (SW1 = '1') theN
		room := 0;
	end if;
	
	
	
	IF clk'event and clk = '1' then
		IF(disp_ena = '1') THEN
				
			--DRAW MAZE 2
		if (room = 1) then
		if temp = 0 then
			if (reset1 = '1') then
					pposX := prevx+20;
					pposY := prevy;
					key := 0;
					temp := 1;
					end if;
			end if;
			if (reset = '1') then
					pposX := prevx+20;
					pposY := prevy;
					key := 0;
					temp := 0;
					end if;
			
			IF(( row > 10 --Xoffset
					and row < 20) --(Xsize - Xoffset)
					AND (column > 10 --Yoffset
					and column < 1016)) --(Ysize - Yoffset) --RBorder*
					
					or ((row > 10 and row < 1143) AND (column > 1006 and column < 1016)) --BBorder*
					
					or ((row > 1260 and row < 1270) and (column > 10 and column < 1016)) --LBorder*
					or ((row > 10 and row < 1270) and (column > 10 and column < 20)) --TBorderR*
					or ((row > 10 and row < 169) and (column > 10 and column < 20)) --TBorderL*
					
					or ((row > 328 and row < 338) and (column > 899 and column < 1016)) --1*
					or ((row > 169 and row < 338) and (column > 899 and column < 909)) --2*
					or ((row > 169 and row < 179) and (column > 772 and column <= 899)) --3*
					
					or ((row > 646 and row < 656) and (column > 899 and column < 1016)) --4*
					
					or ((row > 964 and row < 974) and (column > 772 and column < 1016)) --5*
					
					or ((row > 646 and row < 656) and (column > 10 and column < 147)) --6*
					or ((row > 646 and row < 815) and (column > 137 and column < 147)) --7*
					or ((row > 805 and row < 815) and (column > 137 and column < 264)) --8
					
					or ((row > 10 and row < 328) and (column > 137 and column < 147)) --9
					or ((row > 169 and row < 179) and (column > 137 and column < 401)) --10
					or ((row > 169 and row <= 328) and (column > 391 and column < 401)) --11
					or ((row > 328 and row < 338) and (column > 391 and column < 528)) --12
					
					or ((row > 10 and row <= 169) and (column > 518 and column < 528)) --13
					or ((row > 169 and row < 179) and (column > 518 and column < 655)) --14
					or ((row > 169 and row < 646) and (column > 645 and column < 655)) --15
					or ((row > 487 and row < 497) and (column > 137 and column < 655)) --16
					or ((row > 328 and row <= 646) and (column > 264 and column < 274)) --17
					or ((row > 646 and row < 656) and (column > 264 and column < 401)) --18
					or ((row > 646 and row <= 964) and (column > 391 and column < 401)) --19
					or ((row > 964 and row < 974) and (column > 137 and column < 528)) --20
					or ((row > 964 and row <= 1123) and (column > 137 and column < 147)) --21
					or ((row > 1123 and row <= 1133) and (column > 137 and column < 899)) --22
					or ((row > 805 and row < 1123) and (column > 645 and column < 655)) --23
					or ((row > 805 and row < 815) and (column > 518 and column < 899)) --24
					or ((row > 646 and row < 815) and (column > 518 and column < 528)) --25
					or ((row > 328 and row < 815) and (column > 772 and column < 782)) --26
					or ((row > 487 and row < 497) and (column > 772 and column < 899)) --27
				THEN 
					red <= ("01101100");
					green	<= ("00111100");
					blue <= ("00000101");
				
				elsif ((row > 964 and row < 1123) AND (column > 147 and column < 264)) then
					red <= (OTHERS => '0');
					green <= (OTHERS => '1');
					blue <= (OTHERS => '0');
			ELSE --DRAW BACKGROUND/COLOR
				red <= ("10011011");
				green	<= ("10011011");
				blue <= ("10011011");
			END IF;
		end if;
--			if (pposX < 1260 and pposX > 1098 and pposY = 878) then
--				state <= room2;
--			end if;
			
--			when room1 =>
			
--DRAW MAZE ONE
			if (room = 0)then
				if (reset = '1') then
					pposX := 102;
					pposY := 35;
					key := 0;
				end if;
				
				IF((row >= 10 and row <= 20) AND (column > 10 and column < 1014))--LEFT WALL
					or ((row > 10 and row < 1098) AND (column >= 1004 and column <= 1014))--BOTTOM WALL
					or ((row >= 1260 and row <= 1270) and (column >= 10 and column <= 1014))--RIGHT WALL
					or ((row >= 192 and row <= 1270) and (column >= 10 and column <= 20))--TOP WALL
					
					or ((row >= 192 and row <= 202) and (column > 868 and column < 1014)) --1
					or ((row >= 1088 and row <= 1098) and (column > 878 and column < 1014)) --2
					or ((row > 10 and row < 192) and (column >= 302 and column <= 312)) --3
					
					or ((row > 10 and row < 738) and (column >= 740 and column <= 750)) --4
					or ((row >= 556 and row <= 566) and (column > 740 and column < 886)) --5
					or ((row > 374 and row < 566) and (column >= 876 and column <= 886)) --6
					
					or ((row >= 906 and row <= 1270) and (column >= 156 and column <= 166)) --7
					or ((row >= 906 and row <= 916) and (column >= 156 and column <= 458)) --8
					or ((row >= 734 and row <= 916) and (column >= 448 and column <= 458)) --9
					or ((row >= 734 and row <= 744) and (column >= 156 and column <= 458)) --10
					
					or ((row >= 906 and row <= 1270) and (column >= 740 and column <= 750)) --11
					or ((row >= 906 and row <= 916) and (column >= 594 and column <= 886)) --12
					or ((row >= 734 and row <= 916) and (column >= 876 and column <= 886)) --13
					or ((row >= 556 and row <= 1102) and (column >= 594 and column <= 604)) --14
					or ((row >= 1098 and row <= 1108) and (column >= 302 and column <= 604)) --15
					or ((row >= 556 and row <= 566) and (column >= 156 and column <= 594)) --16
					or ((row >= 192 and row <= 566) and (column >= 156 and column <= 166)) --17
					or ((row >= 374 and row <= 384) and (column >= 156 and column <= 458)) --18
					or ((row >= 192 and row <= 374) and (column >= 448 and column <= 458)) --19
					or ((row >= 192 and row <= 202) and (column >= 448 and column <= 604)) --20
					or ((row >= 192 and row <= 374) and (column >= 594 and column <= 604)) --21
				THEN --WALL COLOR
					red <= ("01101100");
					green	<= ("00111100");
					blue <= ("00000101");
					
--DRAW GOAL
				elsif ((row > 1098 and row < 1260) AND (column > 878 and column < 1014)) then
					red <= (OTHERS => '0');
					green <= (OTHERS => '1');
					blue <= (OTHERS => '0');

			ELSE --DRAW BACKGROUND/COLOR
				red <= ("10011011");
				green	<= ("10011011");
				blue <= ("10011011");
			END IF;
--			counter1 := (counter1+1);
		end if;
		
		

--			if (pposX < 1260 and pposX > 1098 and pposY = 878) then
--				state <= room2;
--			end if;
			
			
--KEY COLLISION	
		
			IF ((kposX-10 < pposX +25 and kposX+10 > pposX -25) AND (kposY-10 < pposY +25 and kposY+10 > pposY -25))then
				key := 1;
			end if;
		
				
--DRAW KEY AND BARRIER
		if (room = 0) then
				kposX := 987;
				kposY := 675;
				gposX	:= 1179;
				gposY	:= 883;
			end if;
		if(room = 1) theN
				kposX := 90;
				kposY := 200;
				gposX	:= 1049;
				gposY	:= 269;
		end if;
		
		if (key = 0) then
				if ((row > gposX -81 and row < gposX +81) AND (column > gposY -5 and column < gposY +5)) then
					red <= (OTHERS => '0');
					green <= (OTHERS => '0');
					blue <= (OTHERS => '0');
				end if;
	
				if ((row > kposX -10 and row < kposX +10) AND (column > kposY -10 and column < kposY +10)) then
					red <= (OTHERS => '1');
					green <= (OTHERS => '1');
					blue <= (OTHERS => '0');
				end if;
			
		end if;
		
--		if (room = 1) then
--			if (key = 0) then
--				kposX := 100;
--				kposY := 200;
--				if ((row > 974 and row < 1123) AND (column > 264 and column < 274)) then
--					red <= (OTHERS => '0');
--					green <= (OTHERS => '0');
--					blue <= (OTHERS => '0');
--				end if;
--				if ((row > kposX -10 and row < kposX +10) AND (column > kposY -10 and column < kposY +10)) then
--					red <= (OTHERS => '1');
--					green <= (OTHERS => '1');
--					blue <= (OTHERS => '0');
--				end if;
--			end if;
--		end if;
			
--DRAW PLAYER ICON
	if (((pposX < 0 ) or (pposX > 1280 )) or (((pposy < 0 ) or (pposy > 1024 )))) then
			pposX		:= prevx;
			pposY		:= prevy;
			end if;
			if ((row > pposX -25 and row < pposX +25) AND (column > pposY -25 and column < pposY +25)) then
					red <= (OTHERS => '1');
					green <= (OTHERS => '0');
					blue <= (OTHERS => '0');
			end if;
			
--MOVEMENT AND COLLISION (DOWN)				
				--if (down = '0') then
				if((keyin = X"E0" or keyin = X"72") and ps2_code_new = '1') then
					if counter < "000111111100001000000" then
						counter <= counter + 1;
					else
--							if (pposX-25 >= 10) and (pposX - 25 <= 1270) then
					if (room = 0) then
							if	(((pposX - 25 >= 20) and ( pposX + 25 <= 192)) and (pposY + 26 <= 302)) 
								or (((pposX - 25 >= 20) and ( pposX + 25 <= 576)) and (pposY + 26 <= 156))
								or (((pposX - 25 >= 20) and ( pposX + 25 <= 192)) and ((pposY + 26 >= 750) and (pposY + 26 <= 1004)))
								or (((pposX - 25 >= 556) and ( pposX + 25 <= 1260)) and (pposY + 26 <= 156))
								or (((pposX - 25 >= 192) and ( pposX + 25 <= 374)) and ((pposY + 26 >= 166) and (pposY + 26 <= 448)))
								or (((pposX - 25 >= 20) and ( pposX + 25 <= 192)) and ((pposY + 26 >= 312) and (pposY + 26 <= 740)))
								or (((pposX - 25 >= 192) and ( pposX + 25 <= 374)) and ((pposY + 26 >= 458) and (pposY + 26 <= 594)))
								or (((pposX - 25 >= 192) and ( pposX + 25 <= 374)) and ((pposY + 26 >= 750) and (pposY + 26 <= 1004)))
								or (((pposX - 25 >= 384) and ( pposX + 25 <= 556)) and ((pposY + 26 >= 166) and (pposY + 26 <= 740)))
								or (((pposX - 25 >= 384) and ( pposX + 25 <= 556)) and ((pposY + 26 >= 750) and (pposY + 26 <= 876)))
								or (((pposX - 25 >= 384) and ( pposX + 25 <= 556)) and ((pposY + 26 >= 886) and (pposY + 26 <= 1004)))
								or (((pposX - 25 >= 566) and ( pposX + 25 <= 734)) and (pposY + 26 <= 594))
								or (((pposX - 25 >= 566) and ( pposX + 25 <= 734)) and ((pposY + 26 >= 750) and (pposY + 26 <= 1004)))
								or (((pposX - 25 >= 566) and ( pposX + 25 <= 734)) and ((pposY + 26 >= 604) and (pposY + 26 <= 740)))
								or	(((pposX - 25 >= 744) and ( pposX + 25 <= 906)) and (pposY + 26 >= 458) and (pposY + 26 <= 594))
								or (((pposX - 25 >= 744) and ( pposX + 25 <= 906)) and (pposY + 26 <= 448))
								or (((pposX - 25 >= 744) and ( pposX + 25 <= 906)) and ((pposY + 26 >= 886) and (pposY + 26 <= 1004)))
								or (((pposX - 25 >= 744) and ( pposX + 25 <= 906)) and ((pposY + 26 >= 604) and (pposY + 26 <= 876)))
								or (((pposX - 25 >= 916) and ( pposX + 25 <= 1108)) and ((pposY + 26 >= 750) and (pposY + 26 <= 1004)))
								or (((pposX - 25 >= 916) and ( pposX + 25 <= 1108)) and ((pposY + 26 >= 166) and (pposY + 26 <= 594)))
								or (((pposX - 25 >= 916) and ( pposX + 25 <= 1260)) and ((pposY + 26 >= 604) and (pposY + 26 <= 740)))
								or (((pposX - 25 >= 916) and ( pposX + 25 <= 1260)) and ((pposY + 26 >= 166) and (pposY + 26 <= 302)))
								or (((pposX - 25 >= 1098) and ( pposX + 25 <= 1260)) and ((pposY + 26 >= 166) and (pposY + 26 <= 740)))
								or (key = 0 and (((pposX - 25 >= 1098) and ( pposX + 25 <= 1260)) and ((pposY + 26 >= 750) and (pposY + 26 <= 878))))
								or (key = 1 and (((pposX - 25 >= 1098) and ( pposX + 25 <= 1260)) and ((pposY + 26 >= 750) and (pposY + 26 <= 1004))))
								then
									prevy := pposY;
									pposY := (pposY+1);
				
								counter <= (others => '0'); 
								end if;
							end if;
						if (room = 1) then
							if	(((pposX - 25 >= 20) and ( pposX + 25 <= 169)) and ((pposy +26 >=20)) and (pposY + 26 <= 137)) 
								or (((pposX - 25 >= 20) and ( pposX + 25 <= 169)) and ((pposY + 26 >= 147) and (pposY + 26 <= 518)))
								or (((pposX - 25 >= 20) and ( pposX + 25 <= 169)) and ((pposY + 26 >= 528) and (pposY + 26 <= 1004)))

								or (((pposX - 25 >= 169) and ( pposX + 25 <= 328)) and (pposY + 26 <= 137))
								or (((pposX - 25 >= 169) and ( pposX + 25 <= 328)) and ((pposY + 26 >= 147) and (pposY + 26 <= 391)))
								or (((pposX - 25 >= 169) and ( pposX + 25 <= 328)) and ((pposY + 26 >= 401) and (pposY + 26 <= 645)))
								or (((pposX - 25 >= 169) and ( pposX + 25 <= 328)) and ((pposY + 26 >= 655) and (pposY + 26 <= 899)))
								or (((pposX - 25 >= 169) and ( pposX + 25 <= 328)) and ((pposY + 26 >= 909) and (pposY + 26 <= 1004)))
								
								or (((pposX - 25 >= 328) and ( pposX + 25 <= 487)) and ((pposY + 26 >= 20) and (pposY + 26 <= 264)))
								or (((pposX - 25 >= 328) and ( pposX + 25 <= 487)) and ((pposY + 26 >= 274) and (pposY + 26 <= 645)))
								or (((pposX - 25 >= 328) and ( pposX + 25 <= 487)) and ((pposY + 26 >= 655) and (pposY + 26 <= 772)))
								or (((pposX - 25 >= 328) and ( pposX + 25 <= 487)) and ((pposY + 26 >= 782) and (pposY + 26 <= 1004)))
								
								or (((pposX - 25 >= 487) and ( pposX + 25 <= 646)) and ((pposY + 26 >= 20) and (pposY + 26 <= 264)))
								or (((pposX - 25 >= 487) and ( pposX + 25 <= 646)) and ((pposY + 26 >= 274) and (pposY + 26 <= 645)))
								or (((pposX - 25 >= 487) and ( pposX + 25 <= 646)) and ((pposY + 26 >= 655) and (pposY + 26 <= 772)))
								or (((pposX - 25 >= 487) and ( pposX + 25 <= 646)) and ((pposY + 26 >= 782) and (pposY + 26 <= 1004)))
								
								or (((pposX - 25 >= 646) and ( pposX + 25 <= 805)) and (pposY + 26 <= 137))
								or (((pposX - 25 >= 646) and ( pposX + 25 <= 805)) and ((pposY + 26 >= 147) and (pposY + 26 <= 391)))
								or (((pposX - 25 >= 646) and ( pposX + 25 <= 805)) and ((pposY + 26 >= 401) and (pposY + 26 <= 518)))
								or (((pposX - 25 >= 646) and ( pposX + 25 <= 805)) and ((pposY + 26 >= 528) and (pposY + 26 <= 772)))
								or (((pposX - 25 >= 646) and ( pposX + 25 <= 805)) and ((pposY + 26 >= 782) and (pposY + 26 <= 1004)))
								
								or (((pposX - 25 >= 805) and ( pposX + 25 <= 964)) and ((pposY + 26 >= 20) and (pposY + 26 <= 391)))
								or	(((pposX - 25 >= 805) and ( pposX + 25 <= 964)) and ((pposY + 26 >= 401) and (pposY + 26 <= 645)))
								or (((pposX - 25 >= 805) and ( pposX + 25 <= 964)) and ((pposY + 26 >= 655) and (pposY + 26 <= 1004)))
								
								or (((pposX - 25 >= 964) and ( pposX + 25 <= 1123)) and ((pposY + 26 <= 137)))
								or (((pposX - 25 >= 964) and ( pposX + 25 <= 1123)) and ((pposY + 26 >= 147) and (pposY + 26 <= 645)))
								or (((pposX - 25 >= 964) and ( pposX + 25 <= 1123)) and ((pposY + 26 >= 655) and (pposY + 26 <= 1004)))
								
								or (((pposX - 25 >= 1123) and ( pposX + 25 <= 1260)) and ((pposY + 26 >= 20) and (pposY + 26 <= 1004)))
								
								then
									prevy := pposY;
									pposY := (pposY+1);
						
								counter <= (others => '0'); 
								end if;
							end if;
						end if;
					end if;
					
--MOVEMENT AND COLLISION (RIGHT)	
					--if (rt = '0') then
					if((keyin = X"E0" or keyin = X"74") and ps2_code_new = '1') then
					if counter < "000111111100001000000" then
						counter <= counter + 1;
						
		
					else
--						if (pposX-25 >= 10) and (pposX - 25 <= 1270) then 
					if (room = 0) then
						if	(((pposX + 26 >= 20) and ( pposX + 26 <= 1260)) and ((pposY - 25 >= 20)and (pposY + 25 <= 156)))
							or (((pposX + 26 >= 20) and ( pposX + 26 <= 374)) and ((pposY - 25 >= 166) and (pposY + 25 <= 302)))
							or (((pposX + 26 >= 384) and ( pposX + 26 <= 556)) and ((pposY - 25 >= 166) and (pposY + 25 <= 302)))
							or (((pposX + 26 >= 566) and ( pposX + 26 <= 734)) and ((pposY - 25 >= 166) and (pposY + 25 <= 302)))
							or (((pposX + 26 >= 744) and ( pposX + 26 <= 906)) and ((pposY - 25 >= 166) and (pposY + 25 <= 302)))
							or (((pposX + 26 >= 916) and ( pposX + 26 <= 1260)) and ((pposY - 25 >= 166) and (pposY + 25 <= 302)))
					
							or (((pposX + 26 >= 20) and ( pposX + 26 <= 374)) and ((pposY - 25 >= 312) and (pposY + 25 <= 448)))
							or (((pposX + 26 >= 384) and ( pposX + 26 <= 556)) and ((pposY - 25 >= 312) and (pposY + 25 <= 448)))
							or (((pposX + 26 >= 566) and ( pposX + 26 <= 734)) and ((pposY - 25 >= 312) and (pposY + 25 <= 448)))
							or (((pposX + 26 >= 744) and ( pposX + 26 <= 906)) and ((pposY - 25 >= 312) and (pposY + 25 <= 448)))
							or (((pposX + 26 >= 916) and ( pposX + 26 <= 1098)) and ((pposY - 25 >= 312) and (pposY + 25 <= 448)))
							or (((pposX + 26 >= 1108) and ( pposX + 26 <= 1260)) and ((pposY - 25 >= 312) and (pposY + 25 <= 448)))
						
							or (((pposX + 26 >= 20) and ( pposX + 26 <= 192)) and ((pposY - 25 >= 458) and (pposY + 25 <= 594)))
							or (((pposX + 26 >= 202) and ( pposX + 26 <= 556)) and ((pposY - 25 >= 458) and (pposY + 25 <= 594)))
							or (((pposX + 26 >= 566) and ( pposX + 26 <= 1098)) and ((pposY - 25 >= 458) and (pposY + 25 <= 594)))
							or (((pposX + 26 >= 1108) and ( pposX + 26 <= 1260)) and ((pposY - 25 >= 458) and (pposY + 25 <= 594)))
						
							or (((pposX + 26 >= 20) and ( pposX + 26 <= 906)) and ((pposY - 25 >= 604) and (pposY + 25 <= 740)))
							or (((pposX + 26 >= 916) and ( pposX + 26 <= 1260)) and ((pposY - 25 >= 604) and (pposY + 25 <= 740)))
						
							or (((pposX + 26 >= 20) and ( pposX + 26 <= 556)) and ((pposY - 25 >= 750) and (pposY + 25 <= 876)))
							or (((pposX + 26 >= 566) and ( pposX + 26 <= 906)) and ((pposY - 25 >= 750) and (pposY + 25 <= 876)))
							or (((pposX + 26 >= 916) and ( pposX + 26 <= 1260)) and ((pposY - 25 >= 750) and (pposY + 25 <= 876)))
					
							or (((pposX + 26 >= 20) and ( pposX + 26 <= 192)) and ((pposY - 25 >= 886) and (pposY + 25 <= 1004)))
							or (((pposX + 26 >= 202) and ( pposX + 26 <= 1088)) and ((pposY - 25 >= 886) and (pposY + 25 <= 1004)))
							or (((pposX + 26 >= 1108) and ( pposX + 26 <= 1260)) and ((pposY - 25 >= 886) and (pposY + 25 <= 1004)))
							then	
								prevx := pposX;
								pposX := (pposX+1);
						
							
						counter <= (others => '0'); 
						end if;
						end if;
					if (room = 1) then
						if	(((pposX + 26 >= 20) and ( pposX + 26 <= 646)) and ((pposY - 25 >= 20)and (pposY + 25 <= 137)))
						or (((pposX + 26 >= 656) and ( pposX + 26 <= 1260)) and ((pposY - 25 >= 20)and (pposY + 25 <= 137)))
					
						or (((pposX + 26 >= 20) and ( pposX + 26 <= 169)) and ((pposY - 25 >= 137) and (pposY + 25 <= 264)))
						or (((pposX + 26 >= 179) and ( pposX + 26 <= 487)) and ((pposY - 25 >= 137) and (pposY + 25 <= 264)))
						or (((pposX + 26 >= 497) and ( pposX + 26 <= 805)) and ((pposY - 25 >= 137) and (pposY + 25 <= 264)))
						or (((pposX + 26 >= 815) and ( pposX + 26 <= 964)) and ((pposY - 25 >= 137) and (pposY + 25 <= 264)))
						or (((pposX + 26 >= 974) and ( pposX + 26 <= 1123)) and ((pposY - 25 >= 137) and (pposY + 25 <= 264)))
						or (((pposX + 26 >= 1133) and ( pposX + 26 <= 1260)) and ((pposY - 25 >= 137) and (pposY + 25 <= 264)))
					
						or (((pposX + 26 >= 20) and ( pposX + 26 <= 169)) and ((pposY - 25 >= 264) and (pposY + 25 <= 391)))
						or (((pposX + 26 >= 179) and ( pposX + 26 <= 487)) and ((pposY - 25 >= 264) and (pposY + 25 <= 391)))
						or (((pposX + 26 >= 497) and ( pposX + 26 <= 646)) and ((pposY - 25 >= 264) and (pposY + 25 <= 391)))
						or (((pposX + 26 >= 656) and ( pposX + 26 <= 964)) and ((pposY - 25 >= 264) and (pposY + 25 <= 391)))
						or (((pposX + 26 >= 974) and ( pposX + 26 <= 1123)) and ((pposY - 25 >= 264) and (pposY + 25 <= 391)))
						or (((pposX + 26 >= 1133) and ( pposX + 26 <= 1260)) and ((pposY - 25 >= 264) and (pposY + 25 <= 391)))
						
						or (((pposX + 26 >= 20) and ( pposX + 26 <= 328)) and ((pposY - 25 >= 391) and (pposY + 25 <= 518)))
						or (((pposX + 26 >= 338) and ( pposX + 26 <= 487)) and ((pposY - 25 >= 391) and (pposY + 25 <= 518)))
						or (((pposX + 26 >= 497) and ( pposX + 26 <= 964)) and ((pposY - 25 >= 391) and (pposY + 25 <= 518)))
						or (((pposX + 26 >= 974) and ( pposX + 26 <= 1123)) and ((pposY - 25 >= 391) and (pposY + 25 <= 518)))
						or (((pposX + 26 >= 1133) and ( pposX + 26 <= 1260)) and ((pposY - 25 >= 391) and (pposY + 25 <= 518)))
						
						or (((pposX + 26 >= 20) and ( pposX + 26 <= 169)) and ((pposY - 25 >= 518) and (pposY + 25 <= 645)))
						or (((pposX + 26 >= 179) and ( pposX + 26 <= 487)) and ((pposY - 25 >= 518) and (pposY + 25 <= 645)))
						or (((pposX + 26 >= 497) and ( pposX + 26 <= 805)) and ((pposY - 25 >= 518) and (pposY + 25 <= 645)))
						or (((pposX + 26 >= 815) and ( pposX + 26 <= 1123)) and ((pposY - 25 >= 518) and (pposY + 25 <= 645)))
						or (((pposX + 26 >= 1133) and ( pposX + 26 <= 1260)) and ((pposY - 25 >= 518) and (pposY + 25 <= 645)))
						
						or (((pposX + 26 >= 20) and ( pposX + 26 <= 805)) and ((pposY - 25 >= 645) and (pposY + 25 <= 772)))
						or (((pposX + 26 >= 815) and ( pposX + 26 <= 1123)) and ((pposY - 25 >= 645) and (pposY + 25 <= 772)))
						or (((pposX + 26 >= 1133) and ( pposX + 26 <= 1260)) and ((pposY - 25 >= 645) and (pposY + 25 <= 772)))
					
						or (((pposX + 26 >= 20) and ( pposX + 26 <= 169)) and ((pposY - 25 >= 772) and (pposY + 25 <= 899)))
						or (((pposX + 26 >= 179) and ( pposX + 26 <= 487)) and ((pposY - 25 >= 772) and (pposY + 25 <= 899)))
						or (((pposX + 26 >= 497) and ( pposX + 26 <= 805)) and ((pposY - 25 >= 772) and (pposY + 25 <= 899)))
						or (((pposX + 26 >= 815) and ( pposX + 26 <= 964)) and ((pposY - 25 >= 772) and (pposY + 25 <= 899)))
						or (((pposX + 26 >= 974) and ( pposX + 26 <= 1123)) and ((pposY - 25 >= 772) and (pposY + 25 <= 899)))
						or (((pposX + 26 >= 1133) and ( pposX + 26 <= 1260)) and ((pposY - 25 >= 772) and (pposY + 25 <= 899)))
						
						or (((pposX + 26 >= 20) and ( pposX + 26 <= 328)) and ((pposY - 25 >= 899) and (pposY + 25 <= 1016)))
						or (((pposX + 26 >= 338) and ( pposX + 26 <= 646)) and ((pposY - 25 >= 899) and (pposY + 25 <= 1016)))
						or (((pposX + 26 >= 656) and ( pposX + 26 <= 964)) and ((pposY - 25 >= 899) and (pposY + 25 <= 1016)))
						or (((pposX + 26 >= 974) and ( pposX + 26 <= 1260)) and ((pposY - 25 >= 899) and (pposY + 25 <= 1016)))
							then	
								prevx := pposX;
								pposX := (pposX+1);
						
							
						counter <= (others => '0'); 
						end if;
						end if;
					end if;
					end if;
					
--MOVEMENT AND COLLISION (LEFT)	
					--if (lt = '0') then
					if((keyin = X"E0" or keyin = X"6B") and ps2_code_new = '1') then
					if counter < "000111111100001000000" then
						counter <= counter + 1;
					else
--					if (pposX-25 >= 10) and (pposX - 25 <= 1270) then 
					if (room = 0) then
					if	(((pposX - 26 >= 20) and ( pposX - 26 <= 1260)) and ((pposY - 25 >= 20)and (pposY + 25 <= 156)))
						or (((pposX - 26 >= 20) and ( pposX - 26 <= 374)) and ((pposY - 25 >= 166) and (pposY + 25 <= 302)))
						or (((pposX - 26 >= 384) and ( pposX - 26 <= 556)) and ((pposY - 25 >= 166) and (pposY + 25 <= 302)))
						or (((pposX - 26 >= 566) and ( pposX - 26 <= 734)) and ((pposY - 25 >= 166) and (pposY + 25 <= 302)))
						or (((pposX - 26 >= 744) and ( pposX - 26 <= 906)) and ((pposY - 25 >= 166) and (pposY + 25 <= 302)))
						or (((pposX - 26 >= 916) and ( pposX - 26 <= 1260)) and ((pposY - 25 >= 166) and (pposY + 25 <= 302)))
					
						or (((pposX - 26 >= 20) and ( pposX - 26 <= 374)) and ((pposY - 25 >= 312) and (pposY + 25 <= 448)))
						or (((pposX - 26 >= 384) and ( pposX - 26 <= 556)) and ((pposY - 25 >= 312) and (pposY + 25 <= 448)))
						or (((pposX - 26 >= 566) and ( pposX - 26 <= 734)) and ((pposY - 25 >= 312) and (pposY + 25 <= 448)))
						or (((pposX - 26 >= 744) and ( pposX - 26 <= 906)) and ((pposY - 25 >= 312) and (pposY + 25 <= 448)))
						or (((pposX - 26 >= 916) and ( pposX - 26 <= 1098)) and ((pposY - 25 >= 312) and (pposY + 25 <= 448)))
						or (((pposX - 26 >= 1108) and ( pposX - 26 <= 1260)) and ((pposY - 25 >= 312) and (pposY + 25 <= 448)))
						
						or (((pposX - 26 >= 20) and ( pposX - 26 <= 192)) and ((pposY - 25 >= 458) and (pposY + 25 <= 594)))
						or (((pposX - 26 >= 202) and ( pposX - 26 <= 556)) and ((pposY - 25 >= 458) and (pposY + 25 <= 594)))
						or (((pposX - 26 >= 566) and ( pposX - 26 <= 1098)) and ((pposY - 25 >= 458) and (pposY + 25 <= 594)))
						or (((pposX - 26 >= 1108) and ( pposX - 26 <= 1260)) and ((pposY - 25 >= 458) and (pposY + 25 <= 594)))
						
						or (((pposX - 26 >= 20) and ( pposX - 26 <= 906)) and ((pposY - 25 >= 604) and (pposY + 25 <= 740)))
						or (((pposX - 26 >= 916) and ( pposX - 26 <= 1260)) and ((pposY - 25 >= 604) and (pposY + 25 <= 740)))
						
						or (((pposX - 26 >= 20) and ( pposX - 26 <= 556)) and ((pposY - 25 >= 750) and (pposY + 25 <= 876)))
						or (((pposX - 26 >= 566) and ( pposX - 26 <= 906)) and ((pposY - 25 >= 750) and (pposY + 25 <= 876)))
						or (((pposX - 26 >= 916) and ( pposX - 26 <= 1260)) and ((pposY - 25 >= 750) and (pposY + 25 <= 876)))
					
						or (((pposX - 26 >= 20) and ( pposX - 26 <= 192)) and ((pposY - 25 >= 886) and (pposY + 25 <= 1004)))
						or (((pposX - 26 >= 202) and ( pposX - 26 <= 1098)) and ((pposY - 25 >= 886) and (pposY + 25 <= 1004)))
						or (((pposX - 26 >= 1108) and ( pposX - 26 <= 1260)) and ((pposY - 25 >= 886) and (pposY + 25 <= 1004)))
						
						then	
							prevx := pposX;
							pposX := (pposX-1);
						
							
						counter <= (others => '0'); 
							end if;
						end if;
				if (room = 1) then
					if	(((pposX - 26 >= 20) and ( pposX - 26 <= 646)) and ((pposY - 25 >= 20)and (pposY + 25 <= 137)))
						or (((pposX - 26 >= 656) and ( pposX - 26 <= 1260)) and ((pposY - 25 >= 20)and (pposY + 25 <= 137)))
					
						or (((pposX - 26 >= 20) and ( pposX - 26 <= 169)) and ((pposY - 25 >= 137) and (pposY + 25 <= 264)))
						or (((pposX - 26 >= 179) and ( pposX - 26 <= 487)) and ((pposY - 25 >= 137) and (pposY + 25 <= 264)))
						or (((pposX - 26 >= 497) and ( pposX - 26 <= 805)) and ((pposY - 25 >= 137) and (pposY + 25 <= 264)))
						or (((pposX - 26 >= 815) and ( pposX - 26 <= 964)) and ((pposY - 25 >= 137) and (pposY + 25 <= 264)))
						or (((pposX - 26 >= 974) and ( pposX - 26 <= 1123)) and ((pposY - 25 >= 137) and (pposY + 25 <= 264)))
						or (((pposX - 26 >= 1133) and ( pposX - 26 <= 1260)) and ((pposY - 25 >= 137) and (pposY + 25 <= 264)))
					
						or (((pposX - 26 >= 20) and ( pposX - 26 <= 169)) and ((pposY - 25 >= 264) and (pposY + 25 <= 391)))
						or (((pposX - 26 >= 179) and ( pposX - 26 <= 487)) and ((pposY - 25 >= 264) and (pposY + 25 <= 391)))
						or (((pposX - 26 >= 497) and ( pposX - 26 <= 646)) and ((pposY - 25 >= 264) and (pposY + 25 <= 391)))
						or (((pposX - 26 >= 656) and ( pposX - 26 <= 964)) and ((pposY - 25 >= 264) and (pposY + 25 <= 391)))
						or (((pposX - 26 >= 974) and ( pposX - 26 <= 1123)) and ((pposY - 25 >= 264) and (pposY + 25 <= 391)))
						or (((pposX - 26 >= 1133) and ( pposX - 26 <= 1260)) and ((pposY - 25 >= 264) and (pposY + 25 <= 391)))
						
						or (((pposX - 26 >= 20) and ( pposX - 26 <= 328)) and ((pposY - 25 >= 391) and (pposY + 25 <= 518)))
						or (((pposX - 26 >= 338) and ( pposX - 26 <= 487)) and ((pposY - 25 >= 391) and (pposY + 25 <= 518)))
						or (((pposX - 26 >= 497) and ( pposX - 26 <= 964)) and ((pposY - 25 >= 391) and (pposY + 25 <= 518)))
						or (((pposX - 26 >= 974) and ( pposX - 26 <= 1123)) and ((pposY - 25 >= 391) and (pposY + 25 <= 518)))
						or (((pposX - 26 >= 1133) and ( pposX - 26 <= 1260)) and ((pposY - 25 >= 391) and (pposY + 25 <= 518)))
						
						or (((pposX - 26 >= 20) and ( pposX - 26 <= 169)) and ((pposY - 25 >= 518) and (pposY + 25 <= 645)))
						or (((pposX - 26 >= 179) and ( pposX - 26 <= 487)) and ((pposY - 25 >= 518) and (pposY + 25 <= 645)))
						or (((pposX - 26 >= 497) and ( pposX - 26 <= 805)) and ((pposY - 25 >= 518) and (pposY + 25 <= 645)))
						or (((pposX - 26 >= 815) and ( pposX - 26 <= 1123)) and ((pposY - 25 >= 518) and (pposY + 25 <= 645)))
						or (((pposX - 26 >= 1133) and ( pposX - 26 <= 1260)) and ((pposY - 25 >= 518) and (pposY + 25 <= 645)))
						
						or (((pposX - 26 >= 20) and ( pposX - 26 <= 805)) and ((pposY - 25 >= 645) and (pposY + 25 <= 772)))
						or (((pposX - 26 >= 815) and ( pposX - 26 <= 1123)) and ((pposY - 25 >= 645) and (pposY + 25 <= 772)))
						or (((pposX - 26 >= 1133) and ( pposX - 26 <= 1260)) and ((pposY - 25 >= 645) and (pposY + 25 <= 772)))
					
						or (((pposX - 26 >= 20) and ( pposX - 26 <= 169)) and ((pposY - 25 >= 772) and (pposY + 25 <= 899)))
						or (((pposX - 26 >= 179) and ( pposX - 26 <= 487)) and ((pposY - 25 >= 772) and (pposY + 25 <= 899)))
						or (((pposX - 26 >= 497) and ( pposX - 26 <= 805)) and ((pposY - 25 >= 772) and (pposY + 25 <= 899)))
						or (((pposX - 26 >= 815) and ( pposX - 26 <= 964)) and ((pposY - 25 >= 772) and (pposY + 25 <= 899)))
						or (((pposX - 26 >= 974) and ( pposX - 26 <= 1123)) and ((pposY - 25 >= 772) and (pposY + 25 <= 899)))
						or (((pposX - 26 >= 1133) and ( pposX - 26 <= 1260)) and ((pposY - 25 >= 772) and (pposY + 25 <= 899)))
						
						or (((pposX - 26 >= 20) and ( pposX - 26 <= 328)) and ((pposY - 25 >= 899) and (pposY + 25 <= 1016)))
						or (((pposX - 26 >= 338) and ( pposX - 26 <= 646)) and ((pposY - 25 >= 899) and (pposY + 25 <= 1016)))
						or (((pposX - 26 >= 656) and ( pposX - 26 <= 964)) and ((pposY - 25 >= 899) and (pposY + 25 <= 1016)))
						or (((pposX - 26 >= 974) and ( pposX - 26 <= 1260)) and ((pposY - 25 >= 899) and (pposY + 25 <= 1016)))
						
						then	
							prevx := pposX;
							pposX := (pposX-1);
						
							
						counter <= (others => '0'); 
							end if;
						end if;
						end if;
						elsif ((keyin = X"E0" or keyin = X"F0" or keyin = X"6B") and ps2_code_new = '0') then
							pposX := pposX;
					
					end if;
					
--MOVEMENT AND COLLISION (UP)	
					--if (up = '0') then
					if((keyin = X"75" or keyin = X"E0") and ps2_code_new = '1') then
					if counter < "000111111100001000000" then
						counter <= counter + 1;
						
		
					else
					if (room = 0) then
					if	(((pposX - 25 >= 20) and ( pposX + 25 <= 1260)) and ((pposY - 26 >= 20)and (pposY - 26 <= 156))) 
								or (((pposX - 25 >= 20) and ( pposX + 26 <= 192)) and ((pposY - 26 >= 750) and (pposY - 26 <= 1004)))
							
								or (((pposX - 25 >= 20) and ( pposX + 25 <= 192)) and ((pposY - 26 >= 312) and (pposY - 26 <= 740)))
								or (((pposX - 25 >= 20) and ( pposX + 25 <= 192)) and ((pposY - 26 >= 20) and (pposY - 26 <= 302)))
								or (((pposX - 25 >= 192) and ( pposX + 25 <= 374)) and ((pposY - 26 >= 166) and (pposY - 26 <= 448)))
								or (((pposX - 25 >= 192) and ( pposX + 25 <= 374)) and ((pposY - 26 >= 458) and (pposY - 26 <= 594)))
								or (((pposX - 25 >= 192) and ( pposX + 25 <= 374)) and ((pposY - 26 >= 604) and (pposY - 26 <= 740)))
								or (((pposX - 25 >= 192) and ( pposX + 25 <= 374)) and ((pposY - 26 >= 750) and (pposY - 26 <= 1004)))
								or (((pposX - 25 >= 384) and ( pposX + 25 <= 556)) and ((pposY - 26 >= 166) and (pposY - 26 <= 740)))
								or (((pposX - 25 >= 384) and ( pposX + 25 <= 556)) and ((pposY - 26 >= 750) and (pposY - 26 <= 876)))
								or (((pposX - 25 >= 384) and ( pposX + 25 <= 556)) and ((pposY - 26 >= 886) and (pposY - 26 <= 1004)))
								or (((pposX - 25 >= 566) and ( pposX + 25 <= 734)) and ((pposY - 26 >= 20) and (pposY - 26 <= 594)))
								or (((pposX - 25 >= 566) and ( pposX + 25 <= 734)) and ((pposY - 26 >= 750) and (pposY - 26 <= 1004)))
								or (((pposX - 25 >= 566) and ( pposX + 25 <= 734)) and ((pposY - 26 >= 604) and (pposY - 26 <= 740)))
								or	(((pposX - 25 >= 734) and ( pposX + 25 <= 920)) and ((pposY - 26 >= 458) and (pposY - 26 <= 594)))
								or (((pposX - 25 >= 734) and ( pposX + 25 <= 920)) and ((pposY - 26 >= 20) and(pposY - 26 <= 448)))
								or (((pposX - 25 >= 734) and ( pposX + 25 <= 920)) and ((pposY - 26 >= 886) and (pposY - 26 <= 1004)))
								or (((pposX - 25 >= 734) and ( pposX + 25 <= 920)) and ((pposY - 26 >= 604) and (pposY - 26 <= 876)))
								or (((pposX - 25 >= 916) and ( pposX + 25 <= 1108)) and ((pposY - 26 >= 750) and (pposY - 26 <= 1004)))
								or (((pposX - 25 >= 916) and ( pposX + 25 <= 1108)) and ((pposY - 26 >= 166) and (pposY - 26 <= 594)))
								or (((pposX - 25 >= 916) and ( pposX + 25 <= 1260)) and ((pposY - 26 >= 604) and (pposY - 26 <= 740)))
								or (((pposX - 25 >= 916) and ( pposX + 25 <= 1260)) and ((pposY - 26 >= 166) and (pposY - 26 <= 302)))
								or (((pposX - 25 >= 1098) and ( pposX + 25 <= 1260)) and ((pposY - 26 >= 166) and (pposY - 26 <= 740)))
								or (((pposX - 25 >= 1098) and ( pposX + 25 <= 1260)) and ((pposY - 26 >= 750) and (pposY - 26 <= 1004)))
								then
								prevy := pposY;
									pposY := (pposY-1);
						
							
						counter <= (others => '0');        
					end if;
					end if;
				if (room = 1) then
							if	(((pposX - 25 >= 20) and ( pposX + 25 <= 169)) and ((pposY - 26 <= 137) and (pposY - 26 >= 20))) 
								or (((pposX - 25 >= 20) and ( pposX + 25 <= 169)) and ((pposY - 26 >= 147) and (pposY - 26 <= 518)))
								or (((pposX - 25 >= 20) and ( pposX + 25 <= 1260)) and ((pposY - 26 >= 20) and (pposY -26 <= 137)))
								or (((pposX - 25 >= 20) and ( pposX + 25 <= 169)) and ((pposY - 26 >= 528) and (pposY - 26 <= 1016)))

								or (((pposX - 25 >= 169) and ( pposX + 25 <= 328)) and ((pposY - 26 <= 137)and (pposY -26 >=20)))
								or (((pposX - 25 >= 169) and ( pposX + 25 <= 328)) and ((pposY - 26 >= 147) and (pposY - 26 <= 391)))
								or (((pposX - 25 >= 169) and ( pposX + 25 <= 328)) and ((pposY - 26 >= 401) and (pposY - 26 <= 645)))
								or (((pposX - 25 >= 169) and ( pposX + 25 <= 328)) and ((pposY - 26 >= 655) and (pposY - 26 <= 899)))
								or (((pposX - 25 >= 169) and ( pposX + 25 <= 328)) and ((pposY - 26 >= 909) and (pposY - 26 <= 1016)))
								
								or (((pposX - 25 >= 328) and ( pposX + 25 <= 487)) and ((pposY - 26 >= 20) and (pposY - 26 <= 264)))
								or (((pposX - 25 >= 328) and ( pposX + 25 <= 487)) and ((pposY - 26 >= 274) and (pposY - 26 <= 645)))
								or (((pposX - 25 >= 328) and ( pposX + 25 <= 487)) and ((pposY - 26 >= 655) and (pposY - 26 <= 772)))
								or (((pposX - 25 >= 328) and ( pposX + 25 <= 487)) and ((pposY - 26 >= 782) and (pposY - 26 <= 1016)))
								
								or (((pposX - 25 >= 487) and ( pposX + 25 <= 646)) and ((pposY - 26 >= 20) and (pposY - 26 <= 264)))
								or (((pposX - 25 >= 487) and ( pposX + 25 <= 646)) and ((pposY - 26 >= 274) and (pposY - 26 <= 645)))
								or (((pposX - 25 >= 487) and ( pposX + 25 <= 646)) and ((pposY - 26 >= 655) and (pposY - 26 <= 772)))
								or (((pposX - 25 >= 487) and ( pposX + 25 <= 646)) and ((pposY - 26 >= 782) and (pposY - 26 <= 1016)))
								
								or (((pposX - 25 >= 646) and ( pposX + 25 <= 805)) and (pposY - 26 <= 137))
								or (((pposX - 25 >= 646) and ( pposX + 25 <= 805)) and ((pposY - 26 >= 147) and (pposY - 26 <= 391)))
								or (((pposX - 25 >= 646) and ( pposX + 25 <= 805)) and ((pposY - 26 >= 401) and (pposY - 26 <= 518)))
								or (((pposX - 25 >= 646) and ( pposX + 25 <= 805)) and ((pposY - 26 >= 528) and (pposY - 26 <= 772)))
								or (((pposX - 25 >= 646) and ( pposX + 25 <= 805)) and ((pposY - 26 >= 782) and (pposY - 26 <= 1016)))
								
								or (((pposX - 25 >= 805) and ( pposX + 25 <= 964)) and ((pposY - 26 >= 20) and (pposY - 26 <= 391)))
								or	(((pposX - 25 >= 805) and ( pposX + 25 <= 964)) and ((pposY - 26 >= 401) and (pposY - 26 <= 645)))
								or (((pposX - 25 >= 805) and ( pposX + 25 <= 964)) and ((pposY - 26 >= 655) and (pposY - 26 <= 1016)))
								
								or (((pposX - 25 >= 964) and ( pposX + 25 <= 1123)) and ((pposY - 26 <= 137)))
								or (key = 1 and (((pposX - 25 >= 964) and ( pposX + 25 <= 1123)) and ((pposY - 26 >= 147) and (pposY - 26 <= 645))))
								or (key = 0 and (((pposX - 25 >= 964) and ( pposX + 25 <= 1123)) and ((pposY - 26 >= 274) and (pposY - 26 <= 645))))
								or (((pposX - 25 >= 964) and ( pposX + 25 <= 1123)) and ((pposY - 26 >= 655) and (pposY - 26 <= 1016)))
								
								or (((pposX - 25 >= 1123) and ( pposX + 25 <= 1260)) and ((pposY - 26 >= 20) and (pposY - 26 <= 1016)))
								
								then
									prevy := pposY;
									pposY := (pposY-1);
						
								
								counter <= (others => '0'); 
								end if;
							end if;
				end if;
			end if;
						
		ELSE								--BLACK SCREEN
			red <= (OTHERS => '0');
			green <= (OTHERS => '0');
			blue <= (OTHERS => '0');
		END IF; 
	end IF;
	
	
	
--GOAL COLLISION
if (room = 0) then
	if (pposX < 1260 and pposX > 1098 and pposY = 878) then
		room := 1;
		reset1 <= '1';
--		pposX := 250;
--		pposY := 35;
	end if;
	--reset1 <= '0';
end if;
--	if (key = 1) then
--		if (pposX < 1260 and pposX > 1098 and pposY = 878) then
--			key := 0;
--	end if;
--end if;
		
	END PROCESS;

END behavior;