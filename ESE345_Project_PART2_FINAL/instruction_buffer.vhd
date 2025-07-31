library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_buffer is
    port (
        INSTRUCTION_IN: in std_logic_vector(24 downto 0);
        instruction_number: in std_logic_vector(6 downto 0); 
		Current_PC_Count: out std_logic_vector(5 downto 0);
		ProgramMemory_OUT: out std_logic_vector(1650 downto 0);
        hold, reset_bar, clk: in std_logic;
		finish,IB_empty: out std_logic;
		valid_out_flag: out std_logic;
        next_opcode: out std_logic_vector(24 downto 0) 
		
    );
end instruction_buffer;	


architecture ib_arch of instruction_buffer is
    signal ProgramMemory: std_logic_vector(1650 downto 0);
    signal PC, PC_max: integer := 0;
 	

begin
    process(clk, reset_bar, INSTRUCTION_IN, instruction_number, hold)
	
	variable PM_START_REPLACE_BT, PM_endd_REPLACE_BT: natural := 0;
	variable instruction : std_logic_vector(24 downto 0);
    begin
        if reset_bar = '0' then
           
            ProgramMemory <= (others => '0');
            PC <= 0;
            PC_max <= 0;
            next_opcode <= (others => '0');
            finish <= '0';
            IB_empty <= '0';
        elsif (clk = '1') then
            if hold = '1' then
			   
                PM_START_REPLACE_BT := 25 * to_integer(unsigned(instruction_number(6 downto 0)));
                PM_endd_REPLACE_BT := 24 + (25 * to_integer(unsigned(instruction_number(6 downto 0))));
				
				 for i in 0 to 24 loop
      				instruction(i) := INSTRUCTION_IN(24 - i);
    			 end loop;	 
				 		   
                ProgramMemory(PM_endd_REPLACE_BT downto PM_START_REPLACE_BT) <= instruction(24 downto 0);

                if PC_max = 0 then 
                    PC_max <= to_integer(unsigned(instruction_number(6 downto 0)));
                else
                    if to_integer(unsigned(instruction_number(6 downto 0))) > PC_max then	   
                        PC_max <= (to_integer(unsigned(instruction_number(6 downto 0))) + 1);
                    else 
                     
                    end if;
				end if;
			
				
            elsif hold = '0' then
              	
                if PC /= PC_max + 1 then
                    next_opcode <= ProgramMemory(24 + (25 * PC) downto (25 * PC));
                    PC <= PC + 1;
					valid_out_flag <= '1';
                    if PC = PC_max then
                        finish <= '1';
                    else
                    
                    end if;
                else
                
                    IB_empty <= '1'; 
					valid_out_flag <= '0';
                end if;
            else
               
            end if;
        else
           
        end if;	
		
		ProgramMemory_OUT <= ProgramMemory;	
		Current_PC_Count <= std_logic_vector(to_unsigned(PC, 6));
		
		
    end process;
end ib_arch;