library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FullAdder is
    port(
        A, B, Ci : in std_logic;
        S, Co : out std_logic
    );
end FullAdder;


architecture Behavioral of FullAdder is

    signal P, G : std_logic;
    
    begin
        P <= A xor B;
        S <= P xor Ci;
        Co <= Ci when P='1' else
              A when P='0' else
              'X';
end Behavioral;