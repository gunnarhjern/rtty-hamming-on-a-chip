library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hamdec is
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
end hamdec;

architecture Behavioral of hamdec is
begin
    u <= d(3 downto 0);

end Behavioral;