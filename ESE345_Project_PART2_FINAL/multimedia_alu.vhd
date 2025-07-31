
library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity multimedia_alu is
   
	Port (
        rs1 : in std_logic_vector(127 downto 0);
        rs2 : in std_logic_vector(127 downto 0);
        rs3 : in std_logic_vector(127 downto 0);
        opcode : in std_logic_vector(24 downto 0);
		
		valid_in_flag: in std_logic;
		valid_out_flag: out std_logic;
		
        rd : out std_logic_vector(127 downto 0);
		opcode_out : out std_logic_vector(24 downto 0);
		rd1 : out std_logic_vector(127 downto 0)
		
		);	
		
end entity multimedia_ALU;


		 
architecture alu_arch of multimedia_alu is

constant const_small_sign : std_logic_vector(63 downto 0) := "1000000000000000000000000000000000000000000000000000000000000000";
constant const_large_sign : std_logic_vector(63 downto 0) := "0111111111111111111111111111111111111111111111111111111111111111"; 
  
  

begin 
				
process (rs1, rs2, rs3, opcode, valid_in_flag )	   

	
	variable load_temp : std_logic_vector(127 downto 0); -- Temporary variable to hold the calculation
	variable load_start, load_end : natural := 0; -- Variables to specify the range (x downto y) for insertion by LOADINDEX VALUE  
	variable imm_var : std_logic_vector(15 downto 0);


	variable mult_int_var_1, mult_int_var_2, mult_int_var_3, mult_int_var_4: signed(31 downto 0);
    variable mult_int_add_1, mult_int_add_2, mult_int_add_3, mult_int_add_4: signed(31 downto 0);  
	variable mult_int_sub_1, mult_int_sub_2, mult_int_sub_3, mult_int_sub_4: signed(31 downto 0);
	variable mult_int_saturate_1, mult_int_saturate_2, mult_int_saturate_3,mult_int_saturate_4 : integer;
	variable mult_int_add_satur_1, mult_int_add_satur_2, mult_int_add_satur_3 : integer; 
	variable mult_int_add_satur_4, mult_int_sub_satur_1, mult_int_sub_satur_2, mult_int_sub_satur_3, mult_int_sub_satur_4: integer;
	
	variable mult_result: signed(127 downto 0);
	variable mult_overflow : std_logic_vector(63 downto 0) := "0000000000000000000000000000000000000000000000000000000000000000";	  
	variable mult_check_sign_1,mult_check_sign_2,mult_check_sign_3,mult_check_sign_4 : std_logic; 
	

	variable mult_long_var_1, mult_long_var_2, mult_long_var_3, mult_long_var_4: signed(63 downto 0);
    variable mult_long_add_1, mult_long_add_2, mult_long_add_3, mult_long_add_4: signed(63 downto 0);  
	variable mult_long_sub_1, mult_long_sub_2, mult_long_sub_3, mult_long_sub_4: signed(63 downto 0);
	variable mult_long_saturate_1, mult_long_saturate_2, mult_long_saturate_3,mult_long_saturate_4 : integer;
	variable mult_long_add_satur_1, mult_long_add_satur_2, mult_long_add_satur_3, mult_long_add_satur_4	: integer; 
	variable mult_long_sub_satur_1, mult_long_sub_satur_2, mult_long_sub_satur_3, mult_long_sub_satur_4: integer;	
	

	variable au_sum_1, au_sum_2, au_sum_3, au_sum_4: unsigned(31 downto 0);
    variable au_result: std_logic_vector(127 downto 0); 
	
	variable shift_num : integer;
    variable slhi_shift_1,slhi_shift_2,slhi_shift_3,slhi_shift_4,slhi_shift_5,slhi_shift_6,slhi_shift_7,slhi_shift_8 : std_logic_vector(15 downto 0);	
	
	variable cnt1h_num_1,cnt1h_num_2,cnt1h_num_3,cnt1h_num_4,cnt1h_num_5,cnt1h_num_6,cnt1h_num_7,cnt1h_num_8: integer := 0; 
	variable cnt1h_index : integer := 0;
	variable cnt1h_num_result_1, cnt1h_num_result_2, cnt1h_num_result_3, cnt1h_num_result_4, cnt1h_num_result_5, cnt1h_num_result_6, cnt1h_num_result_7, cnt1h_num_result_8 : std_logic_vector(15 downto 0);
	
	
	variable clzh_num_1,clzh_num_2,clzh_num_3,clzh_num_4,clzh_num_5,clzh_num_6,clzh_num_7,clzh_num_8: integer := 0; 
	variable clzh_index : integer := 0;
	variable clzh_num_result_1, clzh_num_result_2, clzh_num_result_3, clzh_num_result_4, clzh_num_result_5, clzh_num_result_6, clzh_num_result_7, clzh_num_result_8 : std_logic_vector(15 downto 0);
	
	
	variable ahs_sum_1: signed(15 downto 0);	  
	variable ahs_sum_2: signed(15 downto 0);
	variable ahs_sum_3: signed(15 downto 0);
	variable ahs_sum_4: signed(15 downto 0);
	variable ahs_sum_5: signed(15 downto 0);
	variable ahs_sum_6: signed(15 downto 0);
	variable ahs_sum_7: signed(15 downto 0);
	variable ahs_sum_8: signed(15 downto 0); 
	
	
	variable slhs_dif_1: signed(15 downto 0);	  
	variable slhs_dif_2: signed(15 downto 0);
	variable slhs_dif_3: signed(15 downto 0);
	variable slhs_dif_4: signed(15 downto 0);
	variable slhs_dif_5: signed(15 downto 0);
	variable slhs_dif_6: signed(15 downto 0);
	variable slhs_dif_7: signed(15 downto 0);
	variable slhs_dif_8: signed(15 downto 0); 	
	
	variable sfwu_dif_1: unsigned(31 downto 0);
	variable sfwu_dif_2: unsigned(31 downto 0);
	variable sfwu_dif_3: unsigned(31 downto 0);
	variable sfwu_dif_4: unsigned(31 downto 0);

	
	
	variable sum_satur_1,sum_satur_2,sum_satur_3,sum_satur_4,sum_satur_5,sum_satur_6,sum_satur_7,sum_satur_8 : integer;
	variable sfhs_dif_satur_1,sfhs_dif_satur_2,sfhs_dif_satur_3,sfhs_dif_satur_4,sfhs_dif_satur_5,sfhs_dif_satur_6,sfhs_dif_satur_7,sfhs_dif_satur_8 : integer;	
	variable sign_temp_mult_1,sign_temp_mult_2,sign_temp_mult_3,sign_temp_mult_4,sign_temp_mult_5,sign_temp_mult_6,sign_temp_mult_7,sign_temp_mult_8 : std_logic;
	variable ahs_sum_sign_1,ahs_sum_sign_2,ahs_sum_sign_3,ahs_sum_sign_4,ahs_sum_sign_5,ahs_sum_sign_6,ahs_sum_sign_7,ahs_sum_sign_8 : std_logic; 
	variable sign_temp_sub_1,sign_temp_sub_2,sign_temp_sub_3,sign_temp_sub_4,sign_temp_sub_5,sign_temp_sub_6,sign_temp_sub_7,sign_temp_sub_8 : std_logic;
	
	
	variable temp_result: signed(127 downto 0);
	variable temp_result_multiply: unsigned(127 downto 0);
	
	variable maxws_large_val, maxws_rs1, maxws_rs2 : integer;
	
	variable minws_small_val,minws_rs1, minws_rs2  : integer;	  
	
	variable mlhu_mult_1,mlhu_mult_2,mlhu_mult_3,mlhu_mult_4 : unsigned(31 downto 0);

	variable mlhcu_mult_1,mlhcu_mult_2,mlhcu_mult_3,mlhcu_mult_4 : unsigned(31 downto 0);	
	variable mlhcu_temp_mult_1,mlhcu_temp_mult_2,mlhcu_temp_mult_3,mlhcu_temp_mult_4 : unsigned(20 downto 0);
	variable mlhcu_result: unsigned(127 downto 0);
	
	variable temp_mult_hw_1,temp_mult_hw_2,temp_mult_hw_3,temp_mult_hw_4,temp_mult_hw_5, temp_mult_hw_6, temp_mult_hw_7, temp_mult_hw_8: signed(15 downto 0);	
    variable temp_mult_satur_hw_1, temp_mult_satur_hw_2, temp_mult_satur_hw_3,temp_mult_satur_hw_4, temp_mult_satur_hw_5,temp_mult_satur_hw_6,temp_mult_satur_hw_7,temp_mult_satur_hw_8	: integer;		 
	
	variable rotate_num : integer; 
	variable rlh_rotate_1,rlh_rotate_2,rlh_rotate_3,rlh_rotate_4, 
				rlh_rotate_5, rlh_rotate_6, rlh_rotate_7, rlh_rotate_8 : std_logic_vector(15 downto 0); 
	variable rlh_temp : std_logic_vector(31 downto 0);
	
	variable old_sign, new_sign: std_logic;
	
begin	


opcode_out <= opcode;	
	
		 

	if (valid_in_flag = '0') then	
			 
			 valid_out_flag <= '0';
			 
		  else
		  end if; 


	if (valid_in_flag ='1') then 
	
	 	valid_out_flag <= '1';
	
	
 if opcode(24) = '0' then
	 
	 load_temp := rs1; 
	
	 load_start := 16 * (to_integer(unsigned(opcode(23 downto 21))));
	 load_end := 15+ (16 * (to_integer(unsigned(opcode(23 downto 21)))));
    
  
	 
	  for i in 0 to 15 loop
      				imm_var(i) := opcode(20 - i);
    			 end loop;
	 
	 
    load_temp(load_end downto load_start) := opcode(20 downto 5);
    
    rd <= load_temp;
	
 end if;	 

 
 
 
 
 
