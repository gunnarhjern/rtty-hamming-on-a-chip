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
    signal st_s_pr, st_s, st_op : std_logic;
    signal d_reg : std_logic_vector(7 downto 0);
begin


--one-pulse the strobe signal
process(clk) begin
    if rising_edge(clk) then 
        st_s <= st;
        st_s_pr <= st_s;
    end if;
end process;
st_op <= st_s and not st_s_pr;


--save the d input on strobe
process(clk)
    if rising_edge(clk) then
        if st_op = '1' then
            d_reg <= d;
        end if;
    end if;
end process;


--start the serializer on strobe


--raise the rdy flag after negative stop bit

end Behavioral;