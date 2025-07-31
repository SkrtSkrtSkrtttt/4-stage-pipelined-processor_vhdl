library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.ALL;		   


entity EX_WBreg is
 
  port (
   clk        : in std_logic;
    reset_bar  : in std_logic; 
  
  alu_rddata_in   : in STD_LOGIC_VECTOR(127 downto 0);	
  alu_opcodedata_in : in STD_LOGIC_VECTOR(24 downto 0);
  
  alu_rddata_out  : out STD_LOGIC_VECTOR(127 downto 0);
  valid_in_flag: in std_logic;
valid_out_flag: out std_logic;
valid_out_flag_FWD: out std_logic;
  write_enable     : out std_logic;
  alu_opcodedata_out: out STD_LOGIC_VECTOR(24 downto 0)
  
  );		    
  
  
end entity EX_WBreg;

architecture Behavioral of EX_WBreg is	 

signal ALU_rd_previous :  STD_LOGIC_VECTOR(127 downto 0) :=  (others => '0');
signal ALU_opcode_previous :  STD_LOGIC_VECTOR(24 downto 0) :=  (others => '0'); 

begin
	
	
 process(clk, reset_bar, valid_in_flag, alu_opcodedata_in, alu_rddata_in)
  begin
    if reset_bar = '0' then
      
		alu_rddata_out <= (others => '0');
		alu_opcodedata_out <= (others => '0');
		
		
    elsif (clk = '1') then
		
		 if (valid_in_flag ='1') then 
		
			 valid_out_flag <= '1';
			 valid_out_flag_FWD <= '1';
			 if not (alu_rddata_in(127) = 'U' or alu_opcodedata_in(24) = 'U') then
  alu_rddata_out <= alu_rddata_in;
  alu_opcodedata_out <= alu_opcodedata_in;
  write_enable <= '1';
  
  			else
	  
  
			end if;
			
			else 
		   
				valid_out_flag <= '0';	
		
			end if;	


	elsif  (clk = '0') then
		   

		write_enable <= '0';
		
	else
		null;
		
		
		
    end if;
	
if (valid_in_flag = '0') then	
			 
			 valid_out_flag <= '0';
			 
		  else
		  end if;	
	
	
  end process;	
	
	
	
end architecture Behavioral;


		   