if opcode(24 downto 23) = "10" then
	 
	 	  case opcode(22 downto 20) is
       
		
			   
			   when "000" =>
		
			   
			   
        mult_int_var_1 := signed(rs3(15 downto 0)) * signed(rs2(15 downto 0));
        mult_int_var_2 := signed(rs3(47 downto 32)) * signed(rs2(47 downto 32));
        mult_int_var_3 := signed(rs3(79 downto 64)) * signed(rs2(79 downto 64));
        mult_int_var_4 := signed(rs3(111 downto 96)) * signed(rs2(111 downto 96));
		
		
		
		mult_int_saturate_1 := to_integer(signed(rs3(15 downto 0))) * to_integer(signed(rs2(15 downto 0)));
		if (mult_int_saturate_1 > 2147483647) then mult_int_var_1 := "01111111111111111111111111111111";
        elsif (mult_int_saturate_1 < -2147483648) then mult_int_var_1 := "10000000000000000000000000000000";
        end if; 	
		
		
		mult_int_saturate_2 := to_integer(signed(rs3(47 downto 32))) * to_integer(signed(rs2(47 downto 32)));
		if (mult_int_saturate_2 > 2147483647) then mult_int_var_2 := "01111111111111111111111111111111";
        elsif (mult_int_saturate_2 < -2147483647) then mult_int_var_2 := "10000000000000000000000000000000";
        end if; 		 
		
		
       	mult_int_saturate_3 := to_integer(signed(rs3(79 downto 64))) * to_integer(signed(rs2(79 downto 64)));
		if (mult_int_saturate_3 > 2147483647) then mult_int_var_3 := "01111111111111111111111111111111";
        elsif (mult_int_saturate_3 < -2147483647) then mult_int_var_3 := "10000000000000000000000000000000";
        end if; 	  
		
			
       	mult_int_saturate_4 := to_integer(signed(rs3(111 downto 96))) * to_integer(signed(rs2(111 downto 96)));
		if (mult_int_saturate_4 > 2147483647) then mult_int_var_4 := "01111111111111111111111111111111";
        elsif (mult_int_saturate_4 < -2147483647) then mult_int_var_4 := "10000000000000000000000000000000";
        end if; 
		
		
		
    mult_int_add_1 := mult_int_var_1 + signed(rs1(31 downto 0));
    mult_int_add_2 := mult_int_var_2 + signed(rs1(63 downto 32));
    mult_int_add_3 := mult_int_var_3 + signed(rs1(95 downto 64));
    mult_int_add_4 := mult_int_var_4 + signed(rs1(127 downto 96));
			
				  
	
	
		mult_check_sign_1 := rs2(15) xor rs3(15);  
	
if rs1(31) = mult_check_sign_1 then
    if not (mult_check_sign_1 = mult_int_add_1(31)) then 
        if mult_check_sign_1 = '1' then
            mult_int_add_1 := "10000000000000000000000000000000";
        elsif mult_check_sign_1 = '0' then
            mult_int_add_1 := "01111111111111111111111111111111";
        end if;
    else
       
        null;
    end if;
else
 
	
end if;



		mult_check_sign_2 := rs2(47) xor rs3(47);          
										  
			
		if (rs1(63) = mult_check_sign_2) then
    if not(mult_check_sign_2 = mult_int_add_2(31)) then 
        
            if (mult_check_sign_2 = '1') then mult_int_add_2 := "10000000000000000000000000000000";
            elsif (mult_check_sign_2 = '0') then mult_int_add_2 := "01111111111111111111111111111111";
            end if;
        else
            
        end if;
    else
       
   
end if;

	  mult_check_sign_3 := rs2(79) xor rs3(79);          								  
			
		if (rs1(95) = mult_check_sign_3) then
    if not(mult_check_sign_3 = mult_int_add_3(31)) then 
       
            if (mult_check_sign_3 = '1') then mult_int_add_3 := "10000000000000000000000000000000";
            elsif (mult_check_sign_3 = '0') then mult_int_add_3 := "01111111111111111111111111111111";
            end if;
        else
          
			
        end if;
    else
        
		
end if;				 	  
		
		mult_check_sign_4 := rs2(111) xor rs3(111);          
		
		
		if (rs1(127) = mult_check_sign_4) then
    if not(mult_check_sign_4 = mult_int_add_4(31)) then 
        
            if (mult_check_sign_4 = '1') then mult_int_add_4 := "10000000000000000000000000000000";
            elsif (mult_check_sign_4 = '0') then mult_int_add_4 := "01111111111111111111111111111111";
            end if;
        else
           
			
        end if;
    else
      
		
end if;
	
	
	mult_result := (others => '0');
    mult_result(31 downto 0) := mult_int_add_1(31 downto 0);
    mult_result(63 downto 32) := mult_int_add_2(31 downto 0);
    mult_result(95 downto 64) := mult_int_add_3(31 downto 0);
    mult_result(127 downto 96) := mult_int_add_4(31 downto 0);

   
    rd <= std_logic_vector(mult_result);	

	
	

	
	when "001" =>
			 
 
		mult_int_var_1 := signed(rs3(31 downto 16)) * signed(rs2(31 downto 16));
        mult_int_var_2 := signed(rs3(63 downto 48)) * signed(rs2(63 downto 48));
        mult_int_var_3 := signed(rs3(95 downto 80)) * signed(rs2(95 downto 80));
        mult_int_var_4 := signed(rs3(127 downto 112)) * signed(rs2(127 downto 112));
		
		
		mult_int_saturate_1 := to_integer(signed(rs3(31 downto 16))) * to_integer(signed(rs2(31 downto 16)));
		if (mult_int_saturate_1 > 2147483647) then mult_int_var_1 := "01111111111111111111111111111111";
        elsif (mult_int_saturate_1 < -2147483648) then mult_int_var_1 := "10000000000000000000000000000000";
        end if; 				 
		
		
		mult_int_saturate_2 := to_integer(signed(rs3(63 downto 48))) * to_integer(signed(rs2(63 downto 48)));
		if (mult_int_saturate_2 > 2147483647) then mult_int_var_2 := "01111111111111111111111111111111";
        elsif (mult_int_saturate_2 < -2147483647) then mult_int_var_2 := "10000000000000000000000000000000";
        end if; 		 
		
		
       	mult_int_saturate_3 := to_integer(signed(rs3(95 downto 80))) * to_integer(signed(rs2(95 downto 80)));
		if (mult_int_saturate_3 > 2147483647) then mult_int_var_3 := "01111111111111111111111111111111";
        elsif (mult_int_saturate_3 < -2147483647) then mult_int_var_3 := "10000000000000000000000000000000";
        end if; 	  
		
		
       	mult_int_saturate_4 := to_integer(signed(rs3(127 downto 112))) * to_integer(signed(rs2(127 downto 112)));
		if (mult_int_saturate_4 > 2147483647) then mult_int_var_4 := "01111111111111111111111111111111";
        elsif (mult_int_saturate_4 < -2147483647) then mult_int_var_4 := "10000000000000000000000000000000";
        end if; 
			
		
    mult_int_add_1 := mult_int_var_1 + signed(rs1(31 downto 0));
    mult_int_add_2 := mult_int_var_2 + signed(rs1(63 downto 32));
    mult_int_add_3 := mult_int_var_3 + signed(rs1(95 downto 64));
    mult_int_add_4 := mult_int_var_4 + signed(rs1(127 downto 96));
	
	
	
	mult_check_sign_1 := rs2(31) xor rs3(31);          
											  
			
		if (rs1(31) = mult_check_sign_1) then
    if not(mult_check_sign_1 = mult_int_add_1(31)) then 
       
            if (mult_check_sign_1 = '1') then mult_int_add_1 := "10000000000000000000000000000000";
            elsif (mult_check_sign_1 = '0') then mult_int_add_1 := "01111111111111111111111111111111";
            end if;
        else
            
			
        end if;
    else
      
    
end if;


	mult_check_sign_2 := rs2(63) xor rs3(63);          
									  
			
		if (rs1(63) = mult_check_sign_2) then
    if not(mult_check_sign_2 = mult_int_add_2(31)) then 
        
            if (mult_check_sign_2 = '1') then mult_int_add_2 := "10000000000000000000000000000000";
            elsif (mult_check_sign_2 = '0') then mult_int_add_2 := "01111111111111111111111111111111";
            end if;
        else
        
           
        end if;
    else
      
        
    
end if;


	  mult_check_sign_3 := rs2(95) xor rs3(95);          								  
			
		if (rs1(95) = mult_check_sign_3) then
    if not(mult_check_sign_3 = mult_int_add_3(31)) then 
        
            if (mult_check_sign_3 = '1') then mult_int_add_3 := "10000000000000000000000000000000";
            elsif (mult_check_sign_3 = '0') then mult_int_add_3 := "01111111111111111111111111111111";
            end if;
        else
           
			
        end if;
    else
        
    
