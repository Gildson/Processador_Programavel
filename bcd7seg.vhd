library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity bcd7seg is
 port (instrucoes: in std_logic_vector (3 downto 0);
		 hex3, hex2, hex1, hex0: out std_logic_vector (6 downto 0)
		 );
end bcd7seg;

architecture bhv of bcd7seg is

	constant mova: std_logic_vector(3 downto 0) := "0000";
	constant movr: std_logic_vector(3 downto 0) := "0001";
	constant load: std_logic_vector(3 downto 0) := "0010";
	constant add: std_logic_vector(3 downto 0) := "0011";
   constant sub: std_logic_vector(3 downto 0) := "0100";
	constant andr: std_logic_vector(3 downto 0) := "0101";
   constant orr: std_logic_vector(3 downto 0) := "0110";
   constant inv: std_logic_vector(3 downto 0) := "1000";

begin
	process (instrucoes)
	begin
	case instrucoes is
		when mova =>
			hex3 <= "0000001";
			hex2 <= "0000001";
			hex1 <= "0000001";
			hex0 <= "0000001";
		when movr =>
			hex3 <= "0000001";
			hex2 <= "0000001";
			hex1 <= "0000001";
			hex0 <= "1001111";
		when load =>
			hex3 <= "0000001";
			hex2 <= "0000001";
			hex1 <= "1001111";
			hex0 <= "0000001";
		when add =>
			hex3 <= "0000001";
			hex2 <= "0000001";
			hex1 <= "1001111";
			hex0 <= "1001111";
		when sub =>
			hex3 <= "0000001";
			hex2 <= "1001111";
			hex1 <= "0000001";
			hex0 <= "1001111";
		when andr =>
			hex3 <= "0000001";
			hex2 <= "1001111";
			hex1 <= "1001111";
			hex0 <= "0000001";
		when orr =>
			hex3 <= "0000001";
			hex2 <= "1001111";
			hex1 <= "1001111";
			hex0 <= "1001111";
		when inv =>
			hex3 <= "1001111";
			hex2 <= "0000001";
			hex1 <= "0000001";
			hex0 <= "1001111";
		when others =>
	end case;
	end process;
end bhv;
		
		
		
		