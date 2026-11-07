library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity toneenc is
    port (
        d   : in  std_logic; -- binary input pulsetrain 
        u  : out std_logic; --  output FSK-modulated (binary)
            -- need no st/rdy signals?
        --ena     : in  std_logic; -- ????
        clk     : in  std_logic; -- 
        rst_n   : in  std_logic   -- activ low (assync?)
    );
end toneenc;

architecture Behavioral of toneenc is
begin


end Behavioral;