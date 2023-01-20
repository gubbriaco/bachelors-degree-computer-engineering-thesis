library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;

entity WallaceMultiplier16bit is
    port(
        A, B : in std_logic_vector(15 downto 0);
        CLK : in std_logic;
        Result : out std_logic_vector(31 downto 0)
    );
end WallaceMultiplier16bit;



architecture Behavioral of WallaceMultiplier16bit is

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
		generic(n : integer);
		port(
			A, B : in std_logic_vector(n-1 downto 0);
			Cin : in std_logic;
			S : out std_logic_vector(n downto 0)
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
    signal sA, sB : std_logic_vector(15 downto 0);
    signal Res,sResult : std_logic_vector(31 downto 0);
    
    -- output moltiplicazione a 16 bit
    signal b0a0,b0a1,b0a2,b0a3,b0a4,b0a5,b0a6,b0a7,b0a8,b0a9,b0a10,b0a11,b0a12,b0a13,b0a14,b0a15 : std_logic;
    signal b1a0,b1a1,b1a2,b1a3,b1a4,b1a5,b1a6,b1a7,b1a8,b1a9,b1a10,b1a11,b1a12,b1a13,b1a14,b1a15 : std_logic;
    signal b2a0,b2a1,b2a2,b2a3,b2a4,b2a5,b2a6,b2a7,b2a8,b2a9,b2a10,b2a11,b2a12,b2a13,b2a14,b2a15 : std_logic;
    signal b3a0,b3a1,b3a2,b3a3,b3a4,b3a5,b3a6,b3a7,b3a8,b3a9,b3a10,b3a11,b3a12,b3a13,b3a14,b3a15 : std_logic;
    signal b4a0,b4a1,b4a2,b4a3,b4a4,b4a5,b4a6,b4a7,b4a8,b4a9,b4a10,b4a11,b4a12,b4a13,b4a14,b4a15 : std_logic;
    signal b5a0,b5a1,b5a2,b5a3,b5a4,b5a5,b5a6,b5a7,b5a8,b5a9,b5a10,b5a11,b5a12,b5a13,b5a14,b5a15 : std_logic;
    signal b6a0,b6a1,b6a2,b6a3,b6a4,b6a5,b6a6,b6a7,b6a8,b6a9,b6a10,b6a11,b6a12,b6a13,b6a14,b6a15 : std_logic;
    signal b7a0,b7a1,b7a2,b7a3,b7a4,b7a5,b7a6,b7a7,b7a8,b7a9,b7a10,b7a11,b7a12,b7a13,b7a14,b7a15 : std_logic;
    signal b8a0,b8a1,b8a2,b8a3,b8a4,b8a5,b8a6,b8a7,b8a8,b8a9,b8a10,b8a11,b8a12,b8a13,b8a14,b8a15 : std_logic;
    signal b9a0,b9a1,b9a2,b9a3,b9a4,b9a5,b9a6,b9a7,b9a8,b9a9,b9a10,b9a11,b9a12,b9a13,b9a14,b9a15 : std_logic;
    signal b10a0,b10a1,b10a2,b10a3,b10a4,b10a5,b10a6,b10a7,b10a8,b10a9,b10a10,b10a11,b10a12,b10a13,b10a14,b10a15 : std_logic;
    signal b11a0,b11a1,b11a2,b11a3,b11a4,b11a5,b11a6,b11a7,b11a8,b11a9,b11a10,b11a11,b11a12,b11a13,b11a14,b11a15 : std_logic;
    signal b12a0,b12a1,b12a2,b12a3,b12a4,b12a5,b12a6,b12a7,b12a8,b12a9,b12a10,b12a11,b12a12,b12a13,b12a14,b12a15 : std_logic;
    signal b13a0,b13a1,b13a2,b13a3,b13a4,b13a5,b13a6,b13a7,b13a8,b13a9,b13a10,b13a11,b13a12,b13a13,b13a14,b13a15 : std_logic;
    signal b14a0,b14a1,b14a2,b14a3,b14a4,b14a5,b14a6,b14a7,b14a8,b14a9,b14a10,b14a11,b14a12,b14a13,b14a14,b14a15 : std_logic;
    signal b15a0,b15a1,b15a2,b15a3,b15a4,b15a5,b15a6,b15a7,b15a8,b15a9,b15a10,b15a11,b15a12,b15a13,b15a14,b15a15 : std_logic;
    
    signal n0, n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, en15 : std_logic;
    signal notA : std_logic_vector(15 downto 0);
    signal c2A : std_logic_vector(15 downto 0);
    
    -- signal di supporto
    -- signal per half-adder
    signal ha1S, ha2S, ha3S, ha4S, ha5S, ha6S, ha7S, ha8S, ha9S, ha10S, ha11S, ha12S, ha13S, ha14S : std_logic;
    signal ha15S, ha16S, ha17S, ha18S, ha19S, ha20S, ha21S, ha22S, ha23S, ha24S, ha25S, ha26S, ha27S, ha28S : std_logic;
    signal ha29S, ha30S, ha31S, ha32S, ha33S, ha34S, ha35S, ha36S, ha37S, ha38S, ha39S, ha40S, ha41S, ha42S : std_logic;
    signal ha43S, ha44S, ha45S, ha46S, ha47S, ha48S, ha49S, ha50S, ha51S, ha52S, ha53S, ha54S, ha55S, ha56S : std_logic;
    signal ha57S, ha58S, ha59S, ha60S, ha61S, ha62S, ha63S, ha64S, ha65S, ha66S, ha67S, ha68S, ha69S, ha70S : std_logic;
    signal ha71S, ha72S, ha73S, ha74S, ha75S, ha76S, ha77S, ha78S, ha79S, ha80S, ha81S : std_logic;
    signal ha1R, ha2R, ha3R, ha4R, ha5R, ha6R, ha7R, ha8R, ha9R, ha10R, ha11R, ha12R, ha13R, ha14R : std_logic;
    signal ha15R, ha16R, ha17R, ha18R, ha19R, ha20R, ha21R, ha22R, ha23R, ha24R, ha25R, ha26R, ha27R, ha28R : std_logic;
    signal ha29R, ha30R, ha31R, ha32R, ha33R, ha34R, ha35R, ha36R, ha37R, ha38R, ha39R, ha40R, ha41R, ha42R : std_logic;
    signal ha43R, ha44R, ha45R, ha46R, ha47R, ha48R, ha49R, ha50R, ha51R, ha52R, ha53R, ha54R, ha55R, ha56R : std_logic;
    signal ha57R, ha58R, ha59R, ha60R, ha61R, ha62R, ha63R, ha64R, ha65R, ha66R, ha67R, ha68R, ha69R, ha70R : std_logic;
    signal ha71R, ha72R, ha73R, ha74R, ha75R, ha76R, ha77R, ha78R, ha79R, ha80R, ha81R : std_logic;
    -- signal per full-adder
    signal fa1S, fa2S, fa3S, fa4S, fa5S, fa6S, fa7S, fa8S, fa9S, fa10S, fa11S, fa12S, fa13S, fa14S : std_logic;
    signal fa15S, fa16S, fa17S, fa18S, fa19S, fa20S, fa21S, fa22S, fa23S, fa24S, fa25S, fa26S, fa27S, fa28S : std_logic;
    signal fa29S, fa30S, fa31S, fa32S, fa33S, fa34S, fa35S, fa36S, fa37S, fa38S, fa39S, fa40S, fa41S, fa42S : std_logic;
    signal fa43S, fa44S, fa45S, fa46S, fa47S, fa48S, fa49S, fa50S, fa51S, fa52S, fa53S, fa54S, fa55S, fa56S : std_logic;
    signal fa57S, fa58S, fa59S, fa60S, fa61S, fa62S, fa63S, fa64S, fa65S, fa66S, fa67S, fa68S, fa69S, fa70S : std_logic;
    signal fa71S, fa72S, fa73S, fa74S, fa75S, fa76S, fa77S, fa78S, fa79S, fa80S, fa81S, fa82S, fa83S, fa84S : std_logic;
    signal fa85S, fa86S, fa87S, fa88S, fa89S, fa90S, fa91S, fa92S, fa93S, fa94S, fa95S, fa96S, fa97S, fa98S : std_logic;
    signal fa99S, fa100S, fa101S, fa102S, fa103S, fa104S, fa105S, fa106S, fa107S, fa108S, fa109S, fa110S, fa111S, fa112S : std_logic;
    signal fa113S, fa114S, fa115S, fa116S, fa117S, fa118S, fa119S, fa120S, fa121S, fa122S, fa123S, fa124S, fa125S, fa126S : std_logic;
    signal fa127S, fa128S, fa129S, fa130S, fa131S, fa132S, fa133S, fa134S, fa135S, fa136S, fa137S, fa138S, fa139S, fa140S : std_logic;
    signal fa141S, fa142S, fa143S, fa144S, fa145S, fa146S, fa147S, fa148S, fa149S, fa150S, fa151S, fa152S, fa153S, fa154S : std_logic;
    signal fa155S, fa156S, fa157S, fa158S, fa159S, fa160S, fa161S, fa162S, fa163S, fa164S, fa165S, fa166S, fa167S, fa168S, fa169S, fa170S : std_logic;
    signal fa171S, fa172S, fa173S, fa174S, fa175S, fa176S, fa177S, fa178S, fa179S, fa180S, fa181S, fa182S, fa183S, fa184S : std_logic;
    signal fa185S, fa186S, fa187S, fa188S, fa189S, fa190S, fa191S, fa192S, fa193S, fa194S, fa195S, fa196S : std_logic;
    signal fa1R, fa2R, fa3R, fa4R, fa5R, fa6R, fa7R, fa8R, fa9R, fa10R, fa11R, fa12R, fa13R, fa14R : std_logic;
    signal fa15R, fa16R, fa17R, fa18R, fa19R, fa20R, fa21R, fa22R, fa23R, fa24R, fa25R, fa26R, fa27R, fa28R : std_logic;
    signal fa29R, fa30R, fa31R, fa32R, fa33R, fa34R, fa35R, fa36R, fa37R, fa38R, fa39R, fa40R, fa41R, fa42R : std_logic;
    signal fa43R, fa44R, fa45R, fa46R, fa47R, fa48R, fa49R, fa50R, fa51R, fa52R, fa53R, fa54R, fa55R, fa56R : std_logic;
    signal fa57R, fa58R, fa59R, fa60R, fa61R, fa62R, fa63R, fa64R, fa65R, fa66R, fa67R, fa68R, fa69R, fa70R : std_logic;
    signal fa71R, fa72R, fa73R, fa74R, fa75R, fa76R, fa77R, fa78R, fa79R, fa80R, fa81R, fa82R, fa83R, fa84R : std_logic;
    signal fa85R, fa86R, fa87R, fa88R, fa89R, fa90R, fa91R, fa92R, fa93R, fa94R, fa95R, fa96R, fa97R, fa98R : std_logic;
    signal fa99R, fa100R, fa101R, fa102R, fa103R, fa104R, fa105R, fa106R, fa107R, fa108R, fa109R, fa110R, fa111R, fa112R : std_logic;
    signal fa113R, fa114R, fa115R, fa116R, fa117R, fa118R, fa119R, fa120R, fa121R, fa122R, fa123R, fa124R, fa125R, fa126R : std_logic;
    signal fa127R, fa128R, fa129R, fa130R, fa131R, fa132R, fa133R, fa134R, fa135R, fa136R, fa137R, fa138R, fa139R, fa140R : std_logic;
    signal fa141R, fa142R, fa143R, fa144R, fa145R, fa146R, fa147R, fa148R, fa149R, fa150R, fa151R, fa152R, fa153R, fa154R : std_logic;
    signal fa155R, fa156R, fa157R, fa158R, fa159R, fa160R, fa161R, fa162R, fa163R, fa164R, fa165R, fa166R, fa167R, fa168R, fa169R, fa170R : std_logic;
    signal fa171R, fa172R, fa173R, fa174R, fa175R, fa176R, fa177R, fa178R, fa179R, fa180R, fa181R, fa182R, fa183R, fa184R : std_logic;
    signal fa185R, fa186R, fa187R, fa188R, fa189R, fa190R, fa191R, fa192R, fa193R, fa194R, fa195R, fa196R : std_logic;
      
	  
	-- VMA signals  
    signal vmaIn1, vmaIn2 : std_logic_vector(23 downto 0);
    signal vmaO : std_logic_vector(24 downto 0);
    
    
    begin
        
		-- si inizializzano i due registri relativi agli ingressi
        RegA: Reg generic map(16) port map(A, CLK, sA);
        RegB: Reg generic map(16) port map(B, CLK, sB);
        
        -- iterazione 0 
        -- b0
        b0a0<=sB(0) and sA(0); b0a1<=sB(0) and sA(1); b0a2<=sB(0) and sA(2); b0a3<=sB(0) and sA(3); b0a4<=sB(0) and sA(4); 
        b0a5<=sB(0) and sA(5); b0a6<=sB(0) and sA(6); b0a7<=sB(0) and sA(7); b0a8<=sB(0) and sA(8); b0a9<=sB(0) and sA(9);
        b0a10<=sB(0) and sA(10); b0a11<=sB(0) and sA(11); b0a12<=sB(0) and sA(12); b0a13<=sB(0) and sA(13); 
        b0a14<=sB(0) and sA(14); b0a15<=sB(0) and sA(15);
        
        -- b1
        b1a0<=sB(1) and sA(0); b1a1<=sB(1) and sA(1); b1a2<=sB(1) and sA(2); b1a3<=sB(1) and sA(3); b1a4<=sB(1) and sA(4); 
        b1a5<=sB(1) and sA(5); b1a6<=sB(1) and sA(6); b1a7<=sB(1) and sA(7); b1a8<=sB(1) and sA(8); b1a9<=sB(1) and sA(9);
        b1a10<=sB(1) and sA(10); b1a11<=sB(1) and sA(11); b1a12<=sB(1) and sA(12); b1a13<=sB(1) and sA(13); 
        b1a14<=sB(1) and sA(14); b1a15<=sB(1) and sA(15);
        
        -- b2
        b2a0<=sB(2) and sA(0); b2a1<=sB(2) and sA(1); b2a2<=sB(2) and sA(2); b2a3<=sB(2) and sA(3); b2a4<=sB(2) and sA(4); 
        b2a5<=sB(2) and sA(5); b2a6<=sB(2) and sA(6); b2a7<=sB(2) and sA(7); b2a8<=sB(2) and sA(8); b2a9<=sB(2) and sA(9);
        b2a10<=sB(2) and sA(10); b2a11<=sB(2) and sA(11); b2a12<=sB(2) and sA(12); b2a13<=sB(2) and sA(13); 
        b2a14<=sB(2) and sA(14); b2a15<=sB(2) and sA(15);
        
        -- b3
        b3a0<=sB(3) and sA(0); b3a1<=sB(3) and sA(1); b3a2<=sB(3) and sA(2); b3a3<=sB(3) and sA(3); b3a4<=sB(3) and sA(4); 
        b3a5<=sB(3) and sA(5); b3a6<=sB(3) and sA(6); b3a7<=sB(3) and sA(7); b3a8<=sB(3) and sA(8); b3a9<=sB(3) and sA(9);
        b3a10<=sB(3) and sA(10); b3a11<=sB(3) and sA(11); b3a12<=sB(3) and sA(12); b3a13<=sB(3) and sA(13); 
        b3a14<=sB(3) and sA(14); b3a15<=sB(3) and sA(15);
        
        -- b4
        b4a0<=sB(4) and sA(0); b4a1<=sB(4) and sA(1); b4a2<=sB(4) and sA(2); b4a3<=sB(4) and sA(3); b4a4<=sB(4) and sA(4); 
        b4a5<=sB(4) and sA(5); b4a6<=sB(4) and sA(6); b4a7<=sB(4) and sA(7); b4a8<=sB(4) and sA(8); b4a9<=sB(4) and sA(9);
        b4a10<=sB(4) and sA(10); b4a11<=sB(4) and sA(11); b4a12<=sB(4) and sA(12); b4a13<=sB(4) and sA(13); 
        b4a14<=sB(4) and sA(14); b4a15<=sB(4) and sA(15);
        
        -- b5
        b5a0<=sB(5) and sA(0); b5a1<=sB(5) and sA(1); b5a2<=sB(5) and sA(2); b5a3<=sB(5) and sA(3); b5a4<=sB(5) and sA(4); 
        b5a5<=sB(5) and sA(5); b5a6<=sB(5) and sA(6); b5a7<=sB(5) and sA(7); b5a8<=sB(5) and sA(8); b5a9<=sB(5) and sA(9);
        b5a10<=sB(5) and sA(10); b5a11<=sB(5) and sA(11); b5a12<=sB(5) and sA(12); b5a13<=sB(5) and sA(13); 
        b5a14<=sB(5) and sA(14); b5a15<=sB(5) and sA(15);
        
        -- b6
        b6a0<=sB(6) and sA(0); b6a1<=sB(6) and sA(1); b6a2<=sB(6) and sA(2); b6a3<=sB(6) and sA(3); b6a4<=sB(6) and sA(4); 
        b6a5<=sB(6) and sA(5); b6a6<=sB(6) and sA(6); b6a7<=sB(6) and sA(7); b6a8<=sB(6) and sA(8); b6a9<=sB(6) and sA(9);
        b6a10<=sB(6) and sA(10); b6a11<=sB(6) and sA(11); b6a12<=sB(6) and sA(12); b6a13<=sB(6) and sA(13); 
        b6a14<=sB(6) and sA(14); b6a15<=sB(6) and sA(15);
        
        -- b7
        b7a0<=sB(7) and sA(0); b7a1<=sB(7) and sA(1); b7a2<=sB(7) and sA(2); b7a3<=sB(7) and sA(3); b7a4<=sB(7) and sA(4); 
        b7a5<=sB(7) and sA(5); b7a6<=sB(7) and sA(6); b7a7<=sB(7) and sA(7); b7a8<=sB(7) and sA(8); b7a9<=sB(7) and sA(9);
        b7a10<=sB(7) and sA(10); b7a11<=sB(7) and sA(11); b7a12<=sB(7) and sA(12); b7a13<=sB(7) and sA(13); 
        b7a14<=sB(7) and sA(14); b7a15<=sB(7) and sA(15);
        
        -- b8
        b8a0<=sB(8) and sA(0); b8a1<=sB(8) and sA(1); b8a2<=sB(8) and sA(2); b8a3<=sB(8) and sA(3); b8a4<=sB(8) and sA(4); 
        b8a5<=sB(8) and sA(5); b8a6<=sB(8) and sA(6); b8a7<=sB(8) and sA(7); b8a8<=sB(8) and sA(8); b8a9<=sB(8) and sA(9);
        b8a10<=sB(8) and sA(10); b8a11<=sB(8) and sA(11); b8a12<=sB(8) and sA(12); b8a13<=sB(8) and sA(13); 
        b8a14<=sB(8) and sA(14); b8a15<=sB(8) and sA(15);
        
        -- b9
        b9a0<=sB(9) and sA(0); b9a1<=sB(9) and sA(1); b9a2<=sB(9) and sA(2); b9a3<=sB(9) and sA(3); b9a4<=sB(9) and sA(4); 
        b9a5<=sB(9) and sA(5); b9a6<=sB(9) and sA(6); b9a7<=sB(9) and sA(7); b9a8<=sB(9) and sA(8); b9a9<=sB(9) and sA(9);
        b9a10<=sB(9) and sA(10); b9a11<=sB(9) and sA(11); b9a12<=sB(9) and sA(12); b9a13<=sB(9) and sA(13); 
        b9a14<=sB(9) and sA(14); b9a15<=sB(9) and sA(15);
        
        -- b10
        b10a0<=sB(10) and sA(0); b10a1<=sB(10) and sA(1); b10a2<=sB(10) and sA(2); b10a3<=sB(10) and sA(3); b10a4<=sB(10) and sA(4); 
        b10a5<=sB(10) and sA(5); b10a6<=sB(10) and sA(6); b10a7<=sB(10) and sA(7); b10a8<=sB(10) and sA(8); b10a9<=sB(10) and sA(9);
        b10a10<=sB(10) and sA(10); b10a11<=sB(10) and sA(11); b10a12<=sB(10) and sA(12); b10a13<=sB(10) and sA(13); 
        b10a14<=sB(10) and sA(14); b10a15<=sB(10) and sA(15);
        
        -- b11
        b11a0<=sB(11) and sA(0); b11a1<=sB(11) and sA(1); b11a2<=sB(11) and sA(2); b11a3<=sB(11) and sA(3); b11a4<=sB(11) and sA(4); 
        b11a5<=sB(11) and sA(5); b11a6<=sB(11) and sA(6); b11a7<=sB(11) and sA(7); b11a8<=sB(11) and sA(8); b11a9<=sB(11) and sA(9);
        b11a10<=sB(11) and sA(10); b11a11<=sB(11) and sA(11); b11a12<=sB(11) and sA(12); b11a13<=sB(11) and sA(13); 
        b11a14<=sB(11) and sA(14); b11a15<=sB(11) and sA(15);
        
        -- b12
        b12a0<=sB(12) and sA(0); b12a1<=sB(12) and sA(1); b12a2<=sB(12) and sA(2); b12a3<=sB(12) and sA(3); b12a4<=sB(12) and sA(4); 
        b12a5<=sB(12) and sA(5); b12a6<=sB(12) and sA(6); b12a7<=sB(12) and sA(7); b12a8<=sB(12) and sA(8); b12a9<=sB(12) and sA(9);
        b12a10<=sB(12) and sA(10); b12a11<=sB(12) and sA(11); b12a12<=sB(12) and sA(12); b12a13<=sB(12) and sA(13); 
        b12a14<=sB(12) and sA(14); b12a15<=sB(12) and sA(15);
        
        -- b13
        b13a0<=sB(13) and sA(0); b13a1<=sB(13) and sA(1); b13a2<=sB(13) and sA(2); b13a3<=sB(13) and sA(3); b13a4<=sB(13) and sA(4); 
        b13a5<=sB(13) and sA(5); b13a6<=sB(13) and sA(6); b13a7<=sB(13) and sA(7); b13a8<=sB(13) and sA(8); b13a9<=sB(13) and sA(9);
        b13a10<=sB(13) and sA(10); b13a11<=sB(13) and sA(11); b13a12<=sB(13) and sA(12); b13a13<=sB(13) and sA(13); 
        b13a14<=sB(13) and sA(14); b13a15<=sB(13) and sA(15);
        
        -- b14
        b14a0<=sB(14) and sA(0); b14a1<=sB(14) and sA(1); b14a2<=sB(14) and sA(2); b14a3<=sB(14) and sA(3); b14a4<=sB(14) and sA(4); 
        b14a5<=sB(14) and sA(5); b14a6<=sB(14) and sA(6); b14a7<=sB(14) and sA(7); b14a8<=sB(14) and sA(8); b14a9<=sB(14) and sA(9);
        b14a10<=sB(14) and sA(10); b14a11<=sB(14) and sA(11); b14a12<=sB(14) and sA(12); b14a13<=sB(14) and sA(13); 
        b14a14<=sB(14) and sA(14); b14a15<=sB(14) and sA(15);
        
        
        -- gestione del complemento a due e del segno
        -- se B e' positivo allora la riga in piu' presentera' tutti zeri e con segno '0'
        -- se B e' negativo allora verra' calcolato il complemento a due di A e il segno sara' la copia dell'ultimo bit calcolato
        
        for_assegnazione_notA : for i in 0 to 15 generate
            notA(i)<=not sA(i);
        end generate for_assegnazione_notA; 
        complemento_a_2_A : RippleCarryAdderUnsigned generic map(16) port map(notA, conv_std_logic_vector(1,16), '0', c2A, open);
        
                
        n0<= '0' when sB(15)='0' else c2A(0) when sB(15)='1' else 'X';
        n1<= '0' when sB(15)='0' else c2A(1) when sB(15)='1' else 'X';
        n2<= '0' when sB(15)='0' else c2A(2) when sB(15)='1' else 'X';
        n3<= '0' when sB(15)='0' else c2A(3) when sB(15)='1' else 'X';
        n4<= '0' when sB(15)='0' else c2A(4) when sB(15)='1' else 'X';
        n5<= '0' when sB(15)='0' else c2A(5) when sB(15)='1' else 'X';
        n6<= '0' when sB(15)='0' else c2A(6) when sB(15)='1' else 'X';
        n7<= '0' when sB(15)='0' else c2A(7) when sB(15)='1' else 'X';
        n8<= '0' when sB(15)='0' else c2A(8) when sB(15)='1' else 'X';
        n9<= '0' when sB(15)='0' else c2A(9) when sB(15)='1' else 'X';
        n10<= '0' when sB(15)='0' else c2A(10) when sB(15)='1' else 'X';
        n11<= '0' when sB(15)='0' else c2A(11) when sB(15)='1' else 'X';
        n12<= '0' when sB(15)='0' else c2A(12) when sB(15)='1' else 'X';
        n13<= '0' when sB(15)='0' else c2A(13) when sB(15)='1' else 'X';
        n14<= '0' when sB(15)='0' else c2A(14) when sB(15)='1' else 'X';
        n15<= '0' when sB(15)='0' else c2A(15) when sB(15)='1' else 'X';
             
        en15 <= n15;
      
        
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
        ha3 : HalfAdder port map(b6a1,b7a0,ha3S,ha3R);
        -- colonna 8
        fa10 : FullAdder port map(b0a8,b1a7,b2a6,fa10S,fa10R);
        fa11 : FullAdder port map(b3a5,b4a4,b5a3,fa11S,fa11R);
        fa12 : FullAdder port map(b6a2,b7a1,b8a0,fa12S,fa12R);
        -- colonna 9
        fa13 : FullAdder port map(b0a9,b1a8,b2a7,fa13S,fa13R);
        fa14 : FullAdder port map(b3a6,b4a5,b5a4,fa14S,fa14R);
        fa15 : FullAdder port map(b6a3,b7a2,b8a1,fa15S,fa15R);
        -- colonna 10
        fa16 : FullAdder port map(b0a10,b1a9,b2a8,fa16S,fa16R);
        fa17 : FullAdder port map(b3a7,b4a6,b5a5,fa17S,fa17R);
        fa18 : FullAdder port map(b6a4,b7a3,b8a2,fa18S,fa18R);
        ha4 : HalfAdder port map(b9a1,b10a0,ha4S,ha4R);
        -- colonna 11
        fa19 : FullAdder port map(b0a11,b1a10,b2a9,fa19S,fa19R);
        fa20 : FullAdder port map(b3a8,b4a7,b5a6,fa20S,fa20R);
        fa21 : FullAdder port map(b6a5,b7a4,b8a3,fa21S,fa21R);
        fa22 : FullAdder port map(b9a2,b10a1,b11a0,fa22S,fa22R);
        -- colonna 12
        fa23 : FullAdder port map(b0a12,b1a11,b2a10,fa23S,fa23R);
        fa24 : FullAdder port map(b3a9,b4a8,b5a7,fa24S,fa24R);
        fa25 : FullAdder port map(b6a6,b7a5,b8a4,fa25S,fa25R);
        fa26 : FullAdder port map(b9a3,b10a2,b11a1,fa26S,fa26R);
        -- colonna 13
        fa27 : FullAdder port map(b0a13,b1a12,b2a11,fa27S,fa27R);
        fa28 : FullAdder port map(b3a10,b4a9,b5a8,fa28S,fa28R);
        fa29 : FullAdder port map(b6a7,b7a6,b8a5,fa29S,fa29R);
        fa30 : FullAdder port map(b9a4,b10a3,b11a2,fa30S,fa30R);
        ha5 : HalfAdder port map(b12a1,b13a0,ha5S,ha5R);
        -- colonna 14
        fa31 : FullAdder port map(b0a14,b1a13,b2a12,fa31S,fa31R);
        fa32 : FullAdder port map(b3a11,b4a10,b5a9,fa32S,fa32R);
        fa33 : FullAdder port map(b6a8,b7a7,b8a6,fa33S,fa33R);
        fa34 : FullAdder port map(b9a5,b10a4,b11a3,fa34S,fa34R);
        fa35 : FullAdder port map(b12a2,b13a1,b14a0,fa35S,fa35R);
        -- colonna 15
        fa36 : FullAdder port map(b0a15,b1a14,b2a13,fa36S,fa36R);
        fa37 : FullAdder port map(b3a12,b4a11,b5a10,fa37S,fa37R);
        fa38 : FullAdder port map(b6a9,b7a8,b8a7,fa38S,fa38R);
        fa39 : FullAdder port map(b9a6,b10a5,b11a4,fa39S,fa39R);
        fa40 : FullAdder port map(b12a3,b13a2,b14a1,fa40S,fa40R);
        -- colonna 16
        fa41 : FullAdder port map(b1a15,b2a14,b3a13,fa41S,fa41R);
        fa42 : FullAdder port map(b4a12,b5a11,b6a10,fa42S,fa42R);
        fa43 : FullAdder port map(b7a9,b8a8,b9a7,fa43S,fa43R);
        fa44 : FullAdder port map(b10a6,b11a5,b12a4,fa44S,fa44R);
        fa45 : FullAdder port map(b13a3,b14a2,n1,fa45S,fa45R);
        -- colonna 17
        fa46 : FullAdder port map(b2a15,b3a14,b4a13,fa46S,fa46R);
        fa47 : FullAdder port map(b5a12,b6a11,b7a10,fa47S,fa47R);
        fa48 : FullAdder port map(b8a9,b9a8,b10a7,fa48S,fa48R);
        fa49 : FullAdder port map(b11a6,b12a5,b13a4,fa49S,fa49R);
        ha6 : HalfAdder port map(b14a3,n2,ha6S,ha6R);
        -- colonna 18
        fa50 : FullAdder port map(b3a15,b4a14,b5a13,fa50S,fa50R);
        fa51 : FullAdder port map(b6a12,b7a11,b8a10,fa51S,fa51R);
        fa52 : FullAdder port map(b9a9,b10a8,b11a7,fa52S,fa52R);
        fa53 : FullAdder port map(b12a6,b13a5,b14a4,fa53S,fa53R);
        -- colonna 19
        fa54 : FullAdder port map(b4a15,b5a14,b6a13,fa54S,fa54R);
        fa55 : FullAdder port map(b7a12,b8a11,b9a10,fa55S,fa55R);
        fa56 : FullAdder port map(b10a9,b11a8,b12a7,fa56S,fa56R);
        fa57 : FullAdder port map(b13a6,b14a5,n4,fa57S,fa57R);
        -- colonna 20
        fa58 : FullAdder port map(b5a15,b6a14,b7a13,fa58S,fa58R);
        fa59 : FullAdder port map(b8a12,b9a11,b10a10,fa59S,fa59R);
        fa60 : FullAdder port map(b11a9,b12a8,b13a7,fa60S,fa60R);
        ha7 : HalfAdder port map(b14a6,n5,ha7S,ha7R);
        -- colonna 21
        fa61 : FullAdder port map(b6a15,b7a14,b8a13,fa61S,fa61R);
        fa62 : FullAdder port map(b9a12,b10a11,b11a10,fa62S,fa62R);
        fa63 : FullAdder port map(b12a9,b13a8,b14a7,fa63S,fa63R);
        -- colonna 22
        fa64 : FullAdder port map(b7a15,b8a14,b9a13,fa64S,fa64R);
        fa65 : FullAdder port map(b10a12,b11a11,b12a10,fa65S,fa65R);
        fa66 : FullAdder port map(b13a9,b14a8,n7,fa66S,fa66R);
        -- colonna 23
        fa67 : FullAdder port map(b8a15,b9a14,b10a13,fa67S,fa67R);
        fa68 : FullAdder port map(b11a12,b12a11,b13a10,fa68S,fa68R);
        ha8 : HalfAdder port map(b14a9,n8,ha8S,ha8R);
        -- colonna 24
        fa69 : FullAdder port map(b9a15,b10a14,b11a13,fa69S,fa69R);
        fa70 : FullAdder port map(b12a12,b13a11,b14a10,fa70S,fa70R);
        -- colonna 25
        fa71 : FullAdder port map(b10a15,b11a14,b12a13,fa71S,fa71R);
        fa72 : FullAdder port map(b13a12,b14a11,n10,fa72S,fa72R);
        -- colonna 26
        fa73 : FullAdder port map(b11a15,b12a14,b13a13,fa73S,fa73R);
        ha9 : HalfAdder port map(b14a12,n11,ha9S,ha9R);
        -- colonna 27
        fa74 : FullAdder port map(b12a15,b13a14,b14a13,fa74S,fa74R);
        -- colonna 28
        fa75 : FullAdder port map(b13a15,b14a14,n13,fa75S,fa75R);
        -- colonna 29
        ha10 : HalfAdder port map(b14a15,n14,ha10S,ha10R);
        
        
        -- iterazione 2
        -- colonna 2
        ha11 : HalfAdder port map(ha1R,fa1S,ha11S,ha11R);
        -- colonna 3
        fa76 : FullAdder port map(fa1R,fa2S,b3a0,fa76S,fa76R);
        -- colonna 4
        fa77 : FullAdder port map(fa2R,fa3S,ha2S,fa77S,fa77R);
        -- colonna 5
        fa78 : FullAdder port map(fa3R,ha2R,fa4S,fa78S,fa78R);
        -- colonna 6
        fa79 : FullAdder port map(fa4R,fa5R,fa6S,fa79S,fa79R);
        ha12 : HalfAdder port map(fa7S,b6a0,ha12S,ha12R);
        -- colonna 7
        fa80 : FullAdder port map(fa6R,fa7R,fa8S,fa80S,fa80R);
        ha13 : HalfAdder port map(fa9S,ha3S,ha13S,ha13R);
        -- colonna 8
        fa81 : FullAdder port map(fa8R,fa9R,ha3R,fa81S,fa81R);
        fa82 : FullAdder port map(fa10S,fa11S,fa12S,fa82S,fa82R);
        -- colonna 9
        fa83 : FullAdder port map(fa10R,fa11R,fa12R,fa83S,fa83R);
        fa84 : FullAdder port map(fa13S,fa14S,fa15S,fa84S,fa84R);
        -- colonna 10
        fa85 : FullAdder port map(fa13R,fa14R,fa15R,fa85S,fa85R);
        fa86 : FullAdder port map(fa16S,fa17S,fa18S,fa86S,fa86R);
        -- colonna 11
        fa87 : FullAdder port map(fa16R,fa17R,fa18R,fa87S,fa87R);
        fa88 : FullAdder port map(ha4R,fa19S,fa20S,fa88S,fa88R);
        ha14 : HalfAdder port map(fa21S,fa22S,ha14S,ha14R);
        -- colonna 12
        fa89 : FullAdder port map(fa19R,fa20R,fa21R,fa89S,fa89R);
        fa90 : FullAdder port map(fa22R,fa23S,fa24S,fa90S,fa90R);
        fa91 : FullAdder port map(fa25S,fa26S,b12a0,fa91S,fa91R);
        -- colonna 13
        fa92 : FullAdder port map(fa23R,fa24R,fa25R,fa92S,fa92R);
        fa93 : FullAdder port map(fa26R,fa27S,fa28S,fa93S,fa93R);
        fa94 : FullAdder port map(fa29S,fa30S,ha5S,fa94S,fa94R);
        -- colonna 14
        fa95 : FullAdder port map(fa27R,fa28R,fa29R,fa95S,fa95R);
        fa96 : FullAdder port map(fa30R,ha5R,fa31S,fa96S,fa96R);
        fa97 : FullAdder port map(fa32S,fa33S,fa34S,fa97S,fa97R);
        -- colonna 15
        fa98 : FullAdder port map(fa31R,fa32R,fa33R,fa98S,fa98R);
        fa99 : FullAdder port map(fa34R,fa35R,fa36S,fa99S,fa99R);
        fa100 : FullAdder port map(fa37S,fa38S,fa39S,fa100S,fa100R);
        ha15 : HalfAdder port map(fa40S,n0,ha15S,ha15R);
        -- colonna 16
        fa101 : FullAdder port map(fa36R,fa37R,fa38R,fa101S,fa101R);
        fa102 : FullAdder port map(fa39R,fa40R,fa41S,fa102S,fa102R);
        fa103 : FullAdder port map(fa42S,fa43S,fa44S,fa103S,fa103R);
        -- colonna 17
        fa104 : FullAdder port map(fa41R,fa42R,fa43R,fa104S,fa104R);
        fa105 : FullAdder port map(fa44R,fa45R,fa46S,fa105S,fa105R);
        fa106 : FullAdder port map(fa47S,fa48S,fa49S,fa106S,fa106R);
        -- colonna 18
        fa107 : FullAdder port map(fa46R,fa47R,fa48R,fa107S,fa107R);
        fa108 : FullAdder port map(fa49R,ha6R,fa50S,fa108S,fa108R);
        fa109 : FullAdder port map(fa51S,fa52S,fa53S,fa109S,fa109R);
        -- colonna 19
        fa110 : FullAdder port map(fa50R,fa51R,fa52R,fa110S,fa110R);
        fa111 : FullAdder port map(fa53R,fa54S,fa55S,fa111S,fa111R);
        ha16 : HalfAdder port map(fa56S,fa57S,ha16S,ha16R);
        -- colonna 20
        fa112 : FullAdder port map(fa54R,fa55R,fa56R,fa112S,fa112R);
        fa113 : FullAdder port map(fa57R,fa58S,fa59S,fa113S,fa113R);
        ha17 : HalfAdder port map(fa60S,ha7S,ha17S,ha17R);
        -- colonna 21
        fa114 : FullAdder port map(fa58R,fa59R,fa60R,fa114S,fa114R);
        fa115 : FullAdder port map(ha7R,fa61S,fa62S,fa115S,fa115R);
        ha18 : HalfAdder port map(fa63S,n6,ha18S,ha18R);
        -- colonna 22
        fa116 : FullAdder port map(fa61R,fa62R,fa63R,fa116S,fa116R);
        fa117 : FullAdder port map(fa64S,fa65S,fa66S,fa117S,fa117R);
        -- colonna 23
        fa118 : FullAdder port map(fa64R,fa65R,fa66R,fa118S,fa118R);
        fa119 : FullAdder port map(fa67S,fa68S,ha8S,fa119S,fa119R);
        -- colonna 24
        fa120 : FullAdder port map(fa67R,fa68R,ha8R,fa120S,fa120R);
        fa121 : FullAdder port map(fa69S,fa70S,n9,fa121S,fa121R);
        -- colonna 25
        fa122 : FullAdder port map(fa69R,fa70R,fa71S,fa122S,fa122R);
        -- colonna 26
        fa123 : FullAdder port map(fa71R,fa72R,fa73S,fa123S,fa123R);
        -- colonna 27
        fa124 : FullAdder port map(fa73R,ha9R,fa74S,fa124S,fa124R);
        -- colonna 28
        ha19 : HalfAdder port map(fa74R,fa75S,ha19S,ha19R);
        -- colonna 29
        ha20 : HalfAdder port map(fa75R,ha10S,ha20S,ha20R);
        -- colonna 30
        ha21 : HalfAdder port map(ha10R,n15,ha21S,ha21R);
        
        
        -- iterazione 3
        -- colonna 3
        ha22 : HalfAdder port map(ha11R,fa76S,ha22s,ha22R);
        -- colonna 4
        ha23 : HalfAdder port map(fa76R,fa77S,ha23S,ha23R);
        -- colonna 5
        fa125 : FullAdder port map(fa77R,fa78S,fa5S,fa125S,fa125R);
        -- colonna 6
        fa126 : FullAdder port map(fa78R,fa79S,ha12S,fa126S,fa126R);
        -- colonna 7
        fa127 : FullAdder port map(fa79R,ha12R,fa80S,fa127S,fa127R);
        -- colonna 8
        fa128 : FullAdder port map(fa80R,ha13R,fa81S,fa128S,fa128R);
        -- colonna 9
        fa129 : FullAdder port map(fa81R,fa82R,fa83S,fa129S,fa129R);
        ha24 : HalfAdder port map(fa84S,b9a0,ha24S,ha24R);
        -- colonna 10
        fa130 : FullAdder port map(fa83R,fa84R,fa85S,fa130S,fa130R);
        ha25 : HalfAdder port map(fa86S,ha4S,ha25S,ha25R);
        -- colonna 11
        fa131 : FullAdder port map(fa85R,fa86R,fa87S,fa131S,fa131R);
        ha26 : HalfAdder port map(fa88S,ha14S,ha26S,ha26R);
        -- colonna 12
        fa132 : FullAdder port map(fa87R,fa88R,ha14R,fa132S,fa132R);
        fa133 : FullAdder port map(fa89S,fa90S,fa91S,fa133S,fa133R);
        -- colonna 13
        fa134 : FullAdder port map(fa89R,fa90R,fa91R,fa134S,fa134R);
        fa135 : FullAdder port map(fa92S,fa93S,fa94S,fa135S,fa135R);
        -- colonna 14
        fa136 : FullAdder port map(fa92R,fa93R,fa94R,fa136S,fa136R);
        fa137 : FullAdder port map(fa95S,fa96S,fa97S,fa137S,fa137R);
        -- colonna 15
        fa138 : FullAdder port map(fa95R,fa96R,fa97R,fa138S,fa138R);
        fa139 : FullAdder port map(fa98S,fa99S,fa100S,fa139S,fa139R);
        -- colonna 16
        fa140 : FullAdder port map(fa98R,fa99R,fa100R,fa140S,fa140R);
        fa141 : FullAdder port map(ha15R,fa101S,fa102S,fa141S,fa141R);
        ha27 : HalfAdder port map(fa103S,fa45S,ha27S,ha27R);
        -- colonna 17
        fa142 : FullAdder port map(fa101R,fa102R,fa103R,fa142S,fa142R);
        fa143 : FullAdder port map(fa104S,fa105S,fa106S,fa143S,fa143R);
        -- colonna 18
        fa144 : FullAdder port map(fa104R,fa105R,fa106R,fa144S,fa144R);
        fa145 : FullAdder port map(fa107S,fa108S,fa109S,fa145S,fa145R);
        -- colonna 19
        fa146 : FullAdder port map(fa107R,fa108R,fa109R,fa146S,fa146R);
        fa147 : FullAdder port map(fa110S,fa111S,ha16S,fa147S,fa147R);
        -- colonna 20
        fa148 : FullAdder port map(fa110R,fa111R,ha16R,fa148S,fa148R);
        fa149 : FullAdder port map(fa112S,fa113S,ha17S,fa149S,fa149R);
        -- colonna 21
        fa150 : FullAdder port map(fa112R,fa113R,ha17R,fa150S,fa150R);
        fa151 : FullAdder port map(fa114S,fa115S,ha18S,fa151S,fa151R);
        -- colonna 22
        fa152 : FullAdder port map(fa114R,fa115R,ha18R,fa152S,fa152R);
        ha28 : HalfAdder port map(fa116S,fa117S,ha28S,ha28R);
        -- colonna 23
        fa153 : FullAdder port map(fa116R,fa117R,fa118S,fa153S,fa153R);
        -- colonna 24
        fa154 : FullAdder port map(fa118R,fa119R,fa120S,fa154S,fa154R);
        -- colonna 25
        fa155 : FullAdder port map(fa120R,fa121R,fa122S,fa155S,fa155R);
        -- colonna 26
        fa156 : FullAdder port map(fa122R,fa123S,ha9S,fa156S,fa156R);
        -- colonna 27
        fa157 : FullAdder port map(fa123R,fa124S,n12,fa157S,fa157R);
        -- colonna 28
        ha29 : HalfAdder port map(fa124R,ha19S,ha29S,ha29R);
        -- colonna 29
        ha30 : HalfAdder port map(ha19R,ha20S,ha30S,ha30R);
        -- colonna 30
        ha31 : HalfAdder port map(ha20R,ha21S,ha31S,ha31R);
        
        
        -- iterazione 4
        -- colonna 4
        ha33 : HalfAdder port map(ha22R,ha23S,ha33S,ha33R);
        -- colonna 5
        ha34 : HalfAdder port map(ha23R,fa125S,ha34S,ha34R);
        -- colonna 6
        ha35 : HalfAdder port map(fa125R,fa126S,ha35S,ha35R);
        -- colonna 7
        fa158 : FullAdder port map(fa126R,fa127S,ha13S,fa158S,fa158R);
        -- colonna 8
        fa159 : FullAdder port map(fa127R,fa128S,fa82S,fa159S,fa159R);
        -- colonna 9
        fa160 : FullAdder port map(fa128R,fa129S,ha24S,fa160S,fa160R);
        -- colonna 10
        fa161 : FullAdder port map(fa129R,ha24R,fa130S,fa161S,fa161R);
        -- colonna 11
        fa162 : FullAdder port map(fa130R,ha25R,fa131S,fa162S,fa162R);
        -- colonna 12
        fa163 : FullAdder port map(fa131R,ha26R,fa132S,fa163S,fa163R);
        -- colonna 13
        fa164 : FullAdder port map(fa132R,fa133R,fa134S,fa164S,fa164R);
        -- colonna 14
        fa165 : FullAdder port map(fa134R,fa135R,fa136S,fa165S,fa165R);
        ha36 : HalfAdder port map(fa137S,fa35S,ha36S,ha36R);
        -- colonna 15
        fa166 : FullAdder port map(fa136R,fa137R,fa138S,fa166S,fa166R);
        ha37 : HalfAdder port map(fa139S,ha15S,ha37S,ha37R);
        -- colonna 16
        fa167 : FullAdder port map(fa138R,fa139R,fa140S,fa167S,fa167R);
        ha38 : HalfAdder port map(fa141S,ha27S,ha38S,ha38R);
        -- colonna 17
        fa168 : FullAdder port map(fa140R,fa141R,ha27R,fa168S,fa168R);
        fa169 : FullAdder port map(fa142S,fa143S,ha6S,fa169S,fa169R);
        -- colonna 18
        fa170 : FullAdder port map(fa142R,fa143R,fa144S,fa170S,fa170R);
        ha39 : HalfAdder port map(fa145S,n3,ha39S,ha39R);
        -- colonna 19
        fa171 : FullAdder port map(fa144R,fa145R,fa146S,fa171S,fa171R);
        -- colonna 20
        fa172 : FullAdder port map(fa146R,fa147R,fa148S,fa172S,fa172R);
        -- colonna 21
        fa173 : FullAdder port map(fa148R,fa149R,fa150S,fa173S,fa173R);
        -- colonna 22
        fa174 : FullAdder port map(fa150R,fa151R,fa152S,fa174S,fa174R);
        -- colonna 23
        fa175 : FullAdder port map(fa152R,ha28R,fa153S,fa175S,fa175R);
        -- colonna 24
        fa176 : FullAdder port map(fa153R,fa154S,fa121S,fa176S,fa176R);
        -- colonna 25
        fa177 : FullAdder port map(fa154R,fa155S,fa72S,fa177S,fa177R);
        -- colonna 26
        ha40: HalfAdder port map(fa155R,fa156S,ha40S,ha40R);
        -- colonna 27
        ha41: HalfAdder port map(fa156R,fa157S,ha41S,ha41R);
        -- colonna 28
        ha42: HalfAdder port map(fa157R,ha29S,ha42S,ha42R);
        -- colonna 29
        ha43: HalfAdder port map(ha29R,ha30S,ha43S,ha43R);
        -- colonna 30
        ha44: HalfAdder port map(ha30R,ha31S,ha44S,ha44R);
        
        
        -- iterazione 5
        -- colonna 5
        ha46 : HalfAdder port map(ha33R,ha34S,ha46S,ha46R);
        -- colonna 6
        ha47 : HalfAdder port map(ha34R,ha35S,ha47S,ha47R);
        -- colonna 7
        ha48 : HalfAdder port map(ha35R,fa158S,ha48S,ha48R);
        -- oclonna 8
        ha49 : HalfAdder port map(fa158R,fa159S,ha49S,ha49R);
        -- colonna 9
        ha50 : HalfAdder port map(fa159R,fa160S,ha50S,ha50R);
        -- colonna 10
        fa178 : FullAdder port map(fa160R,fa161S,ha25S,fa178S,fa178R);
        -- colonna 11
        fa179 : FullAdder port map(fa161R,fa162S,ha26S,fa179S,fa179R);
        -- colonna 12
        fa180 : FullAdder port map(fa162R,fa163S,fa133S,fa180S,fa180R);
        -- colonna 13
        fa181 : FullAdder port map(fa163R,fa164S,fa135S,fa181S,fa181R);
        -- colonna 14
        fa182 : FullAdder port map(fa164R,fa165S,ha36S,fa182S,fa182R);
        -- colonna 15
        fa183 : FullAdder port map(fa165R,ha36R,fa166S,fa183S,fa183R);
        -- colonna 16
        fa184 : FullAdder port map(fa166R,ha37R,fa167S,fa184S,fa184R);
        -- colonna 17
        fa185 : FullAdder port map(fa167R,ha38R,fa168S,fa185S,fa185R);
        -- colonna 18
        fa186 : FullAdder port map(fa168R,fa169R,fa170S,fa186S,fa186R);
        -- colonna 19
        fa187 : FullAdder port map(fa170R,ha39R,fa171S,fa187S,fa187R);
        -- colonna 20
        fa188 : FullAdder port map(fa171R,fa172S,fa149S,fa188S,fa188R);
        -- colonna 21
        fa189 : FullAdder port map(fa172R,fa173S,fa151S,fa189S,fa189R);
        -- colonna 22
        fa190 : FullAdder port map(fa173R,fa174S,ha28S,fa190S,fa190R);
        -- colonna 23
        fa191 : FullAdder port map(fa174R,fa175S,fa119S,fa191S,fa191R);
        -- colonna 24
        ha51: HalfAdder port map(fa175R,fa176S,ha51S,ha51R);
        -- colonna 25
        ha52: HalfAdder port map(fa176R,fa177S,ha52S,ha52R);
        -- colonna 26
        ha53: HalfAdder port map(fa177R,ha40S,ha53S,ha53R);
        -- colonna 27
        ha54: HalfAdder port map(ha40R,ha41S,ha54S,ha54R);
        -- colonna 28
        ha55: HalfAdder port map(ha41R,ha42S,ha55S,ha55R);
        -- colonna 29
        ha56: HalfAdder port map(ha42R,ha43S,ha56S,ha56R);
        -- colonna 30
        ha57: HalfAdder port map(ha43R,ha44S,ha57S,ha57R);
        
        
        -- iterazione 6
        -- colonna 6
        ha60 : HalfAdder port map(ha46R,ha47S,ha60S,ha60R);
        -- colonna 7
        ha61 : HalfAdder port map(ha47R,ha48S,ha61S,ha61R);
        -- colonna 8
        ha62 : HalfAdder port map(ha48R,ha49S,ha62S,ha62R);
        -- colonna 9
        ha63 : HalfAdder port map(ha49R,ha50S,ha63S,ha63R);
        -- colonna 10
        ha64 : HalfAdder port map(ha50R,fa178S,ha64S,ha64R);
        -- colonna 11
        ha65 : HalfAdder port map(fa178R,fa179S,ha65S,ha65R);
        -- colonna 12
        ha66 : HalfAdder port map(fa179R,fa180S,ha66S,ha66R);
        -- colonna 13
        ha67 : HalfAdder port map(fa180R,fa181S,ha67S,ha67R);
        -- colonna 14
        ha68 : HalfAdder port map(fa181R,fa182S,ha68S,ha68R);
        -- colonna 15
        fa192 : FullAdder port map(fa182R,fa183S,ha37S,fa192S,fa192R);
        -- colonna 16
        fa193 : FullAdder port map(fa183R,fa184S,ha38S,fa193S,fa193R);
        -- colonna 17
        fa194 : FullAdder port map(fa184R,fa185S,fa169S,fa194S,fa194R);
        -- colonna 18
        fa195 : FullAdder port map(fa185R,fa186S,ha39S,fa195S,fa195R);
        -- colonna 19
        fa196 : FullAdder port map(fa186R,fa187S,fa147S,fa196S,fa196R);
        -- colonna 20
        ha69 : HalfAdder port map(fa187R,fa188S,ha69S,ha69R);
        -- colonna 21
        ha70 : HalfAdder port map(fa188R,fa189S,ha70S,ha70R);
        -- colonna 22
        ha71 : HalfAdder port map(fa189R,fa190S,ha71S,ha71R);
        -- colonna 23
        ha72 : HalfAdder port map(fa190R,fa191S,ha72S,ha72R);
        -- colonna 24
        ha73 : HalfAdder port map(fa191R,ha51S,ha73S,ha73R);
        -- colonna 25
        ha74 : HalfAdder port map(ha51R,ha52S,ha74S,ha74R);
        -- colonna 26
        ha75 : HalfAdder port map(ha52R,ha53S,ha75S,ha75R);
        -- colonna 27
        ha76 : HalfAdder port map(ha53R,ha54S,ha76S,ha76R);
        -- colonna 28
        ha77 : HalfAdder port map(ha54R,ha55S,ha77S,ha77R);
        -- colonna 29
        ha78 : HalfAdder port map(ha55R,ha56S,ha78S,ha78R);
        -- colonna 30
        ha79 : HalfAdder port map(ha56R,ha57S,ha79S,ha79R);
        
        
        -- iterazione 7
         vmaIn1(0)<=ha60R;  vmaIn2(0)<=ha61S;
         vmaIn1(1)<=ha61R;  vmaIn2(1)<=ha62S;
         vmaIn1(2)<=ha62R;  vmaIn2(2)<=ha63S;
         vmaIn1(3)<=ha63R;  vmaIn2(3)<=ha64S;
         vmaIn1(4)<=ha64R;  vmaIn2(4)<=ha65S;
         vmaIn1(5)<=ha65R;  vmaIn2(5)<=ha66S;
         vmaIn1(6)<=ha66R;  vmaIn2(6)<=ha67S;
         vmaIn1(7)<=ha67R;  vmaIn2(7)<=ha68S;
         vmaIn1(8)<=ha68R;  vmaIn2(8)<=fa192S;
         vmaIn1(9)<=fa192R; vmaIn2(9)<=fa193S;
        vmaIn1(10)<=fa193R; vmaIn2(10)<=fa194S;
        vmaIn1(11)<=fa194R; vmaIn2(11)<=fa195S;
        vmaIn1(12)<=fa195R; vmaIn2(12)<=fa196S;
        vmaIn1(13)<=fa196R; vmaIn2(13)<=ha69S;
        vmaIn1(14)<=ha69R;  vmaIn2(14)<=ha70S;
        vmaIn1(15)<=ha70R;  vmaIn2(15)<=ha71S;
        vmaIn1(16)<=ha71R;  vmaIn2(16)<=ha72S;
        vmaIn1(17)<=ha72R;  vmaIn2(17)<=ha73S;
        vmaIn1(18)<=ha73R;  vmaIn2(18)<=ha74S;
        vmaIn1(19)<=ha74R;  vmaIn2(19)<=ha75S;
        vmaIn1(20)<=ha75R;  vmaIn2(20)<=ha76S;
        vmaIn1(21)<=ha76R;  vmaIn2(21)<=ha77S;
        vmaIn1(22)<=ha77R;  vmaIn2(22)<=ha78S;
        vmaIn1(23)<=ha78R;  vmaIn2(23)<=ha79S;
        VMA : RippleCarryAdderSigned generic map(24) port map(vmaIn1,vmaIn2,'0',vmaO);
        
        
        -- Risultato
        Res(0)<=b0a0;
        Res(1)<=ha1S;
        Res(2)<=ha11S;
        Res(3)<=ha22S;
        Res(4)<=ha33S;
        Res(5)<=ha46S;
        Res(6)<=ha60S;
        Res(7)<=vmaO(0);
        Res(8)<=vmaO(1);
        Res(9)<=vmaO(2);
        Res(10)<=vmaO(3);
        Res(11)<=vmaO(4);
        Res(12)<=vmaO(5);
        Res(13)<=vmaO(6);
        Res(14)<=vmaO(7);
        Res(15)<=vmaO(8);
        Res(16)<=vmaO(9);
        Res(17)<=vmaO(10);
        Res(18)<=vmaO(11);
        Res(19)<=vmaO(12);
        Res(20)<=vmaO(13);
        Res(21)<=vmaO(14);
        Res(22)<=vmaO(15);
        Res(23)<=vmaO(16);
        Res(24)<=vmaO(17);
        Res(25)<=vmaO(18);
        Res(26)<=vmaO(19);
        Res(27)<=vmaO(20);
        Res(28)<=vmaO(21);
        Res(29)<=vmaO(22);
        Res(30)<=vmaO(23);
        Res(31)<= '1' when sB(15)='1' and sA(15)='1' else en15;
        RegResult: Reg generic map(32) port map(Res, CLK, sResult);
        Result<=sResult;
        
        
        
        
end Behavioral;
