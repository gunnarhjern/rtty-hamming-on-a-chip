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
    signal hami, hamo, oct : std_logic_vector(7 downto 0);
    signal bin : std_logic_vector(2 downto 0);
begin


    --just a mocked function for test
    --u <= d(3 downto 0);

    -- 1
    bin(0) <= d(1) xor d(3) xor d(5) xor d(7);
    -- 2
    bin(1) <= d(2) xor d(3) xor d(6) xor d(7);
    -- 4
    bin(2) <= d(4) xor d(5) xor d(6) xor d(7);

    -- binary to octal decoder:
    with bin select 
              -- 76543210
        oct <=  "00000010" when "001",
                "00000100" when "010",
                "00001000" when "011",
                "00010000" when "100",
                "00100000" when "101",
                "01000000" when "110",
                "10000000" when "111",
                "00000000" when others;
    --corrector:
    hamo(7 downto 1) <= d(7 downto 1) xor oct(7 downto 1);

    -- let's wait with the extended Hamming
    hamo(0) <= '0';

    --process(clk) begin
      --  if rising_edge(clk) then
            st_out <= st_in; --critical path is short - no need to use mult registers
        --end if;
    --end process;
    u <= hamo(3 downto 0);
    

end Behavioral;