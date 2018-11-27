-- datapath for microprocessor
library IEEE;
use IEEE.std_logic_1164.all;

entity dp is
  port (rst_dp: in STD_LOGIC;
        clk_dp: in STD_LOGIC;
        input_dp: in std_logic_vector(3 downto 0);
        alu_sct_dp: in std_LOGIC_VECTOR (3 downto 0);
		  rf_sel_dp: in std_LOGIC_VECTOR (1 downto 0);
		  rf_enb_dp: in std_LOGIC;
		  acc_enb_dp: in std_LOGIC;
		  output_dp: out STD_LOGIC_VECTOR (3 downto 0)
        );
end dp;

architecture rtl2 of dp is

component alu is
  port (rst_alu: in STD_LOGIC;
        clk_alu: in STD_LOGIC;
		  input_a_alu: in std_LOGIC_VECTOR (3 downto 0);
		  input_b_alu: in std_LOGIC_VECTOR (3 downto 0);
		  slct_alu: in std_LOGIC_VECTOR (3 downto 0);
        output_alu: out STD_LOGIC_VECTOR (3 downto 0)
        );
end component;

component acc is
  port (rst_acc: in STD_LOGIC;
        clk_acc: in STD_LOGIC;
        input_acc: in STD_LOGIC_VECTOR (3 downto 0);
        enb_acc: in STD_LOGIC;
        output_acc: out STD_LOGIC_VECTOR (3 downto 0)
        );
end component;

component rf is
  port (rst_rf: in STD_LOGIC;
        clk_rf: in STD_LOGIC;
        input_rf: in std_logic_vector(3 downto 0);
        sel_rf: in std_logic_vector(1 downto 0);
        enb_rf: in std_logic;
        output_rf: out std_logic_vector(3 downto 0)
        );	
end component;

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

signal input_a_alu: std_logic_vector(3 downto 0) := "0000";
signal input_b_alu: std_logic_vector(3 downto 0) := "0000";
signal alu_output: std_logic_vector(3 downto 0) := "0000";
signal rf_input: std_logic_vector(3 downto 0) := "0000";
signal acc_input: std_logic_vector(3 downto 0) := "0000";
signal rf_output: std_logic_vector(3 downto 0) := "0000";
signal acc_output: std_logic_vector(3 downto 0) := "0000";

begin
	acumulador: acc port map (rst_dp, clk_dp, acc_input, acc_enb_dp, acc_output);
	alu1: alu port map (rst_dp,clk_dp, input_a_alu, input_b_alu, alu_sct_dp, alu_output);
	rf1: rf port map (rst_dp, clk_dp, rf_input, rf_sel_dp, rf_enb_dp, rf_output);

		process (rst_dp, clk_dp, input_a_alu, input_b_alu, alu_sct_dp, alu_output, rf_input, rf_sel_dp, rf_enb_dp, rf_output, acc_input, acc_enb_dp, acc_output)
			begin
				if(rst_dp = '1') then
					output_dp <= "0000";
				elsif (clk_dp'event and clk_dp = '0') then
					case alu_sct_dp is	
						when mova =>
							input_b_alu <= rf_output;
							acc_input  <= alu_output;
							output_dp <= alu_output;
						when movr =>
							rf_input <= acc_output;
							input_a_alu <= rf_input;
							output_dp <= alu_output;
						when load =>
							input_b_alu <= input_dp;
							acc_input  <= alu_output;
							output_dp <= alu_output;						
						when add =>
							input_a_alu <= acc_output;
							input_b_alu <= rf_output;
							acc_input  <= alu_output;
							output_dp <= alu_output;
						when sub =>
							input_a_alu <= acc_output;
							input_b_alu <= rf_output;
							acc_input  <= alu_output;
							output_dp <= alu_output;						
						when andr =>
							input_a_alu <= acc_output;
							input_b_alu <= rf_output;
							acc_input  <= alu_output;
							output_dp <= alu_output;							
						when orr =>
							input_a_alu <= acc_output;
							input_b_alu <= rf_output;
							acc_input  <= alu_output;
							output_dp <= alu_output;							
						when inv =>
							input_a_alu   <= acc_output;
							acc_input    <= alu_output;
							output_dp <= alu_output;
						when others =>
							output_dp <= acc_output;
					end case;
				end if;
		end process;
end rtl2;