end if;				 	  
		
			
		mult_check_sign_4 := rs2(127) xor rs3(127);          
										  
			
		if (rs1(127) = mult_check_sign_4) then
    if not(mult_check_sign_4 = mult_int_add_4(31)) then 
        
            if (mult_check_sign_4 = '1') then mult_int_add_4 := "10000000000000000000000000000000";
            elsif (mult_check_sign_4 = '0') then mult_int_add_4 := "01111111111111111111111111111111";
            end if;
        else
           
           
        end if;
    else
        
        
    
end if;
	
				  
				  
	
    mult_result := (others => '0');
    mult_result(31 downto 0) := mult_int_add_1(31 downto 0);
    mult_result(63 downto 32) := mult_int_add_2(31 downto 0);
    mult_result(95 downto 64) := mult_int_add_3(31 downto 0);
    mult_result(127 downto 96) := mult_int_add_4(31 downto 0);

 
    rd <= std_logic_vector(mult_result);	

		
		
		
		
        when "010" =>
				
		
        mult_int_var_1 := signed(rs3(15 downto 0)) * signed(rs2(15 downto 0));
		mult_int_var_2 := signed(rs3(47 downto 32)) * signed(rs2(47 downto 32));
        mult_int_var_3 := signed(rs3(79 downto 64)) * signed(rs2(79 downto 64));
        mult_int_var_4 := signed(rs3(111 downto 96)) * signed(rs2(111 downto 96));
		
		
		mult_int_saturate_1 := to_integer(signed(rs3(15 downto 0))) * to_integer(signed(rs2(15 downto 0)));
		if (mult_int_saturate_1 > 2147483647) then mult_int_var_1 := "01111111111111111111111111111111";
        elsif (mult_int_saturate_1 < -2147483648) then mult_int_var_1 := "10000000000000000000000000000000";
        end if; 				 
		
			
		mult_int_saturate_2 := to_integer(signed(rs3(47 downto 32))) * to_integer(signed(rs2(47 downto 32)));
		if (mult_int_saturate_2 > 2147483647) then mult_int_var_2 := "01111111111111111111111111111111";
        elsif (mult_int_saturate_2 < -2147483647) then mult_int_var_2 := "10000000000000000000000000000000";
        end if; 		 
		
		
       	mult_int_saturate_3 := to_integer(signed(rs3(79 downto 64))) * to_integer(signed(rs2(79 downto 64)));
		if (mult_int_saturate_3 > 2147483647) then mult_int_var_3 := "01111111111111111111111111111111";
        elsif (mult_int_saturate_3 < -2147483647) then mult_int_var_3 := "10000000000000000000000000000000";
        end if; 	  
		
		
       	mult_int_saturate_4 := to_integer(signed(rs3(111 downto 96))) * to_integer(signed(rs2(111 downto 96)));
		if (mult_int_saturate_4 > 2147483647) then mult_int_var_4 := "01111111111111111111111111111111";
        elsif (mult_int_saturate_4 < -2147483647) then mult_int_var_4 := "10000000000000000000000000000000";
        end if; 
			
		
		

    mult_int_sub_1:= signed(rs1(31 downto 0)) - mult_int_var_1;
    mult_int_sub_2:= signed(rs1(63 downto 32)) - mult_int_var_2;
    mult_int_sub_3:= signed(rs1(95 downto 64)) - mult_int_var_3;
    mult_int_sub_4:= signed(rs1(127 downto 96)) - mult_int_var_4 ;
			
								   
				  
			mult_check_sign_1 := rs2(15) xor rs3(15);           
				   
 
if (rs1(31) = mult_check_sign_1) then
    if not(mult_check_sign_1 = mult_int_sub_1(31)) then
        if (mult_check_sign_1 = '1') then
            mult_int_sub_1 := "01111111111111111111111111111111";
        elsif (mult_check_sign_1 = '0') then
            mult_int_sub_1 := "10000000000000000000000000000000"; 
        end if;
    else 
       
		
    end if;
else 
    
    
end if;

			
					  
		mult_check_sign_2 := rs2(47) xor rs3(47);         



if (rs1(63) = mult_check_sign_2) then
    if not(mult_check_sign_2 = mult_int_sub_2(31)) then
        if (mult_check_sign_2 = '1') then
            mult_int_sub_2 := "01111111111111111111111111111111";
        elsif (mult_check_sign_2 = '0') then
            mult_int_sub_2 := "10000000000000000000000000000000"; 
        end if;
    else 
      
       
    end if;
else 
    
	
end if;
		


	mult_check_sign_3 := rs2(79) xor rs3(79);         


if (rs1(95) = mult_check_sign_3) then
    if not(mult_check_sign_3 = mult_int_sub_3(31)) then
        if (mult_check_sign_3 = '1') then
            mult_int_sub_3 := "01111111111111111111111111111111";
        elsif (mult_check_sign_3 = '0') then
            mult_int_sub_3 := "10000000000000000000000000000000"; 
        end if;
    else 
       
       
    end if;
else 

	
end if;


		 	 
	mult_check_sign_4 := rs2(111) xor rs3(111);    


if (rs1(127) = mult_check_sign_4) then
    if not(mult_check_sign_4 = mult_int_sub_4(31)) then
        if (mult_check_sign_4 = '1') then mult_int_sub_4 := "01111111111111111111111111111111";
        elsif (mult_check_sign_4 = '0') then mult_int_sub_4 := "10000000000000000000000000000000"; 
        end if;
    else 
       
       
    end if;
else 
    
    
end if;
			
	
    
    mult_result := (others => '0');
    mult_result(31 downto 0) := mult_int_sub_1(31 downto 0);
    mult_result(63 downto 32) := mult_int_sub_2(31 downto 0);
    mult_result(95 downto 64) := mult_int_sub_3(31 downto 0);
    mult_result(127 downto 96) := mult_int_sub_4(31 downto 0);

 
    rd <= std_logic_vector(mult_result);	


		
		
	
	

		
        when "011" =>
		
		
        mult_int_var_1 := signed(rs3(31 downto 16)) * signed(rs2(31 downto 16));
        mult_int_var_2 := signed(rs3(63 downto 48)) * signed(rs2(63 downto 48));
        mult_int_var_3 := signed(rs3(95 downto 80)) * signed(rs2(95 downto 80));
        mult_int_var_4 := signed(rs3(127 downto 112)) * signed(rs2(127 downto 112));
		
		
		mult_int_saturate_1 := to_integer(signed(rs3(31 downto 16))) * to_integer(signed(rs2(31 downto 16)));
		if (mult_int_saturate_1 > 2147483647) then mult_int_var_1 := "01111111111111111111111111111111";
        elsif (mult_int_saturate_1 < -2147483648) then mult_int_var_1 := "10000000000000000000000000000000";
        end if; 				 
		
			
		mult_int_saturate_2 := to_integer(signed(rs3(63 downto 48))) * to_integer(signed(rs2(63 downto 48)));
		if (mult_int_saturate_2 > 2147483647) then mult_int_var_2 := "01111111111111111111111111111111";
        elsif (mult_int_saturate_2 < -2147483647) then mult_int_var_2 := "10000000000000000000000000000000";
        end if; 		 
		

       	mult_int_saturate_3 := to_integer(signed(rs3(95 downto 80))) * to_integer(signed(rs2(95 downto 80)));
		if (mult_int_saturate_3 > 2147483647) then mult_int_var_3 := "01111111111111111111111111111111";
        elsif (mult_int_saturate_3 < -2147483647) then mult_int_var_3 := "10000000000000000000000000000000";
        end if; 	  
		

       	mult_int_saturate_4 := to_integer(signed(rs3(127 downto 112))) * to_integer(signed(rs2(127 downto 112)));
		if (mult_int_saturate_4 > 2147483647) then mult_int_var_4 := "01111111111111111111111111111111";
        elsif (mult_int_saturate_4 < -2147483647) then mult_int_var_4 := "10000000000000000000000000000000";
        end if; 
			
		
		
		
		mult_int_sub_1:= signed(rs1(31 downto 0)) - mult_int_var_1;
		mult_int_sub_2:= signed(rs1(63 downto 32)) - mult_int_var_2;
		mult_int_sub_3:= signed(rs1(95 downto 64)) - mult_int_var_3;
		mult_int_sub_4:= signed(rs1(127 downto 96)) - mult_int_var_4;
		
		
				  
			mult_check_sign_1 := rs2(31) xor rs3(31);        
				   
  
			
if (rs1(31) = mult_check_sign_1) then
    if not(mult_check_sign_1 = mult_int_sub_1(31)) then
        if (mult_check_sign_1 = '1') then
            mult_int_sub_1 := "01111111111111111111111111111111";
        elsif (mult_check_sign_1 = '0') then
            mult_int_sub_1 := "10000000000000000000000000000000"; 
        end if;
    else 
    
       
    end if;
else 
   
    
end if;

	

	mult_check_sign_2 := rs2(63) xor rs3(63);         



if (rs1(63) = mult_check_sign_2) then
    if not(mult_check_sign_2 = mult_int_sub_2(31)) then
        if (mult_check_sign_2 = '1') then
            mult_int_sub_2 := "01111111111111111111111111111111";
        elsif (mult_check_sign_2 = '0') then
            mult_int_sub_2 := "10000000000000000000000000000000"; 
        end if;
    else 
        
       
    end if;
else 
   
    
end if;
		
			
					  
	mult_check_sign_3 := rs2(95) xor rs3(95);       



