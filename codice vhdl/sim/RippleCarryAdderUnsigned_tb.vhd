library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;


entity RippleCarryAdderUnsigned_tb is
end RippleCarryAdderUnsigned_tb;


architecture Behavioral of RippleCarryAdderUnsigned_tb is

	component RippleCarryAdderUnsigned is
		generic(N:integer);
		port(
			A, B : in std_logic_vector(N-1 downto 0);
			Cin : in std_logic;
			S : out std_logic_vector(N-1 downto 0);
			Cout : out std_logic
		);
	end component;
	
	signal Ia, Ib : std_logic_vector(7 downto 0) := (others=>'0');
    signal Ici : std_logic := '0';
    signal Oresult : std_logic_vector(7 downto 0);
	signal Oco : std_logic;
	signal Osum : std_logic_vector(8 downto 0);
	
	
    signal Iclk : std_logic := '0';
	constant T_CLK : Time := 20 ns;
	

	begin
	
		UUT_RCAU : RippleCarryAdderUnsigned generic map(8) port map(Ia,Ib,Ici, Oresult,Oco);
		
		
		process
            begin
                wait for T_CLK/2;
                Iclk <= not Iclk;
        end process;
		
		
		process
            begin
				wait for 2*T_CLK + 100 ns;
                for va in 0 to 2**(8)-1 loop
                    Ia <= conv_std_logic_vector( va, 8 );
                    for vb in 0 to 2**(8)-1 loop      
                        Ib <= conv_std_logic_vector( vb, 8 );
                        Ici <= '0';
                        wait for 20 ns;
						Osum <= Oco & Oresult;
                        Ici <= '1';
                        wait for 20 ns;
						Osum <= Oco & Oresult;
                    end loop;
                end loop;
        end process;
		
		


end Behavioral;
