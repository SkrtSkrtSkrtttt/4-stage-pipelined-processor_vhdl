library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use work.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;		   
use std.textio.all;	


entity PMU_TB is 

end PMU_TB;


architecture testbench of PMU_TB is	 
  
	file ResultsFile : text;
	
	signal reg_count  : integer := 0;
	signal count : integer := 0;
	signal cycle_count : integer := 0; 
	signal INDEX_BITS  : integer := 0;
	signal reg_image : std_logic_vector(127 downto 0);
	  
	signal clk, hold            :  std_logic;
	signal reset_bar      :  std_logic;
	signal PMU_INSTRUCTION_IN		 :  std_logic_vector(24 downto 0);
	signal Instruction_Number_Programming :  std_logic_vector(6 downto 0); 
	
	
	signal S1_PC  :  std_logic_vector(5 downto 0);
	signal ProgramMemoryIB:  std_logic_vector (1650 downto 0); 	
	signal S1_NextInstruction :  std_logic_vector(24 downto 0);
	
	
	signal S2_Instruction:  std_logic_vector(24 downto 0);	
	signal RegisterfFileData :  std_logic_vector (4095 downto 0);
	signal S2_RF_rs1:  std_logic_vector(127 downto 0);
	signal S2_RF_rs2:  std_logic_vector(127 downto 0);
	signal S2_RF_rs3:  std_logic_vector(127 downto 0); 
	signal S2_RF_opcode:  std_logic_vector(24 downto 0);
	
	
	signal S3_IDEXregrs1_to_EX: std_logic_vector(127 downto 0);
	signal S3_IDEXregrs2_to_EX:  std_logic_vector(127 downto 0);
	signal S3_IDEXregrs3_to_EX:  std_logic_vector(127 downto 0); 
	signal S3_IDEXregopcode_to_EX:  std_logic_vector(24 downto 0);	   
	signal S3_rd_alu:  std_logic_vector(127 downto 0); 
	signal S3_op_alu:  std_logic_vector(24 downto 0);	   
	signal S3_ForwardedData:  std_logic_vector(127 downto 0); 
	signal S3_ForwardedOpCode:  std_logic_vector(24 downto 0);
	
	
	signal S4_EX_WBreg_rd:  std_logic_vector(127 downto 0); 
	signal S4_EX_WBreg_op:  std_logic_vector(24 downto 0);	   
	signal S4_Write_Enable:  std_logic;
	
	
	signal			reg_0_out: std_logic_vector(127 downto 0); 
	signal			reg_1_out: std_logic_vector(127 downto 0);
	signal			reg_2_out: std_logic_vector(127 downto 0);
	signal			reg_3_out: std_logic_vector(127 downto 0);
	signal			reg_4_out: std_logic_vector(127 downto 0);
	signal			reg_5_out: std_logic_vector(127 downto 0);
	signal			reg_6_out: std_logic_vector(127 downto 0);
	signal			reg_7_out: std_logic_vector(127 downto 0);
	signal			reg_8_out: std_logic_vector(127 downto 0);
	signal			reg_9_out: std_logic_vector(127 downto 0);
	signal			reg_10_out: std_logic_vector(127 downto 0);
	signal			reg_11_out: std_logic_vector(127 downto 0);
	signal			reg_12_out: std_logic_vector(127 downto 0);
	signal			reg_13_out: std_logic_vector(127 downto 0);
	signal			reg_14_out: std_logic_vector(127 downto 0);
	signal			reg_15_out: std_logic_vector(127 downto 0);
	signal			reg_16_out: std_logic_vector(127 downto 0);
	signal			reg_17_out: std_logic_vector(127 downto 0);
	signal			reg_18_out: std_logic_vector(127 downto 0);
	signal			reg_19_out: std_logic_vector(127 downto 0);
	signal			reg_20_out: std_logic_vector(127 downto 0);
	signal			reg_21_out: std_logic_vector(127 downto 0);
	signal			reg_22_out: std_logic_vector(127 downto 0);
	signal			reg_23_out: std_logic_vector(127 downto 0);
	signal			reg_24_out: std_logic_vector(127 downto 0);
	signal			reg_25_out: std_logic_vector(127 downto 0);
	signal			reg_26_out: std_logic_vector(127 downto 0);
	signal			reg_27_out: std_logic_vector(127 downto 0);
	signal			reg_28_out: std_logic_vector(127 downto 0);
	signal			reg_29_out: std_logic_vector(127 downto 0);
	signal			reg_30_out: std_logic_vector(127 downto 0);
	signal			reg_31_out: std_logic_vector(127 downto 0);
					
			
