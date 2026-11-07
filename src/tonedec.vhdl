library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tonedec is
    port (
        d   : in  std_logic; -- input FSK signal (raw binary tone)
        u  : out std_logic;  -- decoded binary pulsetrain
        --ena     : in  std_logic; -- ????
        clk     : in  std_logic; -- 
        rst_n   : in  std_logic  -- activ low (assync?)
    );
end tonedec;

architecture Behavioral of tonedec is
begin


end Behavioral;