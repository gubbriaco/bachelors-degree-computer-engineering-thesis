library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;

entity WallaceMultiplier8bit is
	port(
		A, B : in std_logic_vector(7 downto 0);
        CLK : in std_logic;
        Result : out std_logic_vector(15 downto 0)
	);
end WallaceMultiplier8bit;



architecture Behavioral of WallaceMultiplier8bit is

	-- **********************************************
    -- COMPONENTS DEFINITIONS
	
	component Reg is
        generic(n : integer);
        port(
            D : in std_logic_vector(n-1 downto 0);
            CLK : in std_logic;
            Q : out std_logic_vector(n-1 downto 0)
        );
    end component;
    
    component HalfAdder is
        port(
            A, B : in std_logic;
            S, Co : out std_logic
        );
    end component;
    
    component FullAdder is
        port(
            A, B, Ci : in std_logic;
            S, Co : out std_logic
        );
    end component;
    
    component RippleCarryAdderSigned is
		generic(N : integer);
		port(
			A, B : in std_logic_vector(N-1 downto 0);
			Cin : in std_logic;
			S : out std_logic_vector(N downto 0)
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
    
    
    
    -- **********************************************
    -- SIGNAL DEFINITIONS
	
	-- output registri
    signal sA, sB : std_logic_vector(7 downto 0);
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
	
	
	-- signal di supporto
    -- signal per half-adder
    signal ha1S, ha2S, ha3S, ha4S, ha5S, ha6S, ha7S, ha8S, ha9S, ha10S, ha11S, ha12S, ha13S, ha14S : std_logic;
    signal ha15S, ha16S, ha17S, ha18S, ha19S, ha20S, ha21S, ha22S, ha23S, ha24S : std_logic;
    signal ha1R, ha2R, ha3R, ha4R, ha5R, ha6R, ha7R, ha8R, ha9R, ha10R, ha11R, ha12R, ha13R, ha14R : std_logic;
    signal ha15R, ha16R, ha17R, ha18R, ha19R, ha20R, ha21R, ha22R, ha23R, ha24R : std_logic;
    -- signal per full-adder
    signal fa1S, fa2S, fa3S, fa4S, fa5S, fa6S, fa7S, fa8S, fa9S, fa10S, fa11S, fa12S, fa13S, fa14S : std_logic;
    signal fa15S, fa16S, fa17S, fa18S, fa19S, fa20S, fa21S, fa22S, fa23S, fa24S, fa25S, fa26S, fa27S : std_logic;
    signal fa28S, fa29S, fa30S, fa31S, fa32S, fa33S, fa34S, fa35S, fa36S : std_logic;
	signal fa1R, fa2R, fa3R, fa4R, fa5R, fa6R, fa7R, fa8R, fa9R, fa10R, fa11R, fa12R, fa13R, fa14R : std_logic;
    signal fa15R, fa16R, fa17R, fa18R, fa19R, fa20R, fa21R, fa22R, fa23R, fa24R, fa25R, fa26R, fa27R : std_logic;
    signal fa28R, fa29R, fa30R, fa31R, fa32R, fa33R, fa34R, fa35R, fa36R : std_logic;
	
	
	-- VMA signals  
	signal vmaIn1, vmaIn2 : std_logic_vector(9 downto 0);
    signal vmaO : std_logic_vector(10 downto 0);
	
	
	begin
        
		-- si inizializzano i due registri relativi agli ingressi
        RegA: Reg generic map(8) port map(A, CLK, sA);
        RegB: Reg generic map(8) port map(B, CLK, sB);
		
		
		-- iterazione 0 
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
		
		
		
		-- iterazione 1
		-- colonna 1
		ha1 : HalfAdder port map(b0a1,b1a0,ha1S,ha1R);
		-- colonna 2
		fa1 : FullAdder port map(b0a2,b1a1,b2a0,fa1S,fa1R);
		-- colonna 3
		fa2 : FullAdder port map(b0a3,b1a2,b2a1,fa2S,fa2R);
		-- colonna 4
		fa3 : FullAdder port map(b0a4,b1a3,b2a2,fa3S,fa3R);
		ha2 : HalfAdder port map(b3a1,b4a0,ha2S,ha2R);
		-- colonna 5
		fa4 : FullAdder port map(b0a5,b1a4,b2a3,fa4S,fa4R);
		fa5 : FullAdder port map(b3a2,b4a1,b5a0,fa5S,fa5R);
		-- colonna 6
		fa6 : FullAdder port map(b0a6,b1a5,b2a4,fa6S,fa6R);
		fa7 : FullAdder port map(b3a3,b4a2,b5a1,fa7S,fa7R);
		-- colonna 7
		fa8 : FullAdder port map(b0a7,b1a6,b2a5,fa8S,fa8R);
		fa9 : FullAdder port map(b3a4,b4a3,b5a2,fa9S,fa9R);
		ha3 : HalfAdder port map(b6a1,n0,ha3S,ha3R);
		-- colonna 8
		fa10 : FullAdder port map(b1a7,b2a6,b3a5,fa10S,fa10R);
		fa11 : FullAdder port map(b4a4,b5a3,b6a2,fa11S,fa11R);
		-- colonna 9
		fa12 : FullAdder port map(b2a7,b3a6,b4a5,fa12S,fa12R);
		fa13 : FullAdder port map(b5a4,b6a3,n2,fa13S,fa13R);
		-- colonna 10
		fa14 : FullAdder port map(b3a7,b4a6,b5a5,fa14S,fa14R);
		ha4 : HalfAdder port map(b6a4,n3,ha4S,ha4R);
		-- colonna 11
		fa15  :FullAdder port map(b4a7,b5a6,b6a5,fa15S,fa15R);
		-- colonna 12
		fa16 : FullAdder port map(b5a7,b6a6,n5,fa16S,fa16R);
		-- colonna 13
		ha5 : HalfAdder port map(b6a7,n6,ha5S,ha5R);
		
		
		-- iterazione 2
		-- colonna 2
		ha6 : HalfAdder port map(ha1R,fa1S,ha6S,ha6R);
		-- colonna 3
		fa17 : FullAdder port map(fa1R,fa2S,b3a0,fa17S,fa17R);
		-- colonna 4
		fa18 : FullAdder port map(fa2R,fa3S,ha2S,fa18S,fa18R);
		-- colonna 5
		fa19  :FullAdder port map(fa3R,ha2R,fa4S,fa19S,fa19R);
		-- colonna 6
		fa20 : FullAdder port map(fa4R,fa5R,fa6S,fa20S,fa20R);
		ha7 : HalfAdder port map(fa7S,b6a0,ha7S,ha7R);
		-- colonna 7
		fa21 : FullAdder port map(fa6R,fa7R,fa8S,fa21S,fa21R);
		ha8 : HalfAdder port map(fa9S,ha3S,ha8S,ha8R);
		-- colonna 8
		fa22 : FullAdder port map(fa8R,fa9R,ha3R,fa22S,fa22R);
		fa23 : FullAdder port map(fa10S,fa11S,n1,fa23S,fa23R);
		-- colonna 9
		fa24 : FullAdder port map(fa10R,fa11R,fa12S,fa24S,fa24R);
		-- colonna 10
		fa25 : FullAdder port map(fa12R,fa13R,fa14S,fa25S,fa25R);
		-- colonna 11
		fa26 : FullAdder port map(fa14R,ha4R,fa15S,fa26S,fa26R);
		-- colonna 12
		ha9 : HalfAdder port map(fa15R,fa16S,ha9S,ha9R);
		-- colonna 13
		ha10 : HalfAdder port map(fa16R,ha5S,ha10S,ha10R);
		-- colonna 14
		ha11 : HalfAdder port map(ha5R,n7,ha11S,ha11R);
		
		
		-- iterazione 3
		-- colonna 3
		ha12 : HalfAdder port map(ha6R,fa17S,ha12S,ha12R);
		-- colonna 4
		ha13 : HalfAdder port map(fa17R,fa18S,ha13S,ha13R);
		-- colonna 5
		fa27 : FullAdder port map(fa18R,fa19S,fa5S,fa27S,fa27R);
		-- colonna 6
		fa28 : FullAdder port map(fa19R,fa20S,ha7S,fa28S,fa28R);
		-- colonna 7
		fa29 : FullAdder port map(fa20R,ha7R,fa21S,fa29S,fa29R);
		-- colonna 8
		fa30 : FullAdder port map(fa21R,ha8R,fa22S,fa30S,fa30R);
		-- colonna 9
		fa31 : FullAdder port map(fa22R,fa23R,fa24S,fa31S,fa31R);
		-- colonna 10
		fa32 : FullAdder port map(fa24R,fa25S,ha4S,fa32S,fa32R);
		-- colonna 11
		fa33 : FullAdder port map(fa25R,fa26S,n4,fa33S,fa33R);
		-- colonna 12
		ha14 : HalfAdder port map(fa26R,ha9S,ha14S,ha14R);
		-- colonna 13
		ha15 : HalfAdder port map(ha9R,ha10S,ha15S,ha15R);
		-- colonna 14
		ha16 : HalfAdder port map(ha10R,ha11S,ha16S,ha16R);
		
		
		-- iterazione 4
		-- colonna 4
		ha17 : HalfAdder port map(ha12R,ha13S,ha17S,ha17R);
		-- colonna 5
		ha18 : HalfAdder port map(ha13R,fa27S,ha18S,ha18R);
		-- colonna 6
		ha19 : HalfAdder port map(fa27R,fa28S,ha19S,ha19R);
		-- colonna 7
		fa34 : FullAdder port map(fa28R,fa29S,ha8S,fa34S,fa34R);
		-- colonna 8
		fa35 : FullAdder port map(fa29R,fa30S,fa23S,fa35S,fa35R);
		-- colonna 9
		fa36 : FullAdder port map(fa30R,fa31S,fa13S,fa36S,fa36R);
		-- colonna 10
		ha20 : HalfAdder port map(fa31R,fa32S,ha20S,ha20R);
		-- colonna 11
		ha21 : HalfAdder port map(fa32R,fa33S,ha21S,ha21R);
		-- colonna 12
		ha22 : HalfAdder port map(fa33R,ha14S,ha22S,ha22R);
		-- colonna 13
		ha23 : HalfAdder port map(ha14R,ha15S,ha23S,ha23R);
		-- colonna 14
		ha24 : HalfAdder port map(ha15R,ha16S,ha24S,ha24R);
		
		
		-- iterazione 5
		vmaIn1(0)<=ha17R; vmaIn2(0)<=ha18S;
		vmaIn1(1)<=ha18R; vmaIn2(1)<=ha19S;
		vmaIn1(2)<=ha19R; vmaIn2(2)<=fa34S;
		vmaIn1(3)<=fa34R; vmaIn2(3)<=fa35S;
		vmaIn1(4)<=fa35R; vmaIn2(4)<=fa36S;
		vmaIn1(5)<=fa36R; vmaIn2(5)<=ha20S;
		vmaIn1(6)<=ha20R; vmaIn2(6)<=ha21S;
		vmaIn1(7)<=ha21R; vmaIn2(7)<=ha22S;
		vmaIn1(8)<=ha22R; vmaIn2(8)<=ha23S;
		vmaIn1(9)<=ha23R; vmaIn2(9)<=ha24S;
		VMA : RippleCarryAdderSigned generic map(10) port map(vmaIn1,vmaIn2,'0',vmaO);
		
		
		-- Risultato
		Res(0)<=b0a0;
		Res(1)<=ha1S;
		Res(2)<=ha6S;
		Res(3)<=ha12S;
		Res(4)<=ha17S;
		Res(5)<=vmaO(0);
		Res(6)<=vmaO(1);
		Res(7)<=vmaO(2);
		Res(8)<=vmaO(3);
		Res(9)<=vmaO(4);
		Res(10)<=vmaO(5);
		Res(11)<=vmaO(6);
		Res(12)<=vmaO(7);
		Res(13)<=vmaO(8);
		Res(14)<=vmaO(9);
		Res(15)<= '1' when sB(7)='1' and sA(7)='1' else en7;
		RegResult: Reg generic map(16) port map(Res, CLK, sResult);
        Result<=sResult;
		

		

end Behavioral;