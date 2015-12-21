
/* 
 * Designer:   name, student id, email address 
*/

#include "spimcore.h"

/* ALU */
void ALU(unsigned A,unsigned B,char ALUControl,unsigned *ALUresult,char *Zero)
{
  switch(ALUControl)
    {
    case 0x0: *ALUresult = A + B; break;// add
    case 0x1: *ALUresult = A + (~B) + 1; break;// subtract
    case 0x2: *ALUresult = (A + (~B) + 1) >> 31; break; // 010: set less than: A - B < 0
    case 0x3: *ALUresult = A < B ? 1 : 0; break; // 011: set less than unsigned
    case 0x4: *ALUresult = A & B; break; // 100: bitwise AND
    case 0x5: *ALUresult = A | B; break; // 101: bitwise OR
    case 0x6: *ALUresult = B << 16; break; // 110: shift B left by 16 bits
    case 0x7: *ALUresult = ~A; break; // 111: bitwise not A
    }
  // assign zero flag
  *Zero = *ALUresult == 0 ? 1 : 0;
  return;
}

/* instruction fetch */
int instruction_fetch(unsigned PC,unsigned *Mem,unsigned *instruction)
{
  // check if PC is word aligned and the address is not beyond the memory
  if (((PC & 0x3) != 0) || PC < 0x4000 || (PC >> 2) >= (65536 >> 2) ) 
    return 1;
  *instruction=Mem[PC>>2];

  if (*instruction == 0x0)
    // invalid instruction
    return 1;
  return 0;
}


/* instruction partition */
void instruction_partition(unsigned instruction, unsigned *op, unsigned *r1,unsigned *r2, unsigned *r3, unsigned *funct, unsigned *offset, unsigned *jsec)
{
  *op = instruction >> 26; //[31-26] 
  *r1 = (0x03FFFFFF & instruction) >> 21; //[25-21]
  *r2 = (0x001FFFFF & instruction) >> 16; //[20-16]
  *r3 = (0x0000FFFF & instruction) >> 11; //[15-11]
  *funct = 0x3F & instruction;  // [5-0]
  *offset = 0xFFFF & instruction; // [15-0]
  *jsec = 0x03FFFFFF & instruction; // [25-0]
}


/* instruction decode */
int instruction_decode(unsigned op,struct_controls *controls)
{
  if(op==0x0){//R-format
    controls->RegDst = 1;
    controls->Jump = 0;
    controls->Branch = 0;
    controls->MemRead = 2;
    controls->MemtoReg = 2;
    controls->ALUOp = 7;
    controls->MemWrite = 2;
    controls->ALUSrc = 0;
    controls->RegWrite = 1;
  }
  else if (op == 010) { // addi
    controls->RegDst = 0;
    controls->Jump = 0;  
    controls->Branch = 0; 
    controls->MemRead = 2; 
    controls->MemtoReg = 2;
    controls->ALUOp = 0;
    controls->MemWrite = 2;
    controls->ALUSrc = 1;
    controls->RegWrite = 1;
  }
  else if (op == 012) { // set less than imm
    controls->RegDst = 0;
    controls->Jump = 0;  
    controls->Branch = 0; 
    controls->MemRead = 2; 
    controls->MemtoReg = 2;
    controls->ALUOp = 2;
    controls->MemWrite = 2;
    controls->ALUSrc = 1;
    controls->RegWrite = 1;
  }
  else if (op == 013) { // set less than imm unsigned
    controls->RegDst = 0;
    controls->Jump = 0;  
    controls->Branch = 0; 
    controls->MemRead = 2; 
    controls->MemtoReg = 2;
    controls->ALUOp = 3;
    controls->MemWrite = 2;
    controls->ALUSrc = 1;
    controls->RegWrite = 1;
  }
  else if (op == 043) { // load word    
    controls->RegDst = 0;
    controls->Jump = 0;  
    controls->Branch = 0; 
    controls->MemRead = 1;
    controls->MemtoReg = 1;
    controls->ALUOp = 0;
    controls->ALUSrc = 1;
    controls->MemWrite = 0;
    controls->RegWrite = 1;
  }
  else if (op == 053) { // store word
    controls->RegDst = 2;
    controls->Jump = 0;  
    controls->Branch = 0; 
    controls->MemRead = 0;
    controls->MemtoReg = 0;
    controls->ALUOp = 0;
    controls->ALUSrc = 1;
    controls->MemWrite = 1;
    controls->RegWrite = 0;
  }
  else if (op == 017) { // load upper immediate
    controls->RegDst = 0;
    controls->Jump = 0;
    controls->Branch = 0; 
    controls->MemRead = 0;
    controls->MemtoReg = 0;
    controls->ALUOp = 6;
    controls->ALUSrc = 1;
    controls->MemWrite = 0;
    controls->RegWrite = 1;
  }
  else if (op == 004) { // beq
    controls->RegDst = 2;
    controls->Jump = 0;
    controls->Branch = 1;
    controls->MemRead = 0;
    controls->MemtoReg = 0;
    controls->ALUOp = 1;
    controls->ALUSrc = 0;
    controls->MemWrite = 0;
    controls->RegWrite = 0;
  }
  else if (op == 002) { // jump
    controls->RegDst = 2;
    controls->Jump = 1;
    controls->Branch = 0;
    controls->MemRead = 0;
    controls->MemtoReg = 0;
    controls->ALUSrc = 2;
    controls->ALUOp = 0;
    controls->MemWrite = 0;
    controls->RegWrite = 0;
  }
  else return 1;	//invalid instruction
  return 0;
}