if (rs1(95) = mult_check_sign_3) then
    if not(mult_check_sign_3 = mult_int_sub_3(31)) then
        if (mult_check_sign_3 = '1') then
            mult_int_sub_3 := "01111111111111111111111111111111";
        elsif (mult_check_sign_3 = '0') then
            mult_int_sub_3 := "10000000000000000000000000000000"; 
        end if;
    else 
       
       
    end if;
else 
   
    
end if;



	mult_check_sign_4 := rs2(127) xor rs3(127);  


if (rs1(127) = mult_check_sign_4) then
    if not(mult_check_sign_4 = mult_int_sub_4(31)) then
        if (mult_check_sign_4 = '1') then mult_int_sub_4 := "01111111111111111111111111111111";
        elsif (mult_check_sign_4 = '0') then mult_int_sub_4 := "10000000000000000000000000000000"; 
        end if;
    else 
       
       
    end if;
else 
    
    
end if;
			
																		   
    mult_result := (others => '0');
    mult_result(31 downto 0) := mult_int_sub_1(31 downto 0);
    mult_result(63 downto 32) := mult_int_sub_2(31 downto 0);
    mult_result(95 downto 64) := mult_int_sub_3(31 downto 0);
    mult_result(127 downto 96) := mult_int_sub_4(31 downto 0);

    
    rd <= std_logic_vector(mult_result);	

	
	
	
	
	
	when "100" =>
	
	

        mult_long_var_1 := signed(rs3(31 downto 0)) * signed(rs2(31 downto 0));
        mult_long_var_2 := signed(rs3(95 downto 64)) * signed(rs2(95 downto 64));		
		

		mult_long_saturate_1 := to_integer(signed(rs3(31 downto 0))) * to_integer(signed(rs2(31 downto 0)));
		if (mult_long_saturate_1 >     signed(const_large_sign)    ) then mult_long_var_1 := "0111111111111111111111111111111111111111111111111111111111111111";
        elsif (mult_long_saturate_1 <  signed(const_small_sign)     ) then mult_long_var_1 := "1000000000000000000000000000000000000000000000000000000000000000";	  
		else mult_long_var_1 :=   signed(rs3(31 downto 0)) * signed(rs2(31 downto 0));		
        end if; 				 
		
		
		mult_long_saturate_2 := to_integer(signed(rs3(95 downto 64))) * to_integer(signed(rs2(95 downto 64)));
		if (mult_long_saturate_2 >  signed(const_large_sign) ) then mult_long_var_2 := "0111111111111111111111111111111111111111111111111111111111111111";
        elsif (mult_long_saturate_2 < signed(const_small_sign) ) then mult_long_var_2 := "1000000000000000000000000000000000000000000000000000000000000000";
        end if; 		 			
		
		
		mult_long_add_1:= signed(rs1(63 downto 0)) + mult_long_var_1;
		mult_long_add_2:= signed(rs1(127 downto 64)) + mult_long_var_2;		 
		 
		
		mult_check_sign_1 := rs2(31) xor rs3(31);          								  
			
		if (rs1(63) = mult_check_sign_1) then
    if not(mult_check_sign_1 = mult_long_add_1(63)) then 
       
            if (mult_check_sign_1 = '1') then mult_long_add_1 := X"8000000000000000";
            elsif (mult_check_sign_1 = '0') then mult_long_add_1 := X"7FFFFFFFFFFFFFFF";
            end if;
        else
          
           
        end if;
    else
     
        
   
end if;
				 
			mult_check_sign_2 := rs2(95) xor rs3(95);          
										  
			
		if (rs1(127) = mult_check_sign_2) then
    if not(mult_check_sign_2 = mult_long_add_2(63)) then 
      
            if (mult_check_sign_2 = '1') then mult_long_add_2 := X"8000000000000000";
            elsif (mult_check_sign_2 = '0') then mult_long_add_2 := X"7FFFFFFFFFFFFFFF";
            end if;
        else
           
        end if;
    else
   
    
end if;


	
    mult_result := (others => '0');
    mult_result(63 downto 0) := mult_long_add_1(63 downto 0);
    mult_result(127 downto 64) := mult_long_add_2(63 downto 0);	 
	
	
    rd <= std_logic_vector(mult_result);		 

	
	
	
	
	
	when "101" =>
	
	
	
    mult_long_var_1 := signed(rs3(63 downto 32)) * signed(rs2(63 downto 32));
	mult_long_var_2 := signed(rs3(127 downto 96)) * signed(rs2(127 downto 96));		
		
	
	
		mult_long_saturate_1 := to_integer(signed(rs3(63 downto 32))) * to_integer(signed(rs2(63 downto 32)));
		if (mult_long_saturate_1 >  signed(const_large_sign) ) then mult_long_var_1 := "0111111111111111111111111111111111111111111111111111111111111111";
        elsif (mult_long_saturate_1 <  signed(const_small_sign)) then mult_long_var_1 := "1000000000000000000000000000000000000000000000000000000000000000";
        end if; 				 
		
			
		mult_long_saturate_2 := to_integer(signed(rs3(127 downto 96))) * to_integer(signed(rs2(127 downto 96)));
		if (mult_long_saturate_2 >  signed(const_large_sign) ) then mult_long_var_2 := "0111111111111111111111111111111111111111111111111111111111111111";
        elsif (mult_long_saturate_2 <  signed(const_small_sign)) then mult_long_var_2 := "1000000000000000000000000000000000000000000000000000000000000000";
        end if; 		 			
		 
		
		mult_long_add_1:= signed(rs1(63 downto 0)) + mult_long_var_1;
		mult_long_add_2:= signed(rs1(127 downto 64)) + mult_long_var_2;		 
		 

			mult_check_sign_1 := rs2(63) xor rs3(63);          
		
		if (rs1(63) = mult_check_sign_1) then
    if not(mult_check_sign_1 = mult_long_add_1(63)) then 
       
            if (mult_check_sign_1 = '1') then mult_long_add_1 := X"8000000000000000";
            elsif (mult_check_sign_1 = '0') then mult_long_add_1 := X"7FFFFFFFFFFFFFFF";
            end if;
        else
           
        end if;
    else
       
		
end if;


			mult_check_sign_2 := rs2(127) xor rs3(127);          
			
			
		if (rs1(127) = mult_check_sign_2) then
    if not(mult_check_sign_2 = mult_long_add_2(63)) then 
      
            if (mult_check_sign_2 = '1') then mult_long_add_2 := X"8000000000000000";
            elsif (mult_check_sign_2 = '0') then mult_long_add_2 := X"7FFFFFFFFFFFFFFF";
            end if;
        else
           
           
        end if;
    else
        
    
end if;

				
				 
    mult_result := (others => '0');
    mult_result(63 downto 0) := mult_long_add_1(63 downto 0);
    mult_result(127 downto 64) := mult_long_add_2(63 downto 0);	 
		 
    rd <= std_logic_vector(mult_result);		
			
			
			
			
	
	
	
		when "110" =>
		
		
		
        mult_long_var_1 := signed(rs3(31 downto 0)) * signed(rs2(31 downto 0));
        mult_long_var_2 := signed(rs3(95 downto 64)) * signed(rs2(95 downto 64));		
		
	
		mult_long_saturate_1 := to_integer(signed(rs3(31 downto 0))) * to_integer(signed(rs2(31 downto 0)));
		
		
		if (mult_long_saturate_1 > signed(const_large_sign) ) then mult_long_var_1 := "0111111111111111111111111111111111111111111111111111111111111111";
        elsif (mult_long_saturate_1 < signed(const_small_sign)) then mult_long_var_1 := "1000000000000000000000000000000000000000000000000000000000000000";
        end if; 				 
		
		
		mult_long_saturate_2 := to_integer(signed(rs3(95 downto 64))) * to_integer(signed(rs2(95 downto 64)));
		
		
		if (mult_long_saturate_2 >  signed(const_large_sign)) then mult_long_var_2 := "0111111111111111111111111111111111111111111111111111111111111111";
        elsif (mult_long_saturate_2 < signed(const_small_sign)) then mult_long_var_2 := "1000000000000000000000000000000000000000000000000000000000000000";
        end if; 		 			
		 
		
		mult_long_sub_1:= signed(rs1(63 downto 0)) - mult_long_var_1;
		mult_long_sub_2:= signed(rs1(127 downto 64)) - mult_long_var_2;		 
	 
	 
		mult_check_sign_1 := rs2(31) xor rs3(31);          
		
		
		if (rs1(63) = mult_check_sign_1) then
    if not(mult_check_sign_1 = mult_long_sub_1(63)) then 
        
            if (mult_check_sign_1 = '1') then mult_long_sub_1 :=  X"7FFFFFFFFFFFFFFF";
            elsif (mult_check_sign_1 = '0') then mult_long_sub_1 := X"8000000000000000";
            end if;
        else
           
           
        end if;
    else
       
        
  
end if;
				
	 
		
		 mult_check_sign_2 := rs2(95) xor rs3(95);          
		
		 
		if (rs1(127) = mult_check_sign_2) then
    if not(mult_check_sign_2 = mult_long_sub_2(63)) then 
        
            if (mult_check_sign_2 = '1') then mult_long_sub_2 := 	 X"7FFFFFFFFFFFFFFF";
            elsif (mult_check_sign_2 = '0') then mult_long_sub_2 := X"8000000000000000";
            end if;
        else
       
           
        end if;
    else
        
        
    
