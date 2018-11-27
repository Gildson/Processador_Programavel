--***********************************************************
-- Bloco de controle
--***********************************************************
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity ctrl is
  port (rst_ctrl   : in STD_LOGIC;
        start_ctrl : in STD_LOGIC;
        clk_ctrl   : in STD_LOGIC;       
		  alu_sct_ctrl		: out std_logic_vector(3 downto 0);
		  rf_sel_ctrl		: out std_logic_vector(1 downto 0);
		  rf_enb_ctrl		: out std_logic;
		  acc_enb_ctrl	: out std_logic;
		  output_ctrl 	: out std_logic_vector(3 downto 0)
        );
end ctrl;

architecture fsm of ctrl is

  type state_type is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,done);
  signal state : state_type; 		
	
	--açoes do processador
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
	
	-- instruçoes do processador
	-- cada instruçao acrescentada devesse aumentar o numero do array
	type PM_BLOCK is array (0 to 7) of std_logic_vector(7 downto 0);
	constant PM : PM_BLOCK := (	

	-- Instruçoes do processador
      "00100101", --	load :  acc = 5
		"00010000", --	movr :	r[00] = 5
		"00100011", --	load :  acc = 3
		"00010100", --	movr :	r[01] = 3
		"00110000", --	add  :	acc = 3 + 5
		"00010000", --	movr :	r[00] = 8
		"10000000", --	inv  :  acc = not(acc)
		"01101000" --	or   :	acc = acc or r[10]
     );
	  
begin
	process (rst_ctrl, clk_ctrl)
	-- these variables declared here don't change.
	-- these are the only data allowed inside
	-- our otherwise pure FSM
  
	variable IR : std_logic_vector(7 downto 0);
	variable OPCODE : std_logic_vector( 3 downto 0);
	variable ADDRESS : std_logic_vector (3 downto 0);
	variable PC : integer;
    
	begin
		if (rst_ctrl = '1') then
			state <= s0;
    
		elsif (clk_ctrl'event and clk_ctrl = '1') then			
    
      case (state) is
        
        when s0 =>    -- estado inicial
          PC := 0;  --inicializa as instruçoes
          if start_ctrl = '1' then
            state <= s1;
          else 
            state <= s0;
          end if;
          
        when s1 =>				-- busca as instruçoes
          IR := PM(PC);
          OPCODE := IR(7 downto 4);  --ação
          ADDRESS:= IR(3 downto 0);  
          state <= s2;
          
        when s2 =>				-- incrementa o PC
          PC := PC + 1;
          state <= s3;
			
		  when s3 =>   -- codifica os estados da FSM
		  
		  		case (OPCODE) IS
					when mova 	=> state <= s4;
					when movr	=> state <= s5;         
					when load 	=> state <= s6;                                               
					when add  	=> state <= s7;			         
					when sub  	=> state <= s8;
					when andr 	=> state <= s9;
					when orr  	=> state <= s10;
					when jmp  	=> state <= s11;
					when inv  	=> state <= s12;
					when halt 	=> state <= s13;
					when others => state <= done;
				end case;
          
        when s4 =>		--acc = r[]		
				acc_enb_ctrl <= '1';    --habilita o acumulador
				rf_enb_ctrl  <= '0';    --habilita a escrita de dados no registrador
				alu_sct_ctrl  <= mova;  --Diz a Alu o que deve ser feito
				rf_sel_ctrl  <= ADDRESS(3 downto 2);  -- 1 e 0 serão carregados com 00
				state  <= s1;
				
        when s5 =>    --r[] = acc
				acc_enb_ctrl <= '0';  --desabilita o acumulador
				rf_enb_ctrl  <= '1';  --habilita a leitura de dado do registrador (rf)
				alu_sct_ctrl  <= movr;   --Diz a Alu o que deve ser feito
				rf_sel_ctrl  <= ADDRESS(3 downto 2);  --passado para o rf
				state <= s1;
					
			when s6 =>    --acc = immediate
				output_ctrl  <= ADDRESS;
				acc_enb_ctrl <= '1';   --habilita o acumulador
				rf_enb_ctrl  <= '0';   --habilita a escrita de dados no registrador
				alu_sct_ctrl  <= load; --Diz a Alu o que deve ser feito
				rf_sel_ctrl  <= ADDRESS(3 downto 2);
				state <= s1;

			when s7 =>   --acc = acc + r[]
				acc_enb_ctrl <= '1';    --habilita o acumulador
				rf_enb_ctrl  <= '0';		--habilita a escrita de dados no registrador			 
				alu_sct_ctrl  <= add;   --Diz a Alu o que deve ser feito
				rf_sel_ctrl  <= ADDRESS(3 downto 2);
				state <= s1;	

			when s8 =>    --acc = acc - r[]
				acc_enb_ctrl <= '1';    --habilita o acumulador
				rf_enb_ctrl  <= '0';		--habilita a escrita de dados no registrador			 
				alu_sct_ctrl  <= sub;	--Diz a Alu o que deve ser feito
				rf_sel_ctrl  <= ADDRESS(3 downto 2);
				state <= s1;

			when s9 =>   -- acc = acc AND r[]
				acc_enb_ctrl <= '1';   --habilita o acumulador
				rf_enb_ctrl  <= '0';   --habilita a escrita de dados no registrador
				alu_sct_ctrl  <= andr; --Diz a Alu o que deve ser feito
				rf_sel_ctrl  <= ADDRESS(3 downto 2);
				state <= s1;
					
			when s10 =>   -- acc = acc OR r[]
				acc_enb_ctrl <= '1';    --habilita o acumulador
				rf_enb_ctrl  <= '0';    --habilita a escrita de dados no registrador
				alu_sct_ctrl  <= orr;   --Diz a Alu o que deve ser feito
				rf_sel_ctrl  <= ADDRESS(3 downto 2);
				state <= s1;
					
			when s11 =>   --PC = ADDRESS
				acc_enb_ctrl <= '0';    --desabilita o acumulador
				rf_enb_ctrl  <= '0';    --habilita a escrita de dados no registrador
				PC 	  		 := conv_integer(unsigned(ADDRESS));
				alu_sct_ctrl  <= jmp;   --Diz a Alu o que deve ser feito
				rf_sel_ctrl  <= ADDRESS(3 downto 2);
				state   <= s1;
					
			when s12 =>   --acc = NOTacc
				acc_enb_ctrl <= '0';    --desabilita o acumulador
				rf_enb_ctrl	 <= '0';    --habilita a escrita de dados no registrador
				alu_sct_ctrl  <= inv;   --Diz a Alu o que deve ser feito
				rf_sel_ctrl  <= ADDRESS(3 downto 2);
				state <= s1;
					
			when s13 =>  --stop execution
				acc_enb_ctrl <= '0';    --desabilita o acumulador
				rf_enb_ctrl	 <= '0';    --habilita a escrita de dados no registrador
				state <=done;
				
         when others =>
            state <= done;
				
      end case;
		
    end if;
	 
  end process;	
  
end fsm;