/* Read Register */
void read_register(unsigned r1,unsigned r2,unsigned *Reg,unsigned *data1,unsigned *data2)
{
  *data1 = Reg[r1];
  *data2 = Reg[r2];
}


/* Sign Extend */
void sign_extend(unsigned offset,unsigned *extended_value)
{
  *extended_value = (offset >> 15) == 1 ? (0xFFFF0000 & offset) : offset;
}

/* ALU operations */
int ALU_operations(unsigned data1,unsigned data2,unsigned extended_value,unsigned funct,char ALUOp,char ALUSrc,unsigned *ALUresult,char *Zero)
{
  if (ALUSrc == 0) {
    switch(ALUOp){
      // R-type
    case 7:
      // funct = 0x20 = 32
      if(funct==0x20)ALU(data1,data2,0x0,ALUresult,Zero);	//add
      else if (funct==042)ALU(data1,data2,0x1,ALUresult, Zero); // subtract
      else if (funct==052)ALU(data1,data2,0x2,ALUresult, Zero); // set less than
      else if (funct==053)ALU(data1,data2,0x3,ALUresult, Zero); // set less than unsigned
      else if (funct==044)ALU(data1,data2,0x4,ALUresult, Zero); // and
      else if (funct==045)ALU(data1,data2,0x5,ALUresult, Zero); // or
      else if (funct==000)ALU(data1,data2,0x6,ALUresult, Zero); // shift left logical
      else if (funct==047)ALU(data1,data2,0x7,ALUresult, Zero); // not data1
      else return 1;	//invalid funct
      break;
      // other types
    case 1:
      ALU(data1, data2, 0x1, ALUresult, Zero);
      break;
    default:
      return 1;		//invalid ALUop
    }
  }
  else if (ALUSrc == 1) {
    switch(ALUOp){
    case 0:
      ALU(data1, extended_value, 0x0, ALUresult, Zero);
      break;
    case 2:
      ALU(data1, extended_value, 0x2, ALUresult, Zero);
      break;
    case 3:
      ALU(data1, extended_value, 0x3, ALUresult, Zero);
      break;
    case 6:
      ALU(data1, extended_value, 0x6, ALUresult, Zero);
      break;
    default:
      return 1;
    }
  }
  return 0;
}

/* Read / Write Memory */
int rw_memory(unsigned ALUresult,unsigned data2,char MemWrite,char MemRead,unsigned *memdata,unsigned *Mem)
{
  if(MemRead==1){
    // if the address is not word-aligned or exceeds boundary, halt
    if ( (ALUresult & 0x3) != 0 || ((ALUresult >> 2) >= (65536 >> 2) )) 
      return 1;
    *memdata = Mem[ALUresult>>2];
  }
  if(MemWrite==1){
    // if the address is not word-aligned, or exceeds boundary, halt
    if ( (ALUresult & 0x3) != 0 || ((ALUresult >> 2) >= (65536 >> 2) )) 
      return 1;
    Mem[ALUresult>>2] = data2;
  }
  return 0;
}

 
/* Write Register */
void write_register(unsigned r2,unsigned r3,unsigned memdata,unsigned ALUresult,char RegWrite,char RegDst,char MemtoReg,unsigned *Reg)
{
  if (RegWrite == 1) {
    if (MemtoReg == 1) {
      if (RegDst == 0) 
	Reg[r2] = memdata;
      else
	Reg[r3] = memdata;
    }
    else {
      if (RegDst == 0)
	Reg[r2] = ALUresult;
      else
	Reg[r3] = ALUresult;
    }
  }
}

/* PC update */
void PC_update(unsigned jsec,unsigned extended_value,char Branch,char Jump,char Zero,unsigned *PC)
{
  if (Jump == 1)
    *PC = jsec << 2;
  else if (Branch == 1 && Zero == 1)
    *PC = *PC + (extended_value << 2) + 4;
  else
    *PC+=4;
}
