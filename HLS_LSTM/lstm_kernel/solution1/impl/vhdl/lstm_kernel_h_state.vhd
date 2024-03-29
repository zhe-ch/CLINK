-- ==============================================================
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2019.1 (64-bit)
-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lstm_kernel_h_state is
    generic (
        DataWidth    : integer := 16;
        AddressWidth : integer := 5;
        AddressRange : integer := 20
    );
    port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        address0 : in  std_logic_vector(AddressWidth-1 downto 0);
        ce0      : in  std_logic;
        we0      : in  std_logic;
        d0       : in  std_logic_vector(DataWidth-1 downto 0);
        q0       : out std_logic_vector(DataWidth-1 downto 0);
        address1 : in  std_logic_vector(AddressWidth-1 downto 0);
        ce1      : in  std_logic;
        we1      : in  std_logic;
        d1       : in  std_logic_vector(DataWidth-1 downto 0);
        q1       : out std_logic_vector(DataWidth-1 downto 0)
    );
end entity;

architecture arch of lstm_kernel_h_state is
    --------------------- Component ---------------------
    component lstm_kernel_h_state_ram is
        port (
            clk   : in  std_logic;
            ce0   : in  std_logic;
            addr0 : in  std_logic_vector(AddressWidth-1 downto 0);
            we0   : in  std_logic;
            d0    : in  std_logic_vector(DataWidth-1 downto 0);
            q0    : out std_logic_vector(DataWidth-1 downto 0);
            ce1   : in  std_logic;
            addr1 : in  std_logic_vector(AddressWidth-1 downto 0);
            we1   : in  std_logic;
            d1    : in  std_logic_vector(DataWidth-1 downto 0);
            q1    : out std_logic_vector(DataWidth-1 downto 0)
        );
    end component;
    --------------------- Local signal ------------------
    signal written : std_logic_vector(AddressRange-1 downto 0) := (others => '0');
    signal q0_ram  : std_logic_vector(DataWidth-1 downto 0);
    signal q0_rom  : std_logic_vector(DataWidth-1 downto 0);
    signal q0_sel  : std_logic;
    signal sel0_sr : std_logic_vector(0 downto 0);
    signal q1_ram  : std_logic_vector(DataWidth-1 downto 0);
    signal q1_rom  : std_logic_vector(DataWidth-1 downto 0);
    signal q1_sel  : std_logic;
    signal sel1_sr : std_logic_vector(0 downto 0);
begin
    --------------------- Instantiation -----------------
    lstm_kernel_h_state_ram_u : component lstm_kernel_h_state_ram
    port map (
        clk   => clk,
        ce0   => ce0,
        addr0 => address0,
        we0   => we0,
        d0    => d0,
        q0    => q0_ram,
        ce1   => ce1,
        addr1 => address1,
        we1   => we1,
        d1    => d1,
        q1    => q1_ram
    );
    --------------------- Assignment --------------------
    q0     <= q0_ram when q0_sel = '1' else q0_rom;
    q0_sel <= sel0_sr(0);
    q0_rom <= "0000000000000000";
    q1     <= q1_ram when q1_sel = '1' else q1_rom;
    q1_sel <= sel1_sr(0);
    q1_rom <= "0000000000000000";

    process (clk) begin
        if clk'event and clk = '1' then
            if reset = '1' then
                written <= (others => '0');
            else
                if ce0 = '1' and we0 = '1' then
                    written(to_integer(unsigned(address0))) <= '1';
                end if;
                if ce1 = '1' and we1 = '1' then
                    written(to_integer(unsigned(address1))) <= '1';
                end if;
            end if;
        end if;
    end process;

    process (clk) begin
        if clk'event and clk = '1' then
            if ce0 = '1' then
                sel0_sr(0) <= written(to_integer(unsigned(address0)));
            end if;
            if ce1 = '1' then
                sel1_sr(0) <= written(to_integer(unsigned(address1)));
            end if;
        end if;
    end process;

end architecture;
