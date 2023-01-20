library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;

entity PenAndPaperMultiplier is
	port(
		A, B : in std_logic_vector(7 downto 0);
        CLK : in std_logic;
        Result : out std_logic_vector(15 downto 0)
	);
end PenAndPaperMultiplier;



architecture Behavioral of PenAndPaperMultiplier is

	component Reg is
		generic(n : integer);
		port(
			D : in std_logic_vector(n-1 downto 0);
			CLK : in std_logic;
			Q : out std_logic_vector(n-1 downto 0)
		);
	end component;

	component RippleCarryAdderUnsigned is
		generic(N : integer:=8);
		port(
			A, B : in std_logic_vector(N-1 downto 0);
			Cin : in std_logic;
			S : out std_logic_vector(N-1 downto 0);
			Cout : out std_logic
		);
	end component;
	
	component RippleCarryAdderSigned is
		generic(N : integer := 8);
		port(
			A, B : in std_logic_vector(N-1 downto 0);
			Cin : in std_logic;
			S : out std_logic_vector(N downto 0)
		);
	end component;



	signal sA, sB : std_logic_vector(7 downto 0);
	
	
	-- SIGNAL DEFINITIONS
	signal Res,sResult : std_logic_vector(15 downto 0);
	
	 -- output moltiplicazione a 16 bit
    signal b0a0,b0a1,b0a2,b0a3,b0a4,b0a5,b0a6,b0a7 : std_logic;
    signal b1a0,b1a1,b1a2,b1a3,b1a4,b1a5,b1a6,b1a7 : std_logic;
    signal b2a0,b2a1,b2a2,b2a3,b2a4,b2a5,b2a6,b2a7 : std_logic;
    signal b3a0,b3a1,b3a2,b3a3,b3a4,b3a5,b3a6,b3a7 : std_logic;
    signal b4a0,b4a1,b4a2,b4a3,b4a4,b4a5,b4a6,b4a7 : std_logic;
    signal b5a0,b5a1,b5a2,b5a3,b5a4,b5a5,b5a6,b5a7 : std_logic;
    signal b6a0,b6a1,b6a2,b6a3,b6a4,b6a5,b6a6,b6a7 : std_logic;
    
	signal n0, n1, n2, n3, n4, n5, n6, n7, en7 : std_logic;
    signal notA : std_logic_vector(7 downto 0);
    signal c2A : std_logic_vector(7 downto 0);
	
	
	-- signals in input ai sommatori in cascata
	-- es. in1_4, in2_4 corrispondono al primo e al secondo input del sommatore 4
	signal inp1sommatore1, inp2sommatore1 : std_logic_vector(7 downto 0);
	signal inp1sommatore2, inp2sommatore2 : std_logic_vector(7 downto 0);
	signal inp1sommatore3, inp2sommatore3 : std_logic_vector(7 downto 0);
	signal inp1sommatore4, inp2sommatore4 : std_logic_vector(7 downto 0);
	signal inp1sommatore5, inp2sommatore5 : std_logic_vector(7 downto 0);
	signal inp1sommatore6, inp2sommatore6 : std_logic_vector(7 downto 0);
	signal inp1sommatore7, inp2sommatore7 : std_logic_vector(7 downto 0);
	
	-- signal in output dai sommatori in cascata
	signal s1, s2, s3, s4, s5, s6 : std_logic_vector(7 downto 0);
	signal c1, c2, c3, c4, c5, c6 : std_logic;
	signal s7 : std_logic_vector(8 downto 0);
	

	begin
		
		RegA : Reg generic map(8) port map(A,CLK,sA);
		RegB : Reg generic map(8) port map(B,CLK,sB);
		
		
		-- b0
        b0a0<=sB(0) and sA(0); b0a1<=sB(0) and sA(1); b0a2<=sB(0) and sA(2); b0a3<=sB(0) and sA(3); 
		b0a4<=sB(0) and sA(4); b0a5<=sB(0) and sA(5); b0a6<=sB(0) and sA(6); b0a7<=sB(0) and sA(7);
        
        -- b1
        b1a0<=sB(1) and sA(0); b1a1<=sB(1) and sA(1); b1a2<=sB(1) and sA(2); b1a3<=sB(1) and sA(3); 
		b1a4<=sB(1) and sA(4); b1a5<=sB(1) and sA(5); b1a6<=sB(1) and sA(6); b1a7<=sB(1) and sA(7);
        
        -- b2
        b2a0<=sB(2) and sA(0); b2a1<=sB(2) and sA(1); b2a2<=sB(2) and sA(2); b2a3<=sB(2) and sA(3); 
		b2a4<=sB(2) and sA(4); b2a5<=sB(2) and sA(5); b2a6<=sB(2) and sA(6); b2a7<=sB(2) and sA(7);
        
        -- b3
        b3a0<=sB(3) and sA(0); b3a1<=sB(3) and sA(1); b3a2<=sB(3) and sA(2); b3a3<=sB(3) and sA(3); 
		b3a4<=sB(3) and sA(4); b3a5<=sB(3) and sA(5); b3a6<=sB(3) and sA(6); b3a7<=sB(3) and sA(7);
        
        -- b4
        b4a0<=sB(4) and sA(0); b4a1<=sB(4) and sA(1); b4a2<=sB(4) and sA(2); b4a3<=sB(4) and sA(3); 
		b4a4<=sB(4) and sA(4); b4a5<=sB(4) and sA(5); b4a6<=sB(4) and sA(6); b4a7<=sB(4) and sA(7);
        
        -- b5
        b5a0<=sB(5) and sA(0); b5a1<=sB(5) and sA(1); b5a2<=sB(5) and sA(2); b5a3<=sB(5) and sA(3); 
		b5a4<=sB(5) and sA(4); b5a5<=sB(5) and sA(5); b5a6<=sB(5) and sA(6); b5a7<=sB(5) and sA(7);
        
        -- b6
        b6a0<=sB(6) and sA(0); b6a1<=sB(6) and sA(1); b6a2<=sB(6) and sA(2); b6a3<=sB(6) and sA(3); 
		b6a4<=sB(6) and sA(4); b6a5<=sB(6) and sA(5); b6a6<=sB(6) and sA(6); b6a7<=sB(6) and sA(7);
		
		
		-- gestione del complemento a due e del segno
        -- se B e' positivo allora la riga in piu' presentera' tutti zeri e con segno '0'
        -- se B e' negativo allora verra' calcolato il complemento a due di A e il segno sara' la copia dell'ultimo bit calcolato
        
        for_assegnazione_notA : for i in 0 to 7 generate
            notA(i)<=not sA(i);
        end generate for_assegnazione_notA;
        complemento_a_2_A : RippleCarryAdderUnsigned generic map(8) port map(notA, conv_std_logic_vector(1,8), '0', c2A, open);
        
                
        n0<= '0' when sB(7)='0' else c2A(0) when sB(7)='1' else 'X';
        n1<= '0' when sB(7)='0' else c2A(1) when sB(7)='1' else 'X';
        n2<= '0' when sB(7)='0' else c2A(2) when sB(7)='1' else 'X';
        n3<= '0' when sB(7)='0' else c2A(3) when sB(7)='1' else 'X';
        n4<= '0' when sB(7)='0' else c2A(4) when sB(7)='1' else 'X';
        n5<= '0' when sB(7)='0' else c2A(5) when sB(7)='1' else 'X';
        n6<= '0' when sB(7)='0' else c2A(6) when sB(7)='1' else 'X';
        n7<= '0' when sB(7)='0' else c2A(7) when sB(7)='1' else 'X';

        en7 <= n7;
		
		-- sommatore 1
		inp1sommatore1(0)<=b0a1; inp2sommatore1(0)<=b1a0;
		inp1sommatore1(1)<=b0a2; inp2sommatore1(1)<=b1a1;
		inp1sommatore1(2)<=b0a3; inp2sommatore1(2)<=b1a2;
		inp1sommatore1(3)<=b0a4; inp2sommatore1(3)<=b1a3;
		inp1sommatore1(4)<=b0a5; inp2sommatore1(4)<=b1a4;
		inp1sommatore1(5)<=b0a6; inp2sommatore1(5)<=b1a5;
		inp1sommatore1(6)<=b0a7; inp2sommatore1(6)<=b1a6;
		inp1sommatore1(7)<='0';  inp2sommatore1(7)<=b1a7;
		sommatore_1 : RippleCarryAdderUnsigned generic map(8) port map(inp1sommatore1, inp2sommatore1, '0', s1, c1);
		
		-- sommatore 2
		inp1sommatore2(6 downto 0) <= s1(7 downto 1);
		inp1sommatore2(7)<=c1;
		inp2sommatore2(0)<=b2a0;
		inp2sommatore2(1)<=b2a1;
		inp2sommatore2(2)<=b2a2;
		inp2sommatore2(3)<=b2a3;
		inp2sommatore2(4)<=b2a4;
		inp2sommatore2(5)<=b2a5;
		inp2sommatore2(6)<=b2a6;
		inp2sommatore2(7)<=b2a7;
		sommatore_2 : RippleCarryAdderUnsigned generic map(8) port map(inp1sommatore2, inp2sommatore2, '0', s2, c2);
		
		-- sommatore 3
		inp1sommatore3(6 downto 0) <= s2(7 downto 1);
		inp1sommatore3(7)<=c2;
		inp2sommatore3(0)<=b3a0;
		inp2sommatore3(1)<=b3a1;
		inp2sommatore3(2)<=b3a2;
		inp2sommatore3(3)<=b3a3;
		inp2sommatore3(4)<=b3a4;
		inp2sommatore3(5)<=b3a5;
		inp2sommatore3(6)<=b3a6;
		inp2sommatore3(7)<=b3a7;
		sommatore_3 : RippleCarryAdderUnsigned generic map(8) port map(inp1sommatore3, inp2sommatore3, '0', s3, c3);
		
		-- sommatore 4
		inp1sommatore4(6 downto 0) <= s3(7 downto 1);
		inp1sommatore4(7)<=c3;
		inp2sommatore4(0)<=b4a0;
		inp2sommatore4(1)<=b4a1;
		inp2sommatore4(2)<=b4a2;
		inp2sommatore4(3)<=b4a3;
		inp2sommatore4(4)<=b4a4;
		inp2sommatore4(5)<=b4a5;
		inp2sommatore4(6)<=b4a6;
		inp2sommatore4(7)<=b4a7;
		sommatore_4 : RippleCarryAdderUnsigned generic map(8) port map(inp1sommatore4, inp2sommatore4, '0', s4, c4);
		
		-- sommatore 5
		inp1sommatore5(6 downto 0) <= s4(7 downto 1);
		inp1sommatore5(7)<=c4;
		inp2sommatore5(0)<=b5a0;
		inp2sommatore5(1)<=b5a1;
		inp2sommatore5(2)<=b5a2;
		inp2sommatore5(3)<=b5a3;
		inp2sommatore5(4)<=b5a4;
		inp2sommatore5(5)<=b5a5;
		inp2sommatore5(6)<=b5a6;
		inp2sommatore5(7)<=b5a7;
		sommatore_5 : RippleCarryAdderUnsigned generic map(8) port map(inp1sommatore5, inp2sommatore5, '0', s5, c5);
		
		-- sommatore 6
		inp1sommatore6(6 downto 0) <= s5(7 downto 1);
		inp1sommatore6(7)<=c5;
		inp2sommatore6(0)<=b6a0;
		inp2sommatore6(1)<=b6a1;
		inp2sommatore6(2)<=b6a2;
		inp2sommatore6(3)<=b6a3;
		inp2sommatore6(4)<=b6a4;
		inp2sommatore6(5)<=b6a5;
		inp2sommatore6(6)<=b6a6;
		inp2sommatore6(7)<=b6a7;
		sommatore_6 : RippleCarryAdderUnsigned generic map(8) port map(inp1sommatore6, inp2sommatore6, '0', s6, c6);
		
		-- sommatore 7
		inp1sommatore7(6 downto 0) <= s6(7 downto 1);
		inp1sommatore7(7)<=c6;
		inp2sommatore7(0)<=n0;
		inp2sommatore7(1)<=n1;
		inp2sommatore7(2)<=n2;
		inp2sommatore7(3)<=n3;
		inp2sommatore7(4)<=n4;
		inp2sommatore7(5)<=n5;
		inp2sommatore7(6)<=n6;
		inp2sommatore7(7)<=n7;
		sommatore_7 : RippleCarryAdderSigned generic map(8) port map(inp1sommatore7, inp2sommatore7, '0', s7);
		
		
		-- Risultato
		Res(0)<=b0a0;
		Res(1)<=s1(0);
		Res(2)<=s2(0);
		Res(3)<=s3(0);
		Res(4)<=s4(0);
		Res(5)<=s5(0);
		Res(6)<=s6(0);
		Res(14 downto 7)<=s7(7 downto 0);
		Res(15)<= '1' when sB(7)='1' and sA(7)='1' else en7;
		RegResult : Reg generic map(16) port map(Res,CLK,sResult);
		Result<=sResult;
		

end Behavioral;