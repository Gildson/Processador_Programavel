--****************************************************
--Acumulador
--****************************************************

library IEEE;
use IEEE.std_logic_1164.all;

entity acc is
  port (rst_acc   : in STD_LOGIC;
        clk_acc   : in STD_LOGIC;
        input_acc : in STD_LOGIC_VECTOR (3 downto 0);
        enb_acc   : in STD_LOGIC;
        output_acc: out STD_LOGIC_VECTOR (3 downto 0)
        );
end acc;

architecture bhv of acc is

signal temp : STD_LOGIC_VECTOR(3 downto 0);

begin

	process (rst_acc, input_acc, enb_acc, clk_acc)
	begin
	
		if (rst_acc = '1') then
			output_acc <= "0000";
			temp <= "0000";
			
		elsif (clk_acc'event and clk_acc = '1') then
		
				if (enb_acc = '1') then 
					output_acc <= input_acc;
					temp <= input_acc;
					
				else
					output_acc <= temp;
					
				end if;
				
		end if;
		
	end process;
	
end bhv;