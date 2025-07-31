
library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity RF is
	port(
		
	reg_A, reg_B, reg_C: out std_logic_vector(127 downto 0);  
	opcode_out: out std_logic_vector(24 downto 0);
		wb_reg_data: in std_logic_vector(127 downto 0); 
		register_write: in std_logic;
		IB_empty: in std_logic;
		hold: in std_logic;
		clk, reset_bar: in std_logic;
		opcode: in std_logic_vector(24 downto 0);
		wb_opcodedata: in std_logic_vector(24 downto 0);
		valid_in_flag: in std_logic;
		valid_in_flag_WB: in std_logic;
		valid_out_flag: out std_logic;
		reg_0_out: out std_logic_vector(127 downto 0); 
		reg_1_out: out std_logic_vector(127 downto 0);
		reg_2_out: out std_logic_vector(127 downto 0);
		reg_3_out: out std_logic_vector(127 downto 0);
		reg_4_out: out std_logic_vector(127 downto 0);
		reg_5_out: out std_logic_vector(127 downto 0);
		reg_6_out: out std_logic_vector(127 downto 0);
		reg_7_out: out std_logic_vector(127 downto 0);
		reg_8_out: out std_logic_vector(127 downto 0);
		reg_9_out: out std_logic_vector(127 downto 0);
		reg_10_out: out std_logic_vector(127 downto 0);
		reg_11_out: out std_logic_vector(127 downto 0);
		reg_12_out: out std_logic_vector(127 downto 0);
		reg_13_out: out std_logic_vector(127 downto 0);
		reg_14_out: out std_logic_vector(127 downto 0);
		reg_15_out: out std_logic_vector(127 downto 0);
		reg_16_out: out std_logic_vector(127 downto 0);
		reg_17_out: out std_logic_vector(127 downto 0);
		reg_18_out: out std_logic_vector(127 downto 0);
		reg_19_out: out std_logic_vector(127 downto 0);
		reg_20_out: out std_logic_vector(127 downto 0);
		reg_21_out: out std_logic_vector(127 downto 0);
		reg_22_out: out std_logic_vector(127 downto 0);
		reg_23_out: out std_logic_vector(127 downto 0);
		reg_24_out: out std_logic_vector(127 downto 0);
		reg_25_out: out std_logic_vector(127 downto 0);
		reg_26_out: out std_logic_vector(127 downto 0);
		reg_27_out: out std_logic_vector(127 downto 0);
		reg_28_out: out std_logic_vector(127 downto 0);
		reg_29_out: out std_logic_vector(127 downto 0);
		reg_30_out: out std_logic_vector(127 downto 0);
		reg_31_out: out std_logic_vector(127 downto 0);
		reg_out_all: out std_logic_vector(4095 downto 0)
		);
end RF;

architecture behavioral of RF is	 
type RF is array (0 to 31) of std_logic_vector(127 downto 0);
signal reg : RF;  
signal reg_sel_A, reg_sel_B, reg_sel_c: std_logic_vector(4 downto 0); 
begin
	process(clk, reset_bar, register_write, opcode, wb_reg_data, wb_opcodedata) 
	begin 
		
		if ( opcode(24) = '0' ) then
			reg_sel_A <= opcode(4 downto 0); 
			
		else
		
		reg_sel_A <= opcode(9 downto 5);
		reg_sel_B <= opcode(14 downto 10);
		reg_sel_C <= opcode(19 downto 15); 
		
		end if;
		
		
		if reset_bar = '0' then  
			reg_A <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
			reg_B <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
			reg_C <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"; 
		    reg <= (others => (others => '0'));
		reg (0) <= (others => '0');
		else
			
		end if;
		
			
	
	if ( IB_empty = '1' ) then	
		
			reg_A <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
			reg_B <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";		
			reg_C <= "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
		   	opcode_out <= "1100000000000000000000000" ;
			   valid_out_flag <= '0';
		
	else 
	 if (valid_in_flag = '1') then	
		 
		 valid_out_flag <= '1';
		
		 if opcode(24) = '0' then
			reg_A <= reg(to_integer(unsigned(reg_sel_A)));	
				
	
		elsif opcode(24 downto 23) = "10" then
			reg_A <= reg(to_integer(unsigned(reg_sel_A)));
			reg_B <= reg(to_integer(unsigned(reg_sel_B))); 
			reg_C <= reg(to_integer(unsigned(reg_sel_C)));  
			
	
		elsif opcode(24 downto 23) = "11" then
			case opcode(18 downto 15) is																														 
				when "0000" =>
			
				when "0001"| "0010" | "0100" | "0101" | "0111" | "1001" | "1010" | "1011" | "1101" | "1110" | "1111" =>
					reg_A <= reg(to_integer(unsigned(reg_sel_A))); 	 
					reg_B <= reg(to_integer(unsigned(reg_sel_B)));	 
				when "0011" | "0110" | "1100" =>
					reg_A <= reg(to_integer(unsigned(reg_sel_A))); 	 
				when others =>
			
			end case;
			
			case opcode (19 downto 15) is
				when "01000" =>
					reg_A <= reg(to_integer(unsigned(reg_sel_A))); 	 
					reg_B <= reg(to_integer(unsigned(reg_sel_B)));	 
				when others =>
			
			end case;
		end if;
		
		 
	end if;
	
	
