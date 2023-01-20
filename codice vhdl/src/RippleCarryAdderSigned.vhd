library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity RippleCarryAdderSigned is
    generic(N : integer);
    port(
        A, B : in std_logic_vector(N-1 downto 0);
        Cin : in std_logic;
        S : out std_logic_vector(N downto 0)
    );
end RippleCarryAdderSigned;

architecture Behavioral of RippleCarryAdderSigned is

    component FullAdder is
        port(
            A, B, Ci : in std_logic;
            S, Co : out std_logic
        );
    end component;
    
    signal C : std_logic_vector(N downto 0);
       
        
    begin
        
        C(0)<=Cin;
        for_gen: for i in 0 to N generate
            if_gen: if (i<N) generate
                FA: FullAdder port map(A(i),B(i),C(i),S(i),C(i+1));
            end generate if_gen;
            if_gen_MSB: if (i=N) generate
                FA: FullAdder port map(A(i-1),B(i-1),C(i),S(i),open);
            end generate if_gen_MSB;
        end generate for_gen;
        
    
end Behavioral;
