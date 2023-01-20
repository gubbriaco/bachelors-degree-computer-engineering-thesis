library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity HalfAdder is
    port(
        A, B : in std_logic;
        S, Co : out std_logic
    );
end HalfAdder;

architecture Behavioral of HalfAdder is
    begin
        S <= A xor B;
        Co <= A and B;
end Behavioral;
