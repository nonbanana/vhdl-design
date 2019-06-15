Library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sw_input_adj_long is
port(    CLK        : in std_logic;
        RST        : in std_logic;
        SW_IN    : in std_logic;
        SW_CLR    : out std_logic);
end sw_input_adj_long;

architecture BEHAVE of sw_input_adj_long is
constant LIMIT_10ms : std_logic_vector(18 downto 0) := "1111010000100011111";
constant LIMIT_2s     : std_logic_vector(26 downto 0) := "101111101011110000100000000";
signal sw_in_1d    : std_logic;
signal sw_cnt_2s   : std_logic_vector(26 downto 0);
signal sw_10ms_cnt    : std_logic_vector(18 downto 0);


begin

    process(CLK, RST)
    begin
        if RST = '0' then
            sw_in_1d <= '1';
        elsif CLK = '1' and CLK'event then
            sw_in_1d <= SW_IN;
        end if;
    end process;
    
    process(CLK, RST)
    begin
        if RST = '0' then
            sw_cnt_2s <= (others => '0');
        elsif CLK = '1' and CLK'event then
            if sw_in_1d = '0' then
                if sw_cnt_2s = LIMIT_2s then
                    sw_cnt_2s <= (others => '0');
                else
                    sw_cnt_2s <= sw_cnt_2s + 1;
                end if;
            else
                sw_cnt_2s <= (others => '0');
            end if;
        end if;
    end process;
    
--    SW_CLR <= '0' when sw_cnt_2s = "101" else '1';

    process(CLK, RST)
    begin
        if RST = '0' then
            SW_CLR <= '1';
           sw_10ms_cnt <= LIMIT_10ms;
        elsif CLK = '1' and CLK'event then
            if sw_cnt_2s = LIMIT_2s and sw_10ms_cnt = LIMIT_10ms then
                sw_10ms_cnt <= (others => '0');
                SW_CLR <= '0';
            elsif sw_10ms_cnt = LIMIT_10ms then
                
                SW_CLR <= '1';
            elsif sw_10ms_cnt /= LIMIT_10ms then
                sw_10ms_cnt <= sw_10ms_cnt + '1';
                SW_CLR <= '0';
            
            end if;
        end if;
    end process;

end BEHAVE;