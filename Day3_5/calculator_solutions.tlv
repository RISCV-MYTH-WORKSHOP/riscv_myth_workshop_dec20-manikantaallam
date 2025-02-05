\m4_TLV_version 1d: tl-x.org
\SV
   // This code can be found in: https://github.com/stevehoover/RISC-V_MYTH_Workshop
   
   m4_include_lib(['https://raw.githubusercontent.com/stevehoover/RISC-V_MYTH_Workshop/bd1f186fde018ff9e3fd80597b7397a1c862cf15/tlv_lib/calculator_shell_lib.tlv'])

\SV
   m4_makerchip_module   // (Expanded in Nav-TLV pane.)

\TLV
   |calc
      @0      
         $reset = *reset;
      //?$valid
      @1   
            //$val1[31:0] = $rand1[3:0];
         $val2[31:0] = $rand2[3:0];   
         $val1[31:0] = >>2$out;
         $valid = $reset ? 0 : >>1$valid + 1'b1;
         $reset_or_valid = $valid || $reset;
         ?$reset_or_valid 
            $sum[31:0]  = $val1[31:0] + $val2[31:0];
            $diff[31:0] = $val1[31:0] - $val2[31:0];  
            $prod[31:0] = $val1[31:0] * $val2[31:0];
            $quot[31:0] = $val1[31:0] / $val2[31:0];
            
            //$cnt = $reset ? 0 : >>1$cnt + 1'b1;
            //$ro_valid = $cnt || $reset;
      @2 
         ?$reset_or_valid
            $out[31:0] = $reset ? 32'b0 : 
                ($op == 3'b000) ? $sum[31:0]: 
                ($op == 3'b001) ? $diff[31:0]: 
                ($op == 3'b010) ? $prod[31:0]:
                ($op == 3'b011) ? $quot[31:0]:
                ($op == 3'b100) ? >>2$mem :>>2$out;
         
            $mem[31:0] = $reset ? 32'b0:
                    ($op==3'b101)? $val1 : >>2$mem;
       
          
         
         

      // Macro instantiations for calculator visualization(disabled by default).
      // Uncomment to enable visualisation, and also,
      // NOTE: If visualization is enabled, $op must be defined to the proper width using the expression below.
      //       (Any signals other than $rand1, $rand2 that are not explicitly assigned will result in strange errors.)
      //       You can, however, safely use these specific random signals as described in the videos:
      //o $val1[31:0]
      //o $val1[31:0]
      //o $op[1:0]
      
   m4+cal_viz(@3) // Arg: Pipeline stage represented by viz, should be atleast equal to last stage of CALCULATOR logic.

   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
   

\SV
   endmodule
