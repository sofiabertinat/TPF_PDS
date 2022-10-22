library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use std.textio.all;
use IEEE.std_logic_textio.all;

entity encoder_tb is
end encoder_tb;

architecture Behavioral of encoder_tb is
  --Archivos de entrada y salida
    --Para probar el del vivado podemos usar el siguiente
    constant in_file    : string  := "/Users/sofi_/Desktop/MSE/PDS/TPF/testEncoder/message_bits.txt"; 
    constant out_file   : string  := "/Users/sofi_/Desktop/MSE/PDS/TPF/testEncoder/data_out.txt"; 
    
    -- Testbench DUT generics
    constant DATA_IN_WIDTH : integer := 16; 
    constant DATA_OUT_WIDTH : integer := 32;
	
	--Declaramos las signal del tb
	signal D_itb: std_logic := '0';
	signal rst_tb: std_logic := '1';
	signal clk_tb: std_logic := '0';
	signal Qx_tb: std_logic := '0';
	signal Qy_tb: std_logic := '0';
	
	-- Punteros para los archivos
    file r_fptr,w_fptr : text;
begin
	clk_tb <= not clk_tb after 10 ns;
	rst_tb <= '0' after 380 ns;
	
	DUT: entity work.encoder      
    port map(
        D_i	    => D_itb,
        rst_i	=> rst_tb,
        clk_i	=> clk_tb,
        Qx_o 	=> Qx_tb,
        Qy_o 	=> Qy_tb
    );
         
	
	  -- Read file process
    p_read_write_file : process is
        variable fstatus_in     : file_open_status;
        variable file_line_in   : line;
        variable slv_v          : integer;
        variable fstatus_out    : file_open_status;
        variable file_line_out  : line;
        variable v_int          : integer;
    begin        
        --Abrimos los archivos
        file_open(fstatus_in, r_fptr, in_file, read_mode);         
        file_open(fstatus_out, w_fptr, out_file, write_mode); 
        --Recorremos el archivo
        if rst_tb = '1' then       
            loop_file : while not endfile(r_fptr) loop
                readline(r_fptr,file_line_in);
                read(file_line_in,slv_v);
                wait until (clk_tb'event and clk_tb = '1');
                if slv_v > 0 then       
                    D_itb <= '1';  
                else 
                    D_itb <= '0';
                end if; 
                write(file_line_out,Qx_tb);
                write(file_line_out,Qy_tb);
                writeline(w_fptr, file_line_out);         
            end loop ; -- loop_file
            report "Fin lectura del archivo";        
            file_close(r_fptr);
            write_file : for i in 0 to DATA_OUT_WIDTH loop
                wait until (rising_edge(clk_tb));
                write(file_line_out,Qx_tb);
                write(file_line_out,Qy_tb);
                writeline(w_fptr, file_line_out);
            end loop;
        end if;        
        report "Fin escritura del archivo";
        file_close(w_fptr);
        wait;
    end process; -- p_read_write_file	
            
end Behavioral;
