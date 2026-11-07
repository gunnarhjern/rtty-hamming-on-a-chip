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
    signal fuse : std_logic;
    signal rdyi : std_logic;
    -- signal timerCnt : unsigned(15 downto 0);
    signal start, timer, trigTimer : std_logic;
    signal Tcnt : unsigned(15 downto 0); -- we'll use msb to a special use, must be 0 after 
    signal timingConst : unsigned(15 downto 0) := to_unsigned(17,16);
    signal sCnt : unsigned(3 downto 0);
begin


--one-pulse the strobe signal
process(clk) begin
    if rising_edge(clk) then 
        st_s <= st;
        st_s_pr <= st_s;
    end if;
end process;
start <= st_s and not st_s_pr;


--save the d input and lit the fuse on strobe
-- fuse is used to keep the sending automon alive until sending is done
process(clk) begin
    if rising_edge(clk) then
        if st_op = '1' then
            d_reg <= d;
            fuse <= '1';
        elsif rdy = '1' then
            fuse <= '0';
        end if;
    end if;
end process;

--signal startTimer : std_logic;
-- signal Tcnt : unsigned(15 downto 0); -- we'll use msb to a special use, must be 0 after 
-- signal timingConst : unsigned(15 downto 0);
  process(clk) begin
    if rising_edge(clk) then
        if startTimer = '1' or timerRunning = '1' then
            Tcnt <= Tcnt - 1;
        else
            Tcnt <= timingConst;
        end if;
     end if;
  end process;




--start the serializer on strobe
process(clk) begin
    if rising_edge(clk) then 
        if fuse = '1' then
            
            -- if metronom tick
            if startTimer = '0' then-- timerRunning = '0' then
                startTimer <= '1'; --trig the timer
                sCnt <= sCnt + 1;
            elsif timerRunning = '0' then
                startTimer 
            end if;


        else
            sCnt <= (others => '1'); 
        end if;
    end if;
end process;




--raise the rdy flag after negative stop bit

end Behavioral;