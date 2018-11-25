-- cpu (top level entity)
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

-- these should probably stay the same
entity cpu is
   port (rst_cpu: in STD_LOGIC;
    	 start_cpu: in STD_LOGIC;
         clk_cpu: in STD_LOGIC;
	 output_cpu: out STD_LOGIC_VECTOR (3 downto 0);
       	 a,b,c,d,e,f,g: out std_logic
	);
end cpu;

-- these will change as your design grows
architecture struc of cpu is
component ctrl 
  port (rst_ctrl   : in STD_LOGIC;
        start_ctrl : in STD_LOGIC;
        clk_ctrl   : in STD_LOGIC;       
        imm   : out std_logic_vector(3 downto 0);
	alu_st_ctrl		: out std_logic_vector(3 downto 0);
	rf_sel_ctrl		: out std_logic_vector(1 downto 0);
	rf_enb_ctrl		: out std_logic;
	acc_enb_ctrl	: out std_logic;
	output_ctrl 	: out std_logic_vector(3 downto 0)
        );
end component;

component dp
  port (rst_dp    : in STD_LOGIC;
        clk_dp  : in STD_LOGIC;
        input_dp     : in std_logic_vector(3 downto 0);
        alu_st_in: in std_LOGIC_VECTOR (3 downto 0)
	rf_sel_dp: out std_LOGIC;
	rf_enb_dp: out std_LOGIC;
	acc_enb_dp: out std_LOGIC;
	output_dp: out STD_LOGIC_VECTOR (3 downto 0)
        );
end component;

signal immediate : std_logic_vector(3 downto 0);
signal cpu_out : std_logic_vector(3 downto 0);
signal output_ctrl_out 		:  std_logic_vector(3 downto 0);	
signal alu_st_ctrl_out 		:  std_logic_vector(3 downto 0); 
signal rf_sel_ctrl_out 		:  std_logic_vector(1 downto 0);   
signal rf_enb_ctrl_out 		:  std_logic;						  
signal acc_enb_ctrl_out 	:  std_logic;

begin

-- notice how the output from the datapath is tied to a signal
-- this output signal is then used as input for a decoder.
-- we can also see the output as "output".
-- the output from the datapath should be coming from the accumulator.
-- this is because all actions take place on the accumulator, including
-- all results of any alu operation. naturally, this is because of the 
-- nature of the instruction set.

  controller: ctrl port map(rst_cpu, start_cpu, clk_cpu, immediate, alu_st_ctrl_out, rf_sel_ctrl_out, rf_enb_ctrl_out, acc_enb_ctrl_out, cpu_out);
  datapath: dp port map(rst_cpu, clk_cpu, immediate, alu_st_ctrl_out, rf_sel_ctrl_out, rf_enb_ctrl_out, acc_enb_ctrl_out, cpu_out);


  process(rst, clk, cpu_out)
  begin

    -- take care of rst case here

    if(clk'event and clk='1') then
    output <= cpu_out;
    -- this acts like a BCD to 7-segment decoder,
    -- can see output in waveforms as cpu_out
       case cpu_out is
         when "0000" =>
          a <= '0'; 
	  b <= '0'; 
	  c <= '0'; 
	  d <= '0'; 
          e <= '0'; 
	  f <= '0'; 
	  g <= '1';
         when "0001" =>
          a <= '1'; 
	  b <= '0'; 
	  c <= '0'; 
	  d <= '1'; 
          e <= '1'; 
	  f <= '1'; 
	  g <= '1';
         when "0010" =>
	  a <= '0'; 
	  b <= '0'; 
	  c <= '1'; 
	  d <= '0'; 
          e <= '0'; 
	  f <= '1'; 
	  g <= '0';
         when "0011" =>
          a <= '0'; 
	  b <= '0'; 
	  c <= '0'; 
	  d <= '0'; 
          e <= '1'; 
	  f <= '1'; 
	  g <= '0';
         when "0100" =>
          a <= '1'; 
	  b <= '0'; 
	  c <= '0'; 
	  d <= '1'; 
          e <= '1'; 
	  f <= '0'; 
	  g <= '0';
         when "0101" =>
          a <= '0'; 
	  b <= '1'; 
	  c <= '0'; 
	  d <= '0'; 
          e <= '1'; 
	  f <= '0'; 
	  g <= '0';
         when "0110" =>
          a <= '0'; 
	  b <= '1'; 
	  c <= '0'; 
	  d <= '0'; 
          e <= '0'; 
	  f <= '0'; 
	  g <= '0';
         when "0111" =>
          a <= '0'; 
	  b <= '0'; 
	  c <= '0'; 
	  d <= '1'; 
          e <= '1'; 
	  f <= '1'; 
	  g <= '1';
         when "1000" =>
          a <= '0'; 
	  b <= '0'; 
	  c <= '0'; 
	  d <= '0'; 
          e <= '0'; 
	  f <= '0'; 
	  g <= '0';
         when "1001" =>
          a <= '0'; 
	  b <= '0'; 
	  c <= '0'; 
	  d <= '0'; 
          e <= '0'; 
	  f <= '1'; 
	  g <= '0';
         when others =>
       end case;
    end if;
  end process;							
end struc;
