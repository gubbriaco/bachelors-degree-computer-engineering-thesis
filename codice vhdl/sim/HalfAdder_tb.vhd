library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity HalfAdder_tb is
end HalfAdder_tb;


architecture Behavioral of HalfAdder_tb is

    component HalfAdder is
        port(
            A, B : in std_logic;
            S, Co : out std_logic
        );
    end component;

    signal Ia, Ib : std_logic;
    signal Ir, Ico : std_logic;

    begin
    
        HA : HalfAdder port map(Ia, Ib, Ir, Ico);
        
        process 
            begin
                Ia <= '0';
                Ib <= '0'; -- 00
                wait for 10 ns;
                Ia <= '0';
                Ib <= '1'; -- 01
                wait for 10 ns;
                Ia <= '1';
                Ib <= '0'; -- 10
                wait for 10 ns;
                Ia <= '1';
                Ib <= '1'; -- 11
                wait for 10 ns;
        end process;


end Behavioral;
