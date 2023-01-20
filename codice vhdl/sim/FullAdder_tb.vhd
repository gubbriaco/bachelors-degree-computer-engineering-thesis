library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;


entity FullAdder_tb is
end FullAdder_tb;


architecture Behavioral of FullAdder_tb is

    component FullAdder is 
        port(
            A, B, Ci : in std_logic;
            S, Co : out std_logic
        );
    end component;
    
    signal Ia, Ib, Ici : std_logic;
    signal Ir, Ico : std_logic;

    begin
        
        FA : FullAdder port map(Ia, Ib, Ici, Ir, Ico);
        
        process 
            begin
            Ia <= '0';
            Ib <= '0';
            Ici <= '0'; -- 000
            wait for 10 ns; 
            Ia <= '0';
            Ib <= '0';
            Ici <= '1'; -- 001
            wait for 10 ns; 
            Ia <= '0';
            Ib <= '1';
            Ici <= '0'; -- 010
            wait for 10 ns; 
            Ia <= '0';
            Ib <= '1';
            Ici <= '1'; -- 011
            wait for 10 ns; 
            Ia <= '1';
            Ib <= '0';
            Ici <= '0'; -- 100
            wait for 10 ns; 
            Ia <= '1';
            Ib <= '0';
            Ici <= '1'; -- 101
            wait for 10 ns; 
            Ia <= '1';
            Ib <= '1';
            Ici <= '0'; -- 110
            wait for 10 ns; 
            Ia <= '1';
            Ib <= '1';
            Ici <= '1'; -- 111
            wait for 10 ns;
        end process;
        


end Behavioral;