begin
	  
    PMU_Instance: entity work.PMU
        port map (	
	   clk => clk , reset_bar => reset_bar, hold => hold , Instruction_Number_Programming => Instruction_Number_Programming, PMU_INSTRUCTION_IN => PMU_INSTRUCTION_IN,  S1_PC => S1_PC, 
	   ProgramMemoryIB => ProgramMemoryIB, S1_NextInstruction => S1_NextInstruction, S2_Instruction => S2_Instruction, RegisterfFileData => RegisterfFileData , S2_RF_rs1 => S2_RF_rs1, 
	   S2_RF_rs2 => S2_RF_rs2, S2_RF_rs3 => S2_RF_rs3,  S2_RF_opcode => S2_RF_opcode, S3_IDEXregrs1_to_EX => S3_IDEXregrs1_to_EX ,  S3_IDEXregrs2_to_EX => S3_IDEXregrs2_to_EX, 
	   S3_IDEXregrs3_to_EX => S3_IDEXregrs3_to_EX, S3_IDEXregopcode_to_EX =>S3_IDEXregopcode_to_EX , S3_rd_alu => S3_rd_alu, S3_op_alu => S3_op_alu,  S3_ForwardedData => S3_ForwardedData, 
	   S3_ForwardedOpCode => S3_ForwardedOpCode, S4_EX_WBreg_rd => S4_EX_WBreg_rd, S4_EX_WBreg_op => S4_EX_WBreg_op , S4_Write_Enable => S4_Write_Enable, reg_0_out=>reg_0_out, reg_1_out=>reg_1_out, reg_2_out=>reg_2_out, reg_3_out=>reg_3_out, reg_4_out=>reg_4_out, reg_5_out=>reg_5_out, reg_6_out=>reg_6_out, reg_7_out=>reg_7_out, 
		reg_8_out=>reg_8_out, reg_9_out=>reg_9_out, reg_10_out=>reg_10_out, reg_11_out=>reg_11_out, reg_12_out=>reg_12_out, reg_13_out=>reg_13_out, reg_14_out=>reg_14_out, reg_15_out=>reg_15_out, 
		reg_16_out=>reg_16_out, reg_17_out=>reg_17_out, reg_18_out=>reg_18_out, reg_19_out=>reg_19_out, reg_20_out=>reg_20_out, reg_21_out=>reg_21_out, reg_22_out=>reg_22_out, reg_23_out=>reg_23_out, 
		reg_24_out=>reg_24_out, reg_25_out=>reg_25_out, reg_26_out=>reg_26_out, reg_27_out=>reg_27_out, reg_28_out=>reg_28_out, reg_29_out=>reg_29_out, reg_30_out=>reg_30_out, reg_31_out=>reg_31_out 
	);
									 

  stimulus_process: process

  file input_file : text open read_mode is "input_data.txt";  
  	

  variable out_line : line;
  variable bit_string : string(1 to 25);  
  variable long_bit_string : string(1 to 128);
  
  	variable reg_count  : integer := 0;
  begin			  
			  
    file_open(ResultsFile, "results.txt", write_mode); 
  
	reset_bar <= '0';		
	
	wait for 10ns;	  
	
	count <= -1;
	hold <= '1';			    
	reset_bar <= '1'; 
	clk <= '1';
	 
	  
 while not endfile(input_file) loop
      
      readline(input_file, out_line);

     
      read(out_line, bit_string);
	  
	  count <= count+1;
	  Instruction_Number_Programming <= std_logic_vector(to_unsigned(count, 7));

	  
			
			for i in 1 to 25 loop 
				
			  if bit_string(i) = '0' then
			    PMU_INSTRUCTION_IN(i - 1) <= '0';				  
			  elsif bit_string(i) = '1' then
			    PMU_INSTRUCTION_IN(i - 1) <= '1';
			  else
			  					
			    PMU_INSTRUCTION_IN(i - 1) <= '0'; 
			  end if;
			  
			end loop;
	
	 
      wait for 10 ns; 
