library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;

entity WallaceMultiplier8bit_tb is
end WallaceMultiplier8bit_tb;


architecture Behavioral of WallaceMultiplier8bit_tb is

	component WallaceMultiplier8bit is
		port(
			A, B : in std_logic_vector(7 downto 0);
			CLK : in std_logic;
			Result : out std_logic_vector(15 downto 0)
		);
	end component;

	signal IA, IB : std_logic_vector(7 downto 0);
    signal Iclk : std_logic := '0';
    signal OResult : std_logic_vector(15 downto 0);
    
    constant T_CLK : Time := 20 ns;
	
	signal TrueResult, Error : integer;
	

	begin

		UUT : WallaceMultiplier8bit port map(IA, IB, Iclk, OResult);

		process
            begin
                wait for T_CLK/2;
                Iclk <= not Iclk;
        end process;
        
        process 
            begin
                wait for 2*T_CLK + 100 ns;
                for va in 0 to 2**(8)-1 loop
                    IA <= conv_std_logic_vector(va,8);
                    for vb in -(2**(8-1)) to (2**(8-1)-1) loop
                        IB <= conv_std_logic_vector(vb,8);
                        wait for T_CLK;
						TrueResult <= va*vb;
						Error <= TrueResult - conv_integer(signed(OResult));
                    end loop;
                    wait for T_CLK;
                end loop;
        end process;

end Behavioral;