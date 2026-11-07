library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uartpar is
    port (
        d  : in  std_logic; -- serial input
        u  : out std_logic_vector(7 downto 0); -- parallel output
        st_out  : out std_logic; -- output strobe
        --ena     : in  std_logic; -- ????
        clk     : in  std_logic; -- 
        rst_n   : in  std_logic   -- activ low (assync?)
    );
end uartpar;

architecture Behavioral of uartpar is
begin


end Behavioral;