end if;

	mult_result := (others => '0');
    mult_result(63 downto 0) := mult_long_sub_1(63 downto 0);
    mult_result(127 downto 64) := mult_long_sub_2(63 downto 0);	 
		 
	rd <= std_logic_vector(mult_result);		
					
		

	
	

	when "111" =>
            
          
			
        mult_long_var_1 := signed(rs3(63 downto 32)) * signed(rs2(63 downto 32));
        mult_long_var_2 := signed(rs3(127 downto 96)) * signed(rs2(127 downto 96));		
		
	
		mult_long_saturate_1 := to_integer(signed(rs3(63 downto 32))) * to_integer(signed(rs2(63 downto 32)));
		if (mult_long_saturate_1 > signed(const_large_sign)) then mult_long_var_1 := "0111111111111111111111111111111111111111111111111111111111111111";
        elsif (mult_long_saturate_1 < signed(const_small_sign)) then mult_long_var_1 := "1000000000000000000000000000000000000000000000000000000000000000";
        end if; 				 
		
		
		mult_long_saturate_2 := to_integer(signed(rs3(127 downto 96))) * to_integer(signed(rs2(127 downto 96)));
		if (mult_long_saturate_2 > signed(const_large_sign)) then mult_long_var_2 := "0111111111111111111111111111111111111111111111111111111111111111";
        elsif (mult_long_saturate_2 < signed(const_small_sign)) then mult_long_var_2 := "1000000000000000000000000000000000000000000000000000000000000000";
        end if; 		 			
		
		
		mult_long_sub_1:= signed(rs1(63 downto 0)) - mult_long_var_1;
		mult_long_sub_2:= signed(rs1(127 downto 64)) - mult_long_var_2;		 
		 
		
	 
	 
			mult_check_sign_1 := rs2(63) xor rs3(63);          
										  
			
		if (rs1(63) = mult_check_sign_1) then
    if not(mult_check_sign_1 = mult_long_sub_1(63)) then 
        
            if (mult_check_sign_1 = '1') then mult_long_sub_1 :=  X"7FFFFFFFFFFFFFFF";
            elsif (mult_check_sign_1 = '0') then mult_long_sub_1 := X"8000000000000000";
            end if;
        else					    			  
			
        end if;
    else
        
  
end if;
				
	 
		 mult_check_sign_2 := rs2(127) xor rs3(127);          
	
		 
		if (rs1(127) = mult_check_sign_2) then
    if not(mult_check_sign_2 = mult_long_sub_2(63)) then 
        
            if (mult_check_sign_2 = '1') then mult_long_sub_2 := 	 X"7FFFFFFFFFFFFFFF";
            elsif (mult_check_sign_2 = '0') then mult_long_sub_2 := X"8000000000000000";
            end if;
        else
         
			
        end if;
    else
      
		
end if;
	
				

	mult_result := (others => '0');
    mult_result(63 downto 0) := mult_long_sub_1(63 downto 0);
    mult_result(127 downto 64) := mult_long_sub_2(63 downto 0);	 

	rd <= std_logic_vector(mult_result);		
	
	
	

        when others =>
            rd <= (others => '0');
    end case;
	
end if;	





