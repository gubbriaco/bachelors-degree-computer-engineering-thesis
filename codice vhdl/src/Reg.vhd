library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reg is
    generic(n : integer:=8);
    port(
        D : in std_logic_vector(n-1 downto 0);
        CLK : in std_logic;
        Q : out std_logic_vector(n-1 downto 0)
    );
end Reg;

architecture Behavioral of Reg is
    begin
        process(CLK)
            begin
                if rising_edge(CLK) then
                    Q <= D;
                end if;
        end process;
end Behavioral;