end if; 		
	
	
	if (valid_in_flag = '0') then	
		 
		 valid_out_flag <= '0';
		 
	  else
	  end if;
	  
	  
	  
	  
	  
	  
if ( (register_write = '1')  and ( hold = '0' ) and (valid_in_flag_WB = '1') ) then   
		
	 if not ( (wb_reg_data(127) = 'U' or wb_opcodedata(24) = 'U') and  (wb_opcodedata /= "1100000000000000000000000")  ) then
		
			if 		( wb_opcodedata (24 downto 15) = "1100000000"  )  then
				
				
				
			else 
				
			reg(to_integer(unsigned(wb_opcodedata(4 downto 0)))) <= wb_reg_data; 
		
		if reg_sel_A = wb_opcodedata(4 downto 0) then
			reg_A <= wb_reg_data;
		end if;
		if reg_sel_B = wb_opcodedata(4 downto 0) then																												
			reg_B <= wb_reg_data;
		end if;
		if reg_sel_c = wb_opcodedata(4 downto 0) then
			reg_C <= wb_reg_data;
		end if;
		
		end if ;
		
		else 
			
		end if;	
		
		
   
		else 
	
		end if;
		   
	  			 
	
	opcode_out <= opcode;
	
	            
    reg_out_all <= reg(0) & reg(1) & reg(2) & reg(3) & reg(4) & reg(5) & reg(6) & reg(7) &
                   reg(8) & reg(9) & reg(10) & reg(11) & reg(12) & reg(13) & reg(14) & reg(15) &
                   reg(16) & reg(17) & reg(18) & reg(19) & reg(20) & reg(21) & reg(22) & reg(23) &
                   reg(24) & reg(25) & reg(26) & reg(27) & reg(28) & reg(29) & reg(30) & reg(31);																	 
  
		reg_0_out <= reg(0); 
		reg_1_out <= reg(1);
		reg_2_out <= reg(2);
		reg_3_out <= reg(3);
		reg_4_out <= reg(4);
		reg_5_out <= reg(5);
		reg_6_out <= reg(6);
		reg_7_out <= reg(7);
		reg_8_out <= reg(8);
		reg_9_out <= reg(9);
		reg_10_out <= reg(10);
		reg_11_out <= reg(11);
		reg_12_out <= reg(12);
		reg_13_out <= reg(13);
		reg_14_out <= reg(14);
		reg_15_out <= reg(15);
		reg_16_out <= reg(16);
		reg_17_out <= reg(17);
		reg_18_out <= reg(18);
		reg_19_out <= reg(19);
		reg_20_out <= reg(20);
		reg_21_out <= reg(21);
		reg_22_out <= reg(22);
		reg_23_out <= reg(23);
		reg_24_out <= reg(24);
		reg_25_out <= reg(25);
		reg_26_out <= reg(26);
		reg_27_out <= reg(27);
		reg_28_out <= reg(28);
		reg_29_out <= reg(29);
		reg_30_out <= reg(30);
		reg_31_out <= reg(31);
							
	end process; 
		
end behavioral;
		

			
			
		
		
		
		
	