if opcode(24 downto 23) = "11" then
	 
	
	 	case opcode(18 downto 15) is
        when "0000" =>
  
			 rd <= (others => '0'); 
        when "0001" =>
        
          	
			
        	shift_num := to_integer(unsigned(opcode(13 downto 10)));
        
            
            slhi_shift_1 := rs1(0 * 16 + 15 downto 0 * 16);
            
           
            slhi_shift_1 := std_logic_vector(shift_left(unsigned(slhi_shift_1), shift_num));
      
            slhi_shift_2 := rs1(1 * 16 + 15 downto 1 * 16);
            
            
            slhi_shift_2 := std_logic_vector(shift_left(unsigned(slhi_shift_2), shift_num));
           
            slhi_shift_3 := rs1(2 * 16 + 15 downto 2 * 16);
            
        
            slhi_shift_3 := std_logic_vector(shift_left(unsigned(slhi_shift_3), shift_num));
            
         
            slhi_shift_4 := rs1(3 * 16 + 15 downto 3 * 16);
            
           
            slhi_shift_4 := std_logic_vector(shift_left(unsigned(slhi_shift_4), shift_num));
        
            slhi_shift_5 := rs1(4 * 16 + 15 downto 4 * 16);
            
            
			slhi_shift_5 := std_logic_vector(shift_left(unsigned(slhi_shift_5), shift_num));
            
			
            slhi_shift_6 := rs1(5 * 16 + 15 downto 5 * 16);
            
          
            slhi_shift_6 := std_logic_vector(shift_left(unsigned(slhi_shift_6), shift_num));
            
          
            slhi_shift_7 := rs1(6 * 16 + 15 downto 6 * 16);
            
           
            slhi_shift_7 := std_logic_vector(shift_left(unsigned(slhi_shift_7), shift_num));
            
            
            slhi_shift_8 := rs1(7 * 16 + 15 downto 7 * 16);
            
           
            slhi_shift_8 := std_logic_vector(shift_left(unsigned(slhi_shift_8), shift_num));
 
    
    temp_result := (others => '0');
    temp_result(15 downto 0) := signed(slhi_shift_1 (15 downto 0));
    temp_result(31 downto 16) := signed(slhi_shift_2 (15 downto 0));
    temp_result(47 downto 32)  := signed(slhi_shift_3 (15 downto 0));
    temp_result(63 downto 48) := signed(slhi_shift_4 (15 downto 0));
    temp_result(79 downto 64) := signed(slhi_shift_5 (15 downto 0));
    temp_result(95 downto 80)  := signed(slhi_shift_6 (15 downto 0));
    temp_result(111 downto 96) := signed(slhi_shift_7 (15 downto 0));
    temp_result(127 downto 112)  := signed(slhi_shift_8 (15 downto 0));

								
    rd <= std_logic_vector(temp_result);	
		 
		 
		  
		  
		  when "0010" =>	
		
			
	au_sum_1 := unsigned(rs1(31 downto 0)) + unsigned(rs2(31 downto 0));
	au_sum_2 := unsigned(rs1(63 downto 32)) + unsigned(rs2(63 downto 32));
	au_sum_3 := unsigned(rs1(95 downto 64)) + unsigned(rs2(95 downto 64));				 -- 4 diff ranges added, 
	au_sum_4 := unsigned(rs1(127 downto 96)) + unsigned(rs2(127 downto 96));
	
	au_result := (others => '0');
	au_result(31 downto 0) := std_logic_vector(au_sum_1);
	au_result(63 downto 32) := std_logic_vector(au_sum_2);
	au_result(95 downto 64) := std_logic_vector(au_sum_3);								-- values concatented
	au_result(127 downto 96) := std_logic_vector(au_sum_4);
	
	
	rd <= std_logic_vector(au_result);													
		
		
           
            
        when "0011" =>
            
         
		cnt1h_num_1:= 0;
		 cnt1h_num_2:= 0;
		 cnt1h_num_3:= 0;
		 cnt1h_num_4:= 0;
		 cnt1h_num_5:= 0;
		 cnt1h_num_6:= 0;
		 cnt1h_num_7:= 0;
		 cnt1h_num_8:= 0;
			 
			  
		cnt1h_index := 0;
       
        for i in 0 to 15 loop
            if rs1(cnt1h_index) = '1' then
                cnt1h_num_1 := cnt1h_num_1 + 1;  
          		cnt1h_index := cnt1h_index + 1;									  
		 	   else
			cnt1h_index := cnt1h_index + 1;  
				end if;
        end loop;	
				   
		
		
		
		cnt1h_index := 16;
		  for i in 0 to 15 loop
            if rs1(cnt1h_index) = '1' then
                cnt1h_num_2 := cnt1h_num_2 + 1;  
          		cnt1h_index := cnt1h_index + 1;
				   else
			cnt1h_index := cnt1h_index + 1; 
				end if;
        end loop;
		
		
		
		cnt1h_index := 32;
		  for i in 0 to 15 loop
            if rs1(cnt1h_index) = '1' then
                cnt1h_num_3 := cnt1h_num_3 + 1;  
          		cnt1h_index := cnt1h_index + 1; 
				   else
			cnt1h_index := cnt1h_index + 1; 
				end if;
        end loop;	
		
	      
		cnt1h_index := 48;
		  for i in 0 to 15 loop
            if rs1(cnt1h_index) = '1' then
                cnt1h_num_4 := cnt1h_num_4 + 1;  
          		cnt1h_index := cnt1h_index + 1;  
				   else
			cnt1h_index := cnt1h_index + 1; 
				end if;
        end loop;	 
		
		
		cnt1h_index := 64;
		  for i in 0 to 15 loop
            if rs1(cnt1h_index) = '1' then
                cnt1h_num_5 := cnt1h_num_5 + 1;  
          		cnt1h_index := cnt1h_index + 1; 
				   else
			cnt1h_index := cnt1h_index + 1; 
				end if;
        end loop;	
		
		
	
		cnt1h_index := 80;
		  for i in 0 to 15 loop
            if rs1(cnt1h_index) = '1' then
                cnt1h_num_6 := cnt1h_num_6 + 1;  
          		cnt1h_index := cnt1h_index + 1;
				   else
			cnt1h_index := cnt1h_index + 1; 
				end if;
        end loop;	
		
		
		
		cnt1h_index := 96;
		  for i in 0 to 15 loop
            if rs1(cnt1h_index) = '1' then
                cnt1h_num_7 := cnt1h_num_7 + 1;  
         		cnt1h_index := cnt1h_index + 1;  
				  else
			cnt1h_index := cnt1h_index + 1; 
				end if;
        end loop;	
	  
	  
		
		cnt1h_index := 112;
		  for i in 0 to 15 loop
            if rs1(cnt1h_index) = '1' then
                cnt1h_num_8 := cnt1h_num_8 + 1;  -- 
          		cnt1h_index := cnt1h_index + 1;  
				   else
			cnt1h_index := cnt1h_index + 1; 
				end if;
      	 end loop;	
		
		
	 
		cnt1h_num_result_1 := std_logic_vector(to_unsigned(cnt1h_num_1, 16));
		cnt1h_num_result_2 := std_logic_vector(to_unsigned(cnt1h_num_2, 16));
		cnt1h_num_result_3 := std_logic_vector(to_unsigned(cnt1h_num_3, 16));
		cnt1h_num_result_4 := std_logic_vector(to_unsigned(cnt1h_num_4, 16));
		cnt1h_num_result_5 := std_logic_vector(to_unsigned(cnt1h_num_5, 16));
		cnt1h_num_result_6 := std_logic_vector(to_unsigned(cnt1h_num_6, 16));	  
		cnt1h_num_result_7 := std_logic_vector(to_unsigned(cnt1h_num_7, 16));		
		cnt1h_num_result_8 := std_logic_vector(to_unsigned(cnt1h_num_8, 16));
		
		
		
        rd(15 downto 0) <= cnt1h_num_result_1;
		rd(31 downto 16) <= cnt1h_num_result_2;
		rd(47 downto 32) <= cnt1h_num_result_3;
		rd(63 downto 48) <= cnt1h_num_result_4;
		rd(79 downto 64) <= cnt1h_num_result_5;
		rd(95 downto 80) <= cnt1h_num_result_6;
		rd(111 downto 96) <= cnt1h_num_result_7;
		rd(127 downto 112) <= cnt1h_num_result_8;

		
		
		   
        when "1100" =>
         
		clzh_num_1:= 0;
		 clzh_num_2:= 0;
		 clzh_num_3:= 0;
		 clzh_num_4:= 0;
		 clzh_num_5:= 0;
		 clzh_num_6:= 0;
		 clzh_num_7:= 0;
		 clzh_num_8:= 0;
		 
		 
		 
		clzh_index := 15;
        
        for i in 0 to 15 loop
            if rs1(clzh_index) = '0' then
                clzh_num_1 := clzh_num_1 + 1; 
          		clzh_index := clzh_index - 1;									  
		 	else
				exit; 
			end if;
        end loop;	
				   
	
			  
		clzh_index := 31;
      
        for i in 0 to 15 loop
            if rs1(clzh_index) = '0' then
                clzh_num_2 := clzh_num_2 + 1;  
          		clzh_index := clzh_index - 1;									  
		 	else
				exit;  
			end if;
        end loop;	
		
		
				  
		clzh_index := 47;
       
        for i in 0 to 15 loop
            if rs1(clzh_index) = '0' then
                clzh_num_3 := clzh_num_3 + 1; 
          		clzh_index := clzh_index - 1;									  
		 	else
				exit; 
			end if;
        end loop;	
		
		
			
		clzh_index := 63;
        
        for i in 0 to 15 loop
            if rs1(clzh_index) = '0' then
                clzh_num_4 := clzh_num_4 + 1;  
          		clzh_index := clzh_index - 1;									  
		 	else
				exit; 
			end if;
        end loop;	
		
		
			 
		clzh_index := 79;
       
        for i in 0 to 15 loop
            if rs1(clzh_index) = '0' then
                clzh_num_5 := clzh_num_5 + 1; 
          		clzh_index := clzh_index - 1;									  
		 	else
				exit; 
			end if;
        end loop;	
		
		
		  
		clzh_index := 95;
       
        for i in 0 to 15 loop
            if rs1(clzh_index) = '0' then
                clzh_num_6 := clzh_num_6 + 1;  
          		clzh_index := clzh_index - 1;									  
		 	else
				exit; 
			end if;
        end loop;	
		
		
			
		clzh_index := 111;
       
        for i in 0 to 15 loop
            if rs1(clzh_index) = '0' then
                clzh_num_7 := clzh_num_7 + 1; 
          		clzh_index := clzh_index - 1;									  
		 	else
				exit;
			end if;
        end loop;	
		
		
			
		clzh_index := 127;
       
        for i in 0 to 15 loop
            if rs1(clzh_index) = '0' then
                clzh_num_8 := clzh_num_8 + 1;  
          		clzh_index := clzh_index - 1;									  
		 	else
				exit;  
			end if;
        end loop;	
		
	
		
        clzh_num_result_1 := std_logic_vector(to_unsigned(clzh_num_1, 16));
		clzh_num_result_2 := std_logic_vector(to_unsigned(clzh_num_2, 16));
		clzh_num_result_3 := std_logic_vector(to_unsigned(clzh_num_3, 16));
		clzh_num_result_4 := std_logic_vector(to_unsigned(clzh_num_4, 16));
		clzh_num_result_5 := std_logic_vector(to_unsigned(clzh_num_5, 16));
		clzh_num_result_6 := std_logic_vector(to_unsigned(clzh_num_6, 16));	  
		clzh_num_result_7 := std_logic_vector(to_unsigned(clzh_num_7, 16));		
		clzh_num_result_8 := std_logic_vector(to_unsigned(clzh_num_8, 16));
		
		
		rd(15 downto 0) <= clzh_num_result_1;
		rd(31 downto 16) <= clzh_num_result_2;
		rd(47 downto 32) <= clzh_num_result_3;
		rd(63 downto 48) <= clzh_num_result_4;
		rd(79 downto 64) <= clzh_num_result_5;
		rd(95 downto 80) <= clzh_num_result_6;
		rd(111 downto 96) <= clzh_num_result_7;
		rd(127 downto 112) <= clzh_num_result_8;


		
		
			
		when "0100" =>
		
		
    ahs_sum_1 := signed(rs1(15 downto 0)) + signed(rs2(15 downto 0));
    ahs_sum_2 := signed(rs1(31 downto 16)) + signed(rs2(31 downto 16));
    ahs_sum_3 := signed(rs1(47 downto 32)) + signed(rs2(47 downto 32));
    ahs_sum_4 := signed(rs1(63 downto 48)) + signed(rs2(63 downto 48));	
    ahs_sum_5 := signed(rs1(79 downto 64)) + signed(rs2(79 downto 64));
    ahs_sum_6 := signed(rs1(95 downto 80)) + signed(rs2(95 downto 80));
    ahs_sum_7 := signed(rs1(111 downto 96)) + signed(rs2(111 downto 96));
    ahs_sum_8 := signed(rs1(127 downto 112)) + signed(rs2(127 downto 112));


	
		ahs_sum_sign_1 := rs1(15) xor rs2(15);          
		
		if (rs1(15) = ahs_sum_sign_1) then
    		if not(ahs_sum_sign_1 = ahs_sum_1(15)) then 
            if (ahs_sum_sign_1 = '1') then ahs_sum_1 := "1000000000000000";
            elsif (ahs_sum_sign_1 = '0') then ahs_sum_1 := "1111111111111111";			
            end if;
        else
        
           
        end if;
    else

   
end if; 

	ahs_sum_sign_2 := rs1(31) xor rs2(31);          
		
		if (rs1(31) = ahs_sum_sign_2) then
    if not(ahs_sum_sign_2 = ahs_sum_2(15)) then 
            if (ahs_sum_sign_2 = '1') then ahs_sum_2 := "1000000000000000";
            elsif (ahs_sum_sign_2 = '0') then ahs_sum_2 := "1111111111111111";				   -- change these to 16 bit values
            end if;
        else
            
        end if;
    else
    
end if;

  
	ahs_sum_sign_3 := rs1(47) xor rs2(47);          
		
		if (rs1(47) = ahs_sum_sign_3) then
    if not(ahs_sum_sign_3 = ahs_sum_3(15)) then 
            if (ahs_sum_sign_3 = '1') then ahs_sum_3 := "1000000000000000";
            elsif (ahs_sum_sign_3 = '0') then ahs_sum_3 := "1111111111111111";				   -- change these to 16 bit values
            end if;
        else
        
        end if;
    else
      
end if;	  


			ahs_sum_sign_4 := rs1(63) xor rs2(63);          
			
			
		if (rs1(63) = ahs_sum_sign_4) then
    if not(ahs_sum_sign_4 = ahs_sum_4(15)) then 
            if (ahs_sum_sign_4 = '1') then ahs_sum_4 := "1000000000000000";
            elsif (ahs_sum_sign_4 = '0') then ahs_sum_4 := "1111111111111111";				
            end if;
        else
           
			
        end if;
    else
       
		
end if;


			ahs_sum_sign_5 := rs1(79) xor rs2(79);          
			
			
		if (rs1(79) = ahs_sum_sign_5) then
    if not(ahs_sum_sign_5 = ahs_sum_5(15)) then 
            if (ahs_sum_sign_5 = '1') then ahs_sum_5 := "1000000000000000";
            elsif (ahs_sum_sign_5 = '0') then ahs_sum_5 := "1111111111111111";		
            end if;
        else
           
           
        end if;
    else
       
