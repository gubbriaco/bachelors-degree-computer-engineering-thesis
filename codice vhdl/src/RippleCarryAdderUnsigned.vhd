library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity RippleCarryAdderUnsigned is
	generic(N : integer);
	port(
		A, B : in std_logic_vector(N-1 downto 0);
		Cin : in std_logic;
		S : out std_logic_vector(N-1 downto 0);
		Cout : out std_logic
	);
end RippleCarryAdderUnsigned;


architecture Behavioral of RippleCarryAdderUnsigned is

	component FullAdder is
		port(
			A, B, Ci : in std_logic;
			S, Co : out std_logic
		);
	end component;

	signal C : std_logic_vector(N downto 0);


	begin
	
		C(0)<=Cin;
		for_gen : for i in 0 to N-1 generate
			FA : FullAdder port map(A(i),B(i),C(i),S(i),C(i+1));
		end generate for_gen;

		Cout <= C(N);

end Behavioral;
