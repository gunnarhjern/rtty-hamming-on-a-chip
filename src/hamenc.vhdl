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
    signal hami, hamo : std_logic_vector(7 downto 0);
begin
    
    -- just a mocked function for testing
    -- u(3 downto 0) <= d;
    
    -- convenient to use an internal signal    
    hami(3) <= d(0);
    hami(5) <= d(1);
    hami(6) <= d(2);
    hami(7) <= d(3);
    
    -- normal hamming
    hamo(1) <= hami(3) xor hami(5) xor hami(7);
    hamo(2) <= hami(3) xor hami(6) xor hami(7);
    hamo(4) <= hami(5) xor hami(6) xor hami(7);
    hamo(3) <= hami(3);
    hamo(5) <= hami(5);
    hamo(6) <= hami(6);
    hamo(7) <= hami(7);


    hamo(0) <= '0'; --lets take the extended Hamming later...


    process(clk) begin
        if rising_edge(clk) then
            st_out <= st_in; --critical path is short - no need to use mult registers
        end if;
    end process;

    u <= hamo;

end Behavioral;