end if;


   
			ahs_sum_sign_6 := rs1(95) xor rs2(95);          
			
			
		if (rs1(95) = ahs_sum_sign_6) then
    if not(ahs_sum_sign_6 = ahs_sum_6(15)) then 
            if (ahs_sum_sign_6 = '1') then ahs_sum_6 := "1000000000000000";
            elsif (ahs_sum_sign_6 = '0') then ahs_sum_6 := "1111111111111111";				   -- change these to 16 bit values
            end if;
        else
          
           
        end if;
    else
        
   
end if;

	ahs_sum_sign_7 := rs1(111) xor rs2(111);          
	
	
		if (rs1(111) = ahs_sum_sign_7) then
    if not(ahs_sum_sign_7 = ahs_sum_7(15)) then 
            if (ahs_sum_sign_7 = '1') then ahs_sum_7 := "1000000000000000";
            elsif (ahs_sum_sign_7 = '0') then ahs_sum_7 := "1111111111111111";				   -- change these to 16 bit values
            end if;
        else
           
			
        end if;
    else
      
		
end if;

	ahs_sum_sign_8 := rs1(127) xor rs2(127);          
	
	
		if (rs1(127) = ahs_sum_sign_8) then
    if not(ahs_sum_sign_8 = ahs_sum_8(15)) then 
            if (ahs_sum_sign_8 = '1') then ahs_sum_8 := "1000000000000000";
            elsif (ahs_sum_sign_8 = '0') then ahs_sum_8 := "1111111111111111";				  
            end if;
        else
           
			
        end if;
    else
      
   
end if;


	temp_result := (others => '0');
    temp_result(15 downto 0) := ahs_sum_1 (15 downto 0);
    temp_result(31 downto 16) := ahs_sum_2 (15 downto 0);
    temp_result(47 downto 32)  := ahs_sum_3 (15 downto 0);
    temp_result(63 downto 48) := ahs_sum_4 (15 downto 0);
    temp_result(79 downto 64) := ahs_sum_5 (15 downto 0);
    temp_result(95 downto 80)  := ahs_sum_6 (15 downto 0);
    temp_result(111 downto 96) := ahs_sum_7 (15 downto 0);
    temp_result(127 downto 112)  := ahs_sum_8 (15 downto 0);


    rd <= std_logic_vector(temp_result);		

 	
	
	
			
		when "0101" =>
         
			rd <= rs1 and rs2;	  
		
			
		when "1011" =>
         
			rd <= rs1 or rs2;

			
			
		when "0110" =>
           
	rd(31 downto 0) <= std_logic_vector(rs1(31 downto 0));
    rd(63 downto 32) <= std_logic_vector(rs1(31 downto 0));
    rd(95 downto 64) <= std_logic_vector(rs1(31 downto 0));
    rd(127 downto 96) <= std_logic_vector(rs1(31 downto 0));
	
	
		when "0111" =>
		
		
		maxws_rs1 := to_integer(signed(rs1(31 downto 0)));
		maxws_rs2 := to_integer(signed(rs2(31 downto 0)));
		
		 if maxws_rs1 >= maxws_rs2 then
        
        rd(31 downto 0) <= std_logic_vector(to_signed(maxws_rs1, 32));
    else
       
        rd(31 downto 0) <= std_logic_vector(to_signed(maxws_rs2, 32));
    end if;
    
		
		maxws_rs1 := to_integer(signed(rs1(63 downto 32)));
		maxws_rs2 := to_integer(signed(rs2(63 downto 32)));
		
		 if maxws_rs1 >= maxws_rs2 then
       
        rd(63 downto 32) <= std_logic_vector(to_signed(maxws_rs1, 32));
    else
       
        rd(63 downto 32) <= std_logic_vector(to_signed(maxws_rs2, 32));
    end if;   
			
	
	
		maxws_rs1 := to_integer(signed(rs1(95 downto 64)));
		maxws_rs2 := to_integer(signed(rs2(95 downto 64)));
		
		 if maxws_rs1 >= maxws_rs2 then
     
        rd(95 downto 64) <= std_logic_vector(to_signed(maxws_rs1, 32));
    else
      
        rd(95 downto 64) <= std_logic_vector(to_signed(maxws_rs2, 32));
    end if;   
				
			   
 
		
		maxws_rs1 := to_integer(signed(rs1(127 downto 96)));
		maxws_rs2 := to_integer(signed(rs2(127 downto 96)));
		
		 if maxws_rs1 >= maxws_rs2 then
      
        rd(127 downto 96) <= std_logic_vector(to_signed(maxws_rs1, 32));
    else
       
        rd(127 downto 96) <= std_logic_vector(to_signed(maxws_rs2, 32));
    end if;   
				
			   
	
			
		when "1001" =>
      
	        mlhu_mult_1 := unsigned(rs2(15 downto 0)) * unsigned(rs1(15 downto 0));
	        
			mlhu_mult_2 := unsigned(rs2(47 downto 32)) * unsigned(rs1(47 downto 32));
	        mlhu_mult_3 := unsigned(rs2(79 downto 64)) * unsigned(rs1(79 downto 64));
	        mlhu_mult_4 := unsigned(rs2(111 downto 96)) * unsigned(rs1(111 downto 96));
				
											 
	    temp_result_multiply := (others => '0');
		temp_result_multiply(31 downto 0) := mlhu_mult_1(31 downto 0);
	    temp_result_multiply(63 downto 32) := mlhu_mult_2(31 downto 0);
	    temp_result_multiply(95 downto 64) := mlhu_mult_3(31 downto 0);
	    temp_result_multiply(127 downto 96) := mlhu_mult_4(31 downto 0);
									  
	    rd <= std_logic_vector(temp_result_multiply);		
		
		
			
				
		when "1010" =>
              
      
        mlhcu_temp_mult_1 := unsigned(opcode(14 downto 10)) * unsigned(rs1(15 downto 0));
		mlhcu_temp_mult_2 := unsigned(opcode(14 downto 10)) * unsigned(rs1(47 downto 32));
        mlhcu_temp_mult_3 := unsigned(opcode(14 downto 10)) * unsigned(rs1(79 downto 64));
        mlhcu_temp_mult_4 := unsigned(opcode(14 downto 10)) * unsigned(rs1(111 downto 96));
		
		mlhcu_mult_1 := "00000000000" & mlhcu_temp_mult_1;
		mlhcu_mult_2 := "00000000000" & mlhcu_temp_mult_2;
        mlhcu_mult_3 := "00000000000" & mlhcu_temp_mult_3;
        mlhcu_mult_4 := "00000000000" & mlhcu_temp_mult_4;
		
	  
	    mlhcu_result := (others => '0');
	    mlhcu_result(31 downto 0) := mlhcu_mult_1(31 downto 0);
	    mlhcu_result(63 downto 32) := mlhcu_mult_2(31 downto 0);
	    mlhcu_result(95 downto 64) := mlhcu_mult_3(31 downto 0);
	    mlhcu_result(127 downto 96) := mlhcu_mult_4(31 downto 0);
		
	
		rd <= std_logic_vector(mlhcu_result);
				
		
		
		
			
		when "1101" =>
           
         
        rotate_num := to_integer(unsigned(rs2(3 downto 0)));
		
		rlh_temp (rotate_num-1 downto 0) := rs1(15 downto (15-rotate_num+1));
		rlh_rotate_1 :=  std_logic_vector(shift_left(unsigned(rs1(15 downto 0)), rotate_num)); 
		rlh_rotate_1 (rotate_num-1 downto 0) := rlh_temp (rotate_num-1 downto 0);
				
		rotate_num := to_integer(unsigned(rs2(19 downto 16)));
		
		rlh_temp (rotate_num-1 downto 0) := rs1(31 downto (31-rotate_num+1))  ;
		rlh_rotate_2 :=  std_logic_vector(shift_left(unsigned(rs1(31 downto 16)), rotate_num)); 
		rlh_rotate_2 (rotate_num-1 downto 0) := rlh_temp (rotate_num-1 downto 0);
		
		rotate_num := to_integer(unsigned(rs2(47 downto 32)));
		
		rlh_temp (rotate_num-1 downto 0) := rs1(47 downto (47-rotate_num+1))  ;
		rlh_rotate_3 :=  std_logic_vector(shift_left(unsigned(rs1(47 downto 32)), rotate_num)); 
		rlh_rotate_3 (rotate_num-1 downto 0) := rlh_temp (rotate_num-1 downto 0);
		
		rotate_num := to_integer(unsigned(rs2(63 downto 48)));
		
		rlh_temp (rotate_num-1 downto 0) := rs1(63 downto (63-rotate_num+1))  ;
		rlh_rotate_4 :=  std_logic_vector(shift_left(unsigned(rs1(63 downto 48)), rotate_num)); 
		rlh_rotate_4 (rotate_num-1 downto 0) := rlh_temp (rotate_num-1 downto 0);
						 
		rotate_num := to_integer(unsigned(rs2(79 downto 64)));
		
		rlh_temp (rotate_num-1 downto 0) := rs1(79 downto (79-rotate_num+1))  ;
		rlh_rotate_5 :=  std_logic_vector(shift_left(unsigned(rs1(79 downto 64)), rotate_num)); 
		rlh_rotate_5 (rotate_num-1 downto 0) := rlh_temp (rotate_num-1 downto 0);
		
		rotate_num := to_integer(unsigned(rs2(95 downto 80)));
		
		rlh_temp (rotate_num-1 downto 0) := rs1(95 downto (95-rotate_num+1))  ;
		rlh_rotate_6 :=  std_logic_vector(shift_left(unsigned(rs1(95 downto 80)), rotate_num)); 
		rlh_rotate_6 (rotate_num-1 downto 0) := rlh_temp (rotate_num-1 downto 0);
		
		
		
		rotate_num := to_integer(unsigned(rs2(111 downto 96)));
		
		
		rlh_temp (rotate_num-1 downto 0) := rs1(111 downto (111-rotate_num+1))  ;
		rlh_rotate_7 :=  std_logic_vector(shift_left(unsigned(rs1(111 downto 96)), rotate_num)); 
		rlh_rotate_7 (rotate_num-1 downto 0) := rlh_temp (rotate_num-1 downto 0);
		
		rotate_num := to_integer(unsigned(rs2(127 downto 112)));
		
		
		rlh_temp (rotate_num-1 downto 0) := rs1(127 downto (127-rotate_num+1))  ;
		rlh_rotate_8 :=  std_logic_vector(shift_left(unsigned(rs1(127 downto 112)), rotate_num)); 
		rlh_rotate_8 (rotate_num-1 downto 0) := rlh_temp (rotate_num-1 downto 0);
		
		
    rd(15 downto 0) <= rlh_rotate_1;
	rd(31 downto 16) <= rlh_rotate_2;
	rd(47 downto 32) <= rlh_rotate_3;
	rd(63 downto 48) <= rlh_rotate_4; 
	rd(79 downto 64) <= rlh_rotate_5;
	rd(95 downto 80) <= rlh_rotate_6;
	rd(111 downto 96) <= rlh_rotate_7;
	rd(127 downto 112) <= rlh_rotate_8;
			
	
	
	
			
		when "1110" =>
        
		
    sfwu_dif_1:= unsigned(rs2(31 downto 0)) - unsigned(rs1(31 downto 0)) ;
    sfwu_dif_2:= unsigned(rs2(63 downto 32)) - unsigned(rs1(63 downto 32)) ;
    sfwu_dif_3:= unsigned(rs2(95 downto 64)) - unsigned(rs1(95 downto 64))	 ;
    sfwu_dif_4:= unsigned(rs2(127 downto 96)) - unsigned(rs1(127 downto 96)) ;
				 
	
    temp_result := (others => '0');
    temp_result(31 downto 0) := signed(sfwu_dif_1(31 downto 0));
    temp_result(63 downto 32) := signed(sfwu_dif_2(31 downto 0));
    temp_result(95 downto 64) := signed(sfwu_dif_3(31 downto 0));
    temp_result(127 downto 96) := signed(sfwu_dif_4(31 downto 0));

 
    rd <= std_logic_vector(temp_result);	
	
	
	
	
			
			
		when "1111" =>
		
		
    slhs_dif_1 := signed(rs2(15 downto 0))- signed(rs1(15 downto 0));
    slhs_dif_2 := signed(rs2(31 downto 16)) - signed(rs1(31 downto 16));
    slhs_dif_3 := signed(rs2(47 downto 32)) -  signed(rs1(47 downto 32));
    slhs_dif_4 := signed(rs2(63 downto 48)) - signed(rs1(63 downto 48)) ;	
    slhs_dif_5 := signed(rs2(79 downto 64)) - signed(rs1(79 downto 64));
    slhs_dif_6 := signed(rs2(95 downto 80)) - signed(rs1(95 downto 80));
    slhs_dif_7 := signed(rs2(111 downto 96)) - signed(rs1(111 downto 96));
    slhs_dif_8 := signed(rs2(127 downto 112)) - signed(rs1(127 downto 112));


		sfhs_dif_satur_1 := to_integer(signed(rs2(15 downto 0))) - to_integer(signed(rs1(15 downto 0)));	  
		if (sfhs_dif_satur_1 > 32767 )then slhs_dif_1 := "0111111111111111";
        elsif (sfhs_dif_satur_1  < -32768 )then slhs_dif_1 := "1000000000000000";
        end if; 		
			
	  					   
       	sfhs_dif_satur_2 := to_integer(signed(rs2(31 downto 16))) - to_integer(signed(rs1(31 downto 16)));	  
		if (sfhs_dif_satur_2 > 32767  ) then slhs_dif_2 := "0111111111111111";
        elsif (sfhs_dif_satur_2  < -32768 ) then slhs_dif_2 := "1000000000000000" ;
        end if; 
	
	
       	sfhs_dif_satur_3 := to_integer(signed(rs2(47 downto 32))) - to_integer(signed(rs1(47 downto 32)));	  
		if (sfhs_dif_satur_3 > 32767 )then slhs_dif_3 := "0111111111111111";
        elsif (sfhs_dif_satur_3  < -32768 )then slhs_dif_3 := "1000000000000000";
        end if; 

	
       	sfhs_dif_satur_4 := to_integer(signed(rs2(63 downto 48))) - to_integer(signed(rs1(63 downto 48)));	  
		if (sfhs_dif_satur_4 > 32767 ) then slhs_dif_4 := "0111111111111111" ;
        elsif (sfhs_dif_satur_4  < -32768 ) then slhs_dif_4 := "1000000000000000"  ;
        end if; 

		
	
       	sfhs_dif_satur_5 := to_integer(signed(rs2(79 downto 64))) - to_integer(signed(rs1(79 downto 64)));	  
		if (sfhs_dif_satur_5 > 32767 ) then slhs_dif_5 := "0111111111111111" ;
        elsif (sfhs_dif_satur_5  < -32768 ) then slhs_dif_5 := "1000000000000000"  ;
        end if; 	
	
	
       	sfhs_dif_satur_6 := to_integer(signed(rs2(95 downto 80))) - to_integer(signed(rs1(95 downto 80)));	  
		if (sfhs_dif_satur_6 > 32767 ) then slhs_dif_6 := "0111111111111111" ;
        elsif (sfhs_dif_satur_6  < -32768 ) then slhs_dif_6 := "1000000000000000"  ;
        end if; 	
		
	
       	sfhs_dif_satur_7 := to_integer(signed(rs2(111 downto 96))) - to_integer(signed(rs1(111 downto 96)));	  
		if (sfhs_dif_satur_7 > 32767 ) then slhs_dif_7 := "0111111111111111" ;
        elsif (sfhs_dif_satur_7  < -32768 ) then slhs_dif_7 := "1000000000000000"  ;
        end if; 	
		
	
       	sfhs_dif_satur_8 := to_integer(signed(rs2(127 downto 112))) - to_integer(signed(rs1(127 downto 112)));	  
		if (sfhs_dif_satur_8 > 32767 ) then slhs_dif_8 := "0111111111111111" ;
        elsif (sfhs_dif_satur_8  < -32768 ) then slhs_dif_8 := "1000000000000000"  ;
        end if; 	


						   
    temp_result := (others => '0');
    temp_result(15 downto 0) := slhs_dif_1 (15 downto 0);
    temp_result(31 downto 16) := slhs_dif_2 (15 downto 0);
    temp_result(47 downto 32)  := slhs_dif_3 (15 downto 0);
    temp_result(63 downto 48) := slhs_dif_4 (15 downto 0);
    temp_result(79 downto 64) := slhs_dif_5 (15 downto 0);
    temp_result(95 downto 80)  := slhs_dif_6 (15 downto 0);
    temp_result(111 downto 96) := slhs_dif_7 (15 downto 0);
    temp_result(127 downto 112)  := slhs_dif_8 (15 downto 0);


    rd <= std_logic_vector(temp_result);		

 	
			
			
        when others =>
            -- 
            rd <= (others => '0'); 
    end case;
	
	
		
