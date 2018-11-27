--***********************************************
--Alu (Unidade Lógica Aritmetrica)
--***********************************************

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity alu is
  port (rst_alu:     in STD_LOGIC;
        clk_alu:     in STD_LOGIC;
		  input_a_alu: in std_LOGIC_VECTOR (3 downto 0);
		  input_b_alu: in std_LOGIC_VECTOR (3 downto 0);
		  slct_alu:    in std_LOGIC_VECTOR (3 downto 0);
        output_alu:  out STD_LOGIC_VECTOR (3 downto 0)
        );
end alu;

architecture bhv of alu is

	constant mova: std_logic_vector(3 downto 0) := "0000";
	constant movr: std_logic_vector(3 downto 0) := "0001";
	constant load: std_logic_vector(3 downto 0) := "0010";
	constant add: std_logic_vector(3 downto 0) := "0011";
   constant sub: std_logic_vector(3 downto 0) := "0100";
	constant andr: std_logic_vector(3 downto 0) := "0101";
   constant orr: std_logic_vector(3 downto 0) := "0110";
   constant jmp: std_logic_vector(3 downto 0) := "0111";
	constant inv: std_logic_vector(3 downto 0) := "1000";
	constant halt: std_logic_vector(3 downto 0) := "1001";

	signal intA: integer;
	signal intB: integer;
	signal intC: integer;
	
begin
	process (rst_alu, clk_alu)
	begin
		if (rst_alu = '1') then
			output_alu <= "0000";
		elsif (clk_alu'event and clk_alu = '1') then
		--A açao jmp é implementada diretamente no bloco de controle, devido a mesma, receber o endereço corrente
		--e tranformar no número referente a instruçao do processador.
			case (slct_alu) is
			
				when mova =>
					output_alu <= input_b_alu;
					
				when movr =>
					output_alu <= input_a_alu;
					
				when load =>
					output_alu <= input_b_alu;
					
				when add =>
					intA <= conv_integer(input_a_alu);
					intB <= conv_integer(input_b_alu);
					intC <= intA + intB;
					output_alu <= conv_std_logic_vector(intC, 4);
					
				when sub =>
					intA <= conv_integer(input_a_alu);
					intB <= conv_integer(input_b_alu);
					intC <= intA - intB;
					output_alu <= conv_std_logic_vector(intC, 4);
					
				when andr =>
					output_alu <= input_a_alu and input_b_alu;
					
				when orr =>
					output_alu <= input_a_alu or input_b_alu;
					
				when inv =>
					output_alu <= not(input_a_alu);
					
				when halt =>
					output_alu <= "1111";
					
				when others =>
				
			end case;
			
		end if;
		
	end process;
	
end bhv;