end loop; 

	count <= count+1;
	Instruction_Number_Programming <= std_logic_vector(to_unsigned(count, 7));
	PMU_INSTRUCTION_IN <= "0000000000000010000000011";
	
	wait for 10 ns; 

	hold <= '0';
	
	 
	
	for i in 1 to 140 loop							 
													
		clk<= not clk;	
		wait for 10ns;								 
		
		if (clk = '1') then	   
		  


 write(out_line , "-- " & integer'image(cycle_count) & " Clock Cycles----------------------------", right, 0);
 writeline(ResultsFile, out_line);
 write(out_line, " ", right, 0 );
 writeline(ResultsFile, out_line);
 
 
		write(out_line, "-- S1");
		writeline(ResultsFile, out_line);
		write(out_line, "S1_PC:                  " & to_string(S1_PC) & "       [6]");
		writeline(ResultsFile, out_line);

		write(out_line, "S1_NextInstruction:     " & to_string(S1_NextInstruction) & " [25]");
		writeline(ResultsFile, out_line);
	
		write(out_line," ", right, 0 );
		writeline(ResultsFile, out_line);
		write(out_line, "-- S2");
		writeline(ResultsFile, out_line);
		write(out_line, "S2_Instruction:         " & to_string(S2_Instruction) & " [25]");
		writeline(ResultsFile, out_line);

		write(out_line," ", right, 0 );
		writeline(ResultsFile, out_line);
		write(out_line, "-- RF");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_0_out:              " & to_string(reg_0_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_1_out:              " & to_string(reg_1_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_2_out:              " & to_string(reg_2_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_3_out:              " & to_string(reg_3_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_4_out:              " & to_string(reg_4_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_5_out:              " & to_string(reg_5_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_6_out:              " & to_string(reg_6_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_7_out:              " & to_string(reg_7_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_8_out:              " & to_string(reg_8_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_9_out:              " & to_string(reg_9_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_10_out:             " & to_string(reg_10_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_11_out:             " & to_string(reg_11_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_12_out:             " & to_string(reg_12_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_13_out:             " & to_string(reg_13_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_14_out:             " & to_string(reg_14_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_15_out:             " & to_string(reg_15_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_16_out:             " & to_string(reg_16_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_17_out:             " & to_string(reg_17_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_18_out:             " & to_string(reg_18_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_19_out:             " & to_string(reg_19_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_20_out:             " & to_string(reg_20_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_21_out:             " & to_string(reg_21_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_22_out:             " & to_string(reg_22_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_23_out:             " & to_string(reg_23_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_24_out:             " & to_string(reg_24_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_25_out:             " & to_string(reg_25_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_26_out:             " & to_string(reg_26_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_27_out:             " & to_string(reg_27_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_28_out:             " & to_string(reg_28_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_29_out:             " & to_string(reg_29_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_30_out:             " & to_string(reg_30_out) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "reg_31_out:             " & to_string(reg_31_out) & " [128]");
		writeline(ResultsFile, out_line);
		

		 write(out_line," ", right, 0 );
		writeline(ResultsFile, out_line);
		write(out_line," ", right, 0 );
		writeline(ResultsFile, out_line);

		write(out_line, "S2_RF_rs1:              " & to_string(S2_RF_rs1) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "S2_RF_rs2:              " & to_string(S2_RF_rs2) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "S2_RF_rs3:              " & to_string(S2_RF_rs3) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "S2_RF_opcode:           " & to_string(S2_RF_opcode) & " [25]");
		writeline(ResultsFile, out_line);


		write(out_line," ", right, 0 );
		writeline(ResultsFile, out_line);
		write(out_line, " S3");
		writeline(ResultsFile, out_line);
		write(out_line, "S3_IDEXregrs1_to_EX:    " & to_string(S3_IDEXregrs1_to_EX) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "S3_IDEXregrs2_to_EX:    " & to_string(S3_IDEXregrs2_to_EX) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "S3_IDEXregrs3_to_EX:    " & to_string(S3_IDEXregrs3_to_EX) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "S3_IDEXregopcode_to_EX: " & to_string(S3_IDEXregopcode_to_EX) & " [25]");
		writeline(ResultsFile, out_line);
		write(out_line, "S3_rd_alu:              " & to_string(S3_rd_alu) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "S3_op_alu:              " & to_string(S3_op_alu) & " [25]");
		writeline(ResultsFile, out_line);
		write(out_line, "S3_ForwardedData:       " & to_string(S3_ForwardedData) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "S3_ForwardedOpCode:     " & to_string(S3_ForwardedOpCode) & " [25]");
		writeline(ResultsFile, out_line);



		write(out_line," ", right, 0 );
		writeline(ResultsFile, out_line);
		write(out_line, "-- S4");
		writeline(ResultsFile, out_line);
		write(out_line, "S4_EX_WBreg_rd:         " & to_string(S4_EX_WBreg_rd) & " [128]");
		writeline(ResultsFile, out_line);
		write(out_line, "S4_EX_WBreg_op:         " & to_string(S4_EX_WBreg_op) & " [25]");
		writeline(ResultsFile, out_line);
		write(out_line, "S4_Write_Enable:        " & to_string(S4_Write_Enable));
		writeline(ResultsFile, out_line);


		write(out_line," ", right, 0 );
		writeline(ResultsFile, out_line);write(out_line," ", right, 0 );
		writeline(ResultsFile, out_line);write(out_line," ", right, 0 );
		writeline(ResultsFile, out_line);write(out_line," ", right, 0 );
		writeline(ResultsFile, out_line);
		
	   cycle_count <= cycle_count +1;
			
		else 
			
		end if;
		
		
		
							  
	end loop;	

	

    file_close(ResultsFile);

		wait;
  end process stimulus_process;		
		
	
		
      
   
end testbench;

