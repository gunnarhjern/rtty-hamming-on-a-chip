library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hamenc is
    port (
        d  : in std_logic_vector(3 downto 0); -- input 4-bit data
        st_in  : in std_logic; -- strobe
        u   : out  std_logic_vector(7 downto 0); -- redundancy encoded data
        st_out  : out std_logic; -- output strobe
        --ena     : in  std_logic; -- ????
        clk     : in  std_logic; -- 
        rst_n   : in  std_logic   -- activ low (assync?)
    );
end hamenc;

architecture Behavioral of hamenc is

begin
     u(3 downto 0) <= d;

end Behavioral;