case opcode(18 downto 15) is
	when "1000" =>
	
	
		
		minws_rs1 := to_integer(signed(rs1(31 downto 0)));
		minws_rs2 := to_integer(signed(rs2(31 downto 0)));
		
		 if minws_rs1 <= minws_rs2 then
       
        rd(31 downto 0) <= std_logic_vector(to_signed(minws_rs1, 32));
    else
        
        rd(31 downto 0) <= std_logic_vector(to_signed(minws_rs2, 32));
    end if;
    
	
		
		minws_rs1 := to_integer(signed(rs1(63 downto 32)));
		minws_rs2 := to_integer(signed(rs2(63 downto 32)));
		
		
		 if minws_rs1 <= minws_rs2 then
        
        rd(63 downto 32) <= std_logic_vector(to_signed(minws_rs1, 32));
    else
       
        rd(63 downto 32) <= std_logic_vector(to_signed(minws_rs2, 32));
    end if;
		

		minws_rs1 := to_integer(signed(rs1(95 downto 64)));
		minws_rs2 := to_integer(signed(rs2(95 downto 64)));
		
		 if minws_rs1 <= minws_rs2 then
       
        rd(95 downto 64) <= std_logic_vector(to_signed(minws_rs1, 32));
    else
       
        rd(95 downto 64) <= std_logic_vector(to_signed(minws_rs2, 32));
    end if;
				
			   
		
		minws_rs1 := to_integer(signed(rs1(127 downto 96)));
		minws_rs2 := to_integer(signed(rs2(127 downto 96)));
		
		  if minws_rs1 <= minws_rs2 then
       
        rd(127 downto 96) <= std_logic_vector(to_signed(minws_rs1, 32));
    else
		
        rd(127 downto 96) <= std_logic_vector(to_signed(minws_rs2, 32));
    end if;
			
 			
	when others =>
          
            
   	 end case;
	
	
	
	end if;	

 	else 
		   
	
		
	 end if;	 
	 
	 
	
	 

  end process;
	
end architecture alu_arch;