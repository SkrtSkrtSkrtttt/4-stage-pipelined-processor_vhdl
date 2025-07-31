
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ALL;

entity PMU is

PORT
( 

	
	clk, hold            : IN std_logic;
	reset_bar      : IN std_logic;
	PMU_INSTRUCTION_IN		 : IN std_logic_vector(24 downto 0);
	Instruction_Number_Programming : IN std_logic_vector(6 downto 0);
		
		
	
	S1_PC: OUT std_logic_vector(5 downto 0);
	ProgramMemoryIB: out std_logic_vector (1650 downto 0); 	
	S1_NextInstruction : out std_logic_vector(24 downto 0);
	
	
	S2_Instruction: OUT std_logic_vector(24 downto 0);	
	
	
	RegisterfFileData : out std_logic_vector (4095 downto 0);
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
	
	S2_RF_rs1: OUT std_logic_vector(127 downto 0);
	S2_RF_rs2: OUT std_logic_vector(127 downto 0);
	S2_RF_rs3: OUT std_logic_vector(127 downto 0); 
	S2_RF_opcode: OUT std_logic_vector(24 downto 0);
	
	

	S3_IDEXregrs1_to_EX: OUT std_logic_vector(127 downto 0);
	S3_IDEXregrs2_to_EX: OUT std_logic_vector(127 downto 0);
	S3_IDEXregrs3_to_EX: OUT std_logic_vector(127 downto 0); 
	S3_IDEXregopcode_to_EX: OUT std_logic_vector(24 downto 0);	   

	S3_rd_alu: OUT std_logic_vector(127 downto 0); 
	S3_op_alu: OUT std_logic_vector(24 downto 0);	   
	S3_ForwardedData: OUT std_logic_vector(127 downto 0); 
	S3_ForwardedOpCode: OUT std_logic_vector(24 downto 0);
	
	S4_EX_WBreg_rd: OUT std_logic_vector(127 downto 0); 
	S4_EX_WBreg_op: OUT std_logic_vector(24 downto 0);	   
	S4_Write_Enable: out std_logic
		
	);
	
	
end PMU;						 
	
	
	
