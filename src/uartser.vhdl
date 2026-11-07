library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uartser is
    port (
        d  : in std_logic_vector(7 downto 0); -- parallel input
        st : in std_logic;   -- strobe
        u   : out std_logic; -- serial output
        rdy : out std_logic; -- signals ready back
        --ena     : in  std_logic; -- ????
        clk     : in  std_logic; -- 
        rst_n   : in  std_logic  -- activ low (assync?)
    );
end uartser;

architecture Behavioral of uartser is
begin


end Behavioral;