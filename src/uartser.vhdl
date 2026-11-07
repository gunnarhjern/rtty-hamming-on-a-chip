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
    signal st_s_pr, st_s : std_logic;
    signal d_reg : std_logic_vector(7 downto 0);
    --signal rdyi : std_logic;
    -- signal timerCnt : unsigned(15 downto 0);
    signal start, timer, trigTimer, sending : std_logic;
    signal Tcnt : unsigned(15 downto 0); -- we'll use msb to a special use, must be 0 after 
    signal timingConst : unsigned(15 downto 0) := to_unsigned(5,16);
    signal sCnt : unsigned(3 downto 0);
    constant maxBit : unsigned(3 downto 0) := to_unsigned(7, 4);
begin


--one-pulse the strobe signal
process(clk) begin
    if rising_edge(clk) then 
        st_s <= st;
        st_s_pr <= st_s;
    end if;
end process;
start <= (st_s and not st_s_pr) and not sending;


process(clk) begin
    if rst_n = '0' then
        timer <= '0';
        tCnt <= (others => '0');
    elsif rising_edge(clk) then
        if sending = '1' then
            if trigTimer = '1' then
                tCnt <= timingConst;
                timer <= '0';
            elsif timer = '1' then
                timer <= '0';
            elsif tCnt = 0 then
                timer <= '1';
            else
                tCnt <= tCnt - 1;
            end if;
        end if;
    end if;
end process;




-- trig the timer on start (one-pulser)
--  or when the timer rings
-- increase the s-count whenever timer rings
process(clk)
begin
    if rst_n = '0' then
        trigTimer <= '0';
        sCnt <= "1111";
    elsif rising_edge(clk) then
        -- must include start here too: trigs timer the first time
        if start = '1' or sending = '1' then
            if start = '1' then
                trigTimer <= '1';
                sCnt <= "1111";
            elsif trigTimer = '1' then
                trigTimer <= '0';
            elsif timer = '1' then
                if sCnt = maxBit then
                    sCnt <= "1111";
                else
                    sCnt <= sCnt + 1;
                    trigTimer <= '1';
                end if;
            else --timer becomes one-pulser here: 
                trigTimer <= '0';
            end if;
        end if;
    end if;
end process;

-- register the data and start the sending
-- stop sending when maxBit reached
process(clk) 
begin
    if rst_n = '0' then
        sending <= '0';
    elsif rising_edge(clk) then
        if start = '1' then
            sending <= '1';
            d_reg <= d;
        elsif sCnt = maxBit then
            sending <= '0';
        end if;
    end if;
end process;

-- key the serial output
u <= '1' when sending = '1' and sCnt = "1111" else --send startbit
     '0' when sCnt >= maxBit else
     d_reg(to_integer(sCnt)) when sending = '1' else
     '0';

--raise the rdy flag after negative stop bit
-- TODO: might have to include   or (not timer)  too
rdy <= not (sending or start or st);


end Behavioral;