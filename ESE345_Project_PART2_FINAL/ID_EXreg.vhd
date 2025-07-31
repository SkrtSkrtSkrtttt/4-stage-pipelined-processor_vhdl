

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.ALL;		


						
entity ID_EXreg is
 
  port (
   clk        : in std_logic;
   reset_bar  : in std_logic; 
  
  RF_rs1   : in STD_LOGIC_VECTOR(127 downto 0);	
  RF_rs2   : in STD_LOGIC_VECTOR(127 downto 0);
  RF_rs3   : in STD_LOGIC_VECTOR(127 downto 0);
  
  RF_opcode : in STD_LOGIC_VECTOR(24 downto 0);
  
  IDfwd_rs1  : out STD_LOGIC_VECTOR(127 downto 0);
  IDfwd_rs2  : out STD_LOGIC_VECTOR(127 downto 0);
  IDfwd_rs3  : out STD_LOGIC_VECTOR(127 downto 0);
  valid_in_flag: in std_logic;
  valid_out_flag: out std_logic;
  
  IDfwd_opcode: out STD_LOGIC_VECTOR(24 downto 0)
  
  );		
  
  
end entity ID_EXreg;

architecture Behavioral of ID_EXreg is	  


	signal RF_rs1_previous :  STD_LOGIC_VECTOR(127 downto 0);
	signal RF_rs2_previous :  STD_LOGIC_VECTOR(127 downto 0) ;
	signal RF_rs3_previous :  STD_LOGIC_VECTOR(127 downto 0) ;
	signal RF_opcode_previous :  STD_LOGIC_VECTOR(24 downto 0);
	
	

begin
	
	
	
	
 process(clk, reset_bar)											 
  begin
     if reset_bar = '0' then
      
		IDfwd_rs1 <= (others => '0');	
		IDfwd_rs2 <= (others => '0');
		IDfwd_rs3 <= (others => '0');
		IDfwd_opcode <= (others => '0');
		RF_rs1_previous <=  (others => '0');
		RF_rs2_previous <=  (others => '0');
		RF_rs3_previous <=  (others => '0');
		RF_opcode_previous <=  (others => '0');
		
		
		
    elsif (clk = '1') then
		
		
		if (valid_in_flag ='1') then 
		IDfwd_rs1 <= RF_rs1; 
		IDfwd_rs2 <= RF_rs2;
		IDfwd_rs3 <= RF_rs3;
		IDfwd_opcode <= RF_opcode;	
		valid_out_flag <= '1';

		
		else 
		   
				valid_out_flag <= '0';	
		
			end if;

    end if;
  end process;	
	
	
	
	
end architecture Behavioral;
