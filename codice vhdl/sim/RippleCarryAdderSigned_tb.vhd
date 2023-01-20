library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;

entity RippleCarryAdderSigned_tb is
end RippleCarryAdderSigned_tb;


architecture Behavioral of RippleCarryAdderSigned_tb is

	component RippleCarryAdderSigned is
		generic(N:integer);
		port(
			A, B : in std_logic_vector(N-1 downto 0);
			Cin : in std_logic;
			S : out std_logic_vector(N downto 0)
		);
	end component;
	
	signal Ia, Ib : std_logic_vector(7 downto 0) := (others=>'0');
    signal Ici : std_logic := '0';
    signal Oresult : std_logic_vector(8 downto 0);
	
	
    signal Iclk : std_logic := '0';
	constant T_CLK : Time := 20 ns;
	

	begin
	
		UUT_RCAU : RippleCarryAdderSigned generic map(8) port map(Ia,Ib,Ici, Oresult);
		
		
		process
            begin
                wait for T_CLK/2;
                Iclk <= not Iclk;
        end process;
		
		
		process
            begin
				wait for 2*T_CLK + 100 ns;
                for va in -(2**(8-1)) to (2**(8-1)-1) loop
                    Ia <= conv_std_logic_vector( va, 8 );
                    for vb in -(2**(8-1)) to (2**(8-1)-1) loop   
                        Ib <= conv_std_logic_vector( vb, 8 );
                        Ici <= '0';
                        wait for 20 ns;
                        Ici <= '1';
                        wait for 20 ns;
                    end loop;
                end loop;
        end process;
		
		



end Behavioral;