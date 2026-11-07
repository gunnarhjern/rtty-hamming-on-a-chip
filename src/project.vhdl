library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tt_um_example is
    port (
        ui_in   : in  std_logic_vector(7 downto 0); --ren 8-bit ingång
        uo_out  : out std_logic_vector(7 downto 0); -- ren 8-bit utgång
        uio_in  : in  std_logic_vector(7 downto 0); -- comb in --
        uio_out : out std_logic_vector(7 downto 0); -- comb out
        uio_oe  : out std_logic_vector(7 downto 0); -- i/o-mask

        ena     : in  std_logic; -- ????
        clk     : in  std_logic; -- 
        rst_n   : in  std_logic   -- activ low (assync?)
    );
end tt_um_example;

architecture Behavioral of tt_um_example is

    component hamenc is 
    port (
        d  : in std_logic_vector(3 downto 0); -- input 4-bit data
        st_in  : in std_logic; -- strobe
        u   : out  std_logic_vector(7 downto 0); -- redundancy encoded data
        st_out  : out std_logic; -- output strobe
        --ena     : in  std_logic; -- ????
        clk     : in  std_logic; -- 
        rst_n   : in  std_logic   -- activ low (assync?)
    );
    end component;

    component uartser is 
    port (
        d  : in std_logic_vector(7 downto 0); -- parallel input
        st : in std_logic;   -- strobe
        u   : out std_logic; -- serial output
        rdy : out std_logic; -- signals ready back
        --ena     : in  std_logic; -- ????
        clk     : in  std_logic; -- 
        rst_n   : in  std_logic  -- activ low (assync?)
    );
    end component;

    component toneenc is 
    port (
        d   : in  std_logic; -- binary input pulsetrain 
        u  : out std_logic; --  output FSK-modulated (binary)
            -- need no st/rdy signals?
        --ena     : in  std_logic; -- ????
        clk     : in  std_logic; -- 
        rst_n   : in  std_logic   -- activ low (assync?)
    );
    end component;


    component tonedec is 
    port (
        d   : in  std_logic; -- input FSK signal (raw binary tone)
        u  : out std_logic;  -- decoded binary pulsetrain
        --ena     : in  std_logic; -- ????
        clk     : in  std_logic; -- 
        rst_n   : in  std_logic  -- activ low (assync?)
    );
    end component;

    component uartpar is 
    port (
        d  : in  std_logic; -- serial input
        u  : out std_logic_vector(7 downto 0); -- parallel output
        st_out  : out std_logic; -- output strobe
        --ena     : in  std_logic; -- ????
        clk     : in  std_logic; -- 
        rst_n   : in  std_logic   -- activ low (assync?)
    );
    end component;

    component hamdec is 
    port (
        d   : in  std_logic_vector(7 downto 0); -- input encoded data
        st_in  : in std_logic; -- strobe
        u  : out std_logic_vector(3 downto 0); -- decoded corrected data
        st_out  : out std_logic; -- output ready
        err  : out  std_logic; -- shows if eHam error occured
        --ena     : in  std_logic; -- ????
        clk     : in  std_logic; -- 
        rst_n   : in  std_logic   -- activ low (assync?)
    );
    end component;

    signal dbus4a, dbus4b : std_logic_vector(3 downto 0);
    signal dbus8a, dbus8b : std_logic_vector(7 downto 0);          -- for hamming 7/4 +1 encoded data
    signal ser1 : std_logic;
    signal st1, st2, st3, st4 : std_logic;
    signal hejsan : std_logic;
    signal hamerr : std_logic;

begin

    -- the first smoke-test:
      --uo_out <= std_logic_vector(unsigned(ui_in) + unsigned(uio_in));
    uo_out <= std_logic_vector(resize(unsigned(dbus4b),4) + unsigned(uio_in));
            uio_out <= "00000000";
            uio_oe <= "00000000";


    dbus4a <= ui_in(3 downto 0);



    HENC : hamenc port map (    d => dbus4a, 
                            st_in => st1,
                                u => dbus8a,
                             st_out => st2,
                                clk => clk,
                              rst_n => rst_n
                            );

    hejsan <= ui_in(0);-- or ui_in(1) or ui_in(2);  -- mock a start pulse for the serial uart

    U_SER : uartser port map ( d => dbus8a, 
                                st => hejsan,
                                u => ser1,
                                rdy => st3,
                                clk => clk,
                              rst_n => rst_n
                            );

    --dbus8b <= dbus8a(7 downto 3) & not dbus8a(2) & dbus8a(1 downto 0);
    dbus8b <= dbus8a xor "00100000";

    HDEC : hamdec port map (
                                d => dbus8b, 
                            st_in => st2,  
                                u => dbus4b,
                            st_out => st3,
                              err => hamerr,
                              clk => clk,
                            rst_n => rst_n 
                            );


end Behavioral; 