architecture structural OF PMU IS
	

	signal IB_IBFWDreg  : std_logic_vector(24 downto 0);	   
	signal IB_EMPTY     : std_logic;
	
	
	signal IBFWDreg_RF  : std_logic_vector(24 downto 0);		
	

	signal RF_rs1_out    : std_logic_vector(127 downto 0);
	signal RF_rs2_out    : std_logic_vector(127 downto 0);
	signal RF_rs3_out    : std_logic_vector(127 downto 0);
	signal RF_opcode_out : std_logic_vector(24 downto 0);
	signal reg_all       : std_logic_vector(4095 downto 0);	
			
		
	

	signal IDEXreg_rs1_out    : std_logic_vector(127 downto 0);
	signal IDEXreg_rs2_out    : std_logic_vector(127 downto 0);
	signal IDEXreg_rs3_out    : std_logic_vector(127 downto 0);
	signal IDEXreg_opcode_out : std_logic_vector(24 downto 0);
		  
	
	signal FWD_EX_RD_IN    : std_logic_vector(127 downto 0); 
	signal FWD_EX_OP_IN    : std_logic_vector(24 downto 0);
	
	
	signal RDFwd_to_ExFwdIN    : std_logic_vector(127 downto 0); 
	signal OpCodeFwd_to_ExFwdIN    : std_logic_vector(24 downto 0);	 
	
	
	
	
	
	signal ENGtoALUrs1    : std_logic_vector(127 downto 0);
	signal ENGtoALUrs2    : std_logic_vector(127 downto 0);
	signal ENGtoALUrs3    : std_logic_vector(127 downto 0);
	signal ENGtoALUopcode : std_logic_vector(24 downto 0);
	
	
	signal EX_rd_data    : std_logic_vector(127 downto 0); 
	signal EX_opcode_data   : std_logic_vector(24 downto 0);	 	
	
	signal EX_WB_reg_rd    : std_logic_vector(127 downto 0); 
	signal EX_WBreg_opcode   : std_logic_vector(24 downto 0);
	signal reg_write_enable : std_logic;  

	
	signal IB_IBfwd_V : std_logic; 	
	signal IBfwd_RF_V : std_logic;
	signal RF_ID_V : std_logic;
	signal ID_EX_V : std_logic;
	signal EX_ALU_V : std_logic;
	signal ALU_EXWB_V : std_logic;
	signal EXWB_RF_V : std_logic;
	signal EXWB_EX_V : std_logic;
	
	
			  
	begin																								   																		  
		

	instruction_buffer : entity instruction_buffer 
	    port map(clk => clk, reset_bar => reset_bar, hold => hold , INSTRUCTION_IN => PMU_INSTRUCTION_IN,
		instruction_number => Instruction_Number_Programming , next_opcode => IB_IBFWDreg, IB_empty => IB_EMPTY, 
		ProgramMemory_OUT => ProgramMemoryIB, Current_PC_Count => S1_PC, valid_out_flag => IB_IBfwd_V);
	  	
		S1_NextInstruction <= IB_IBFWDreg;												
		
		
  
	IB_FWDreg : entity IB_FWDreg 
		port map(clk => clk, reset_bar => reset_bar, IB_opcode => IB_IBFWDreg, IBfwd_opcode => IBFWDreg_RF, valid_out_flag => IBfwd_RF_V, valid_in_flag => IB_IBfwd_V);
		
		S2_Instruction <= IBFWDreg_RF;
		
		
	RF : entity RF 
		port map(clk => clk, reset_bar => reset_bar, hold=> hold , reg_out_all => reg_all, reg_A => RF_rs1_out, reg_B => RF_rs2_out, 
		reg_C => RF_rs3_out , opcode_out => RF_opcode_out, wb_reg_data =>  FWD_EX_RD_IN , register_write => reg_write_enable, 
		IB_empty => IB_EMPTY, opcode => IBFWDreg_RF, wb_opcodedata =>  FWD_EX_OP_IN, valid_out_flag => RF_ID_V, valid_in_flag => IBfwd_RF_V, valid_in_flag_WB => EXWB_RF_V, 
		reg_0_out=>reg_0_out, reg_1_out=>reg_1_out, reg_2_out=>reg_2_out, reg_3_out=>reg_3_out, reg_4_out=>reg_4_out, reg_5_out=>reg_5_out, reg_6_out=>reg_6_out, reg_7_out=>reg_7_out, 
		reg_8_out=>reg_8_out, reg_9_out=>reg_9_out, reg_10_out=>reg_10_out, reg_11_out=>reg_11_out, reg_12_out=>reg_12_out, reg_13_out=>reg_13_out, reg_14_out=>reg_14_out, reg_15_out=>reg_15_out, 
		reg_16_out=>reg_16_out, reg_17_out=>reg_17_out, reg_18_out=>reg_18_out, reg_19_out=>reg_19_out, reg_20_out=>reg_20_out, reg_21_out=>reg_21_out, reg_22_out=>reg_22_out, reg_23_out=>reg_23_out, 
		reg_24_out=>reg_24_out, reg_25_out=>reg_25_out, reg_26_out=>reg_26_out, reg_27_out=>reg_27_out, reg_28_out=>reg_28_out, reg_29_out=>reg_29_out, reg_30_out=>reg_30_out, reg_31_out=>reg_31_out );	   
		
		S2_RF_rs1 <= RF_rs1_out;
		
		S2_RF_rs2 <= RF_rs2_out;
		
		S2_RF_rs3 <= RF_rs3_out;
		
		S2_RF_opcode <= RF_opcode_out;
		
		RegisterfFileData <= reg_all; 
		
														   
	
	ID_EXreg : entity ID_EXreg 
	    port map(clk => clk, reset_bar => reset_bar, RF_rs1 => RF_rs1_out, RF_rs2 => RF_rs2_out, RF_rs3 => RF_rs3_out, 
		RF_opcode => RF_opcode_out, IDfwd_rs1 => IDEXreg_rs1_out , IDfwd_rs2 => IDEXreg_rs2_out , IDfwd_rs3 => IDEXreg_rs3_out , 
		IDfwd_opcode => IDEXreg_opcode_out, valid_out_flag => ID_EX_V, valid_in_flag => RF_ID_V );
		
		S3_IDEXregrs1_to_EX <= IDEXreg_rs1_out;
		
		S3_IDEXregrs2_to_EX <= IDEXreg_rs2_out;
		
		S3_IDEXregrs3_to_EX <= IDEXreg_rs3_out;
		
		S3_IDEXregopcode_to_EX <= IDEXreg_opcode_out;
		

	EXECUTE_ENGINE : entity EXECUTE_ENGINE 
		port map(clk => clk, reset_bar => reset_bar, EXin_rs1 => IDEXreg_rs1_out, EXin_rs2 => IDEXreg_rs2_out, EXin_rs3 => IDEXreg_rs3_out, 
		EXin_opcode => IDEXreg_opcode_out, rd_fwd => FWD_EX_RD_IN, opcode_fwd => FWD_EX_OP_IN, EXout_rs1 => ENGtoALUrs1, EXout_rs2 =>  ENGtoALUrs2 , 
		EXout_rs3 => ENGtoALUrs3, EXout_opcode => ENGtoALUopcode, valid_out_flag => EX_ALU_V, valid_in_flag => ID_EX_V , valid_in_flag_FWD => EXWB_EX_V  );
	   
		S3_rd_alu <= EX_rd_data;
		
		S3_op_alu <= EX_opcode_data;  

		
		
	multimedia_alu : entity multimedia_alu
		
		port map( rs1 => ENGtoALUrs1, rs2 => ENGtoALUrs2, rs3 => ENGtoALUrs3,  OpCode => ENGtoALUopcode , rd => EX_rd_data , opcode_out  => EX_opcode_data, valid_out_flag => ALU_EXWB_V, valid_in_flag => EX_ALU_V );
		
	
	EX_WBreg : entity EX_WBreg 
	    port map(clk => clk, reset_bar => reset_bar, alu_rddata_in => EX_rd_data, alu_opcodedata_in => EX_opcode_data, 
		alu_rddata_out => FWD_EX_RD_IN , alu_opcodedata_out => FWD_EX_OP_IN, write_enable =>reg_write_enable, valid_out_flag => EXWB_RF_V, valid_in_flag => ALU_EXWB_V, valid_out_flag_FWD =>  EXWB_EX_V );
	
		S4_EX_WBreg_rd <= FWD_EX_RD_IN;
		
		S4_EX_WBreg_op <= FWD_EX_OP_IN;	 
		
		S4_Write_Enable <= reg_write_enable; 
		
		S3_ForwardedData <= FWD_EX_RD_IN;
		
		S3_ForwardedOpCode <= FWD_EX_OP_IN;
		
end structural;
	