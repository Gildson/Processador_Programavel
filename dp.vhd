-- datapath for microprocessor
library IEEE;
use IEEE.std_logic_1164.all;

entity dp is
  port (rst_dp    : in STD_LOGIC;
        clk_dp  : in STD_LOGIC;
        input_dp     : in std_logic_vector(3 downto 0);
        alu_st_in: in std_LOGIC_VECTOR (3 downto 0)
	rf_sel_dp: out std_LOGIC;
	rf_enb_dp: out std_LOGIC;
	acc_enb_dp: out std_LOGIC;
	output_dp: out STD_LOGIC_VECTOR (3 downto 0)
        );
end dp;

architecture rtl2 of dp is

component alu is
  port (rst   : in STD_LOGIC;
        clk   : in STD_LOGIC;
        imm   : in std_logic_vector(3 downto 0);
        output: out STD_LOGIC_VECTOR (3 downto 0)
         -- add ports as required
        );
end component;

component acc is
  port (rst   : in STD_LOGIC;
        clk   : in STD_LOGIC;
        input : in STD_LOGIC_VECTOR (3 downto 0);
        enb   : in STD_LOGIC;
        output: out STD_LOGIC_VECTOR (3 downto 0)
        );
end component;

component rf is
  port (rst    : in STD_LOGIC;
        clk    : in STD_LOGIC;
        input  : in std_logic_vector(3 downto 0);
        sel    : in std_logic_vector(1 downto 0);
        enb    : in std_logic;
        output : out std_logic_vector(3 downto 0)
        );
end component;

-- maybe we should add the other components here......

signal alu_out: std_logic_vector(3 downto 0);
-- maybe we should add signals for interconnections here.....

begin
	alu1: alu port map (rst,clk,imm,alu_out);
	-- maybe this is were we add the port maps for the other components.....

	process (rst, clk)
		begin

			-- this you should change so the output actually
			-- comes from the accumulator so it follows the
			-- instruction set. since the accumulator is always 
			-- involved we want to be able to see the
			-- results/data changes on the acc.

			-- take care of reset state
		  
			output_4 <= alu_out;
		
   end process;
end rtl2;
