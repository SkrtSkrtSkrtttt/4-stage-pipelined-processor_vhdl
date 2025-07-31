

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE work.ALL;		   

						

entity IB_FWDreg is
 
  port (
   clk        : in std_logic;
   reset_bar  : in std_logic; 
   
IB_opcode : in STD_LOGIC_VECTOR(24 downto 0);	 
valid_in_flag: in std_logic;
valid_out_flag: out std_logic;
  

  IBfwd_opcode: out STD_LOGIC_VECTOR(24 downto 0)
  
  );		
  
  
end entity IB_FWDreg;

architecture Behavioral of IB_FWDreg is	  
	

begin
	
	
	
	
 process(clk, reset_bar)											 
  begin
    if reset_bar = '0' then
	
		IBfwd_opcode <= (others => '0');

    elsif (clk = '1') then
		
		
		if 	(valid_in_flag = '1' ) then
		
			IBfwd_opcode <= IB_opcode;	 
			valid_out_flag <= '1';
		else 
			IBfwd_opcode <= (others => '0');
			valid_out_flag <= '0';	
		end if;
		

    end if;
  end process;	
	
	
	
	
end architecture Behavioral;



			  