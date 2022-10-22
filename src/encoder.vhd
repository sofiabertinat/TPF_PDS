library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity encoder is
    port(		
		D_i: in std_logic;
		rst_i: in std_logic;
		clk_i: in std_logic;
		Qx_o: out std_logic;
		Qy_o: out std_logic
	);
end encoder;

architecture encoder_arq of encoder is
    constant C_PGENX    : std_logic_vector(6 downto 0) := ("1111001");  
    constant C_PGENY    : std_logic_vector(6 downto 0) := ("1011011");
    signal aux_r: std_logic_vector(6 downto 0) := (others => '0');
    signal aux_rX: std_logic_vector(6 downto 0) := (others => '0');
    signal aux_rY: std_logic_vector(6 downto 0) := (others => '0');
    signal aux_x: std_logic := '0';
    signal aux_y: std_logic := '0';
begin
  
    aux_rX <= aux_r and C_PGENX;
	aux_rY <= aux_r and C_PGENY;
	
    process(clk_i,rst_i)
	begin		   
       if rst_i = '0' then
           aux_r <= (others => '0');
           aux_x <= '0';
           aux_y <= '0';	  
	   elsif rising_edge(clk_i) then	   	    
			aux_r(5 downto 0) <= aux_r(6 downto 1);
			aux_r(6) <= D_i;	
			aux_x <= aux_rX(6) xor aux_rX(5) xor aux_rX(4) xor aux_rX(3) xor aux_rX(2) xor aux_rX(1) xor aux_rX(0);
            aux_y <= aux_rY(6) xor aux_rY(5) xor aux_rY(4) xor aux_rY(3) xor aux_rY(2) xor aux_rY(1) xor aux_rY(0);        
		end if;	
	end process;
	
	Qx_o <= aux_x;
	Qy_o <= aux_y;
	
end encoder_arq;
