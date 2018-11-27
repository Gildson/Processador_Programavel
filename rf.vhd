library IEEE;
use IEEE.std_logic_1164.all;

entity rf is
  port (rst_rf    : in STD_LOGIC;
        clk_rf    : in STD_LOGIC;
        input_rf  : in std_logic_vector(3 downto 0);  --informaçao a ser gravada
        sel_rf    : in std_logic_vector(1 downto 0);  --registrador escolhido
        enb_rf    : in std_logic;  -- "0" habilita a escrita e "1" habilita a leitura
        output_rf : out std_logic_vector(3 downto 0)   --informaçao já gravada
        );	
end rf;

architecture bhv of rf is
signal out0, out1, out2, out3 : std_logic_vector(3 downto 0);
begin
	process (rst_rf, clk_rf)
	begin
		if (rst_rf = '1') then
			out0 <= "0000";
			out1 <= "0000";
			out2 <= "0000";
			out3 <= "0000";
			output_rf <= "0000";
	  
	  elsif(clk_rf'event and clk_rf = '1')then
		 if enb_rf = '0' then
			case (sel_rf) is
			  when "00" => 
				 out0 <= input_rf;
			  when "01" => 
				 out1 <= input_rf;
			  when "10" => 
				 out2 <= input_rf;
			  when "11" =>
				 out3 <= input_rf;
			  when others =>
			end case;
		 else
			case (sel_rf) is
			  when "00" =>
				 output_rf <= out0;
			  when "01" =>
				 output_rf <= out1;
			  when "10" =>
				 output_rf <= out2;
			  when "11" =>
				 output_rf <= out3;
			  when others =>
			end case;
		 end if;
	  end if;
	end process;	
end bhv;