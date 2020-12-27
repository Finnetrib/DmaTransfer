----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 16.12.2020 11:18:38
-- Design Name:
-- Module Name: DmaTransfer - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DmaTransfer is
	port	(	DDR_addr			: inout std_logic_vector(14 downto 0);
				DDR_ba				: inout std_logic_vector( 2 downto 0);
				DDR_cas_n			: inout std_logic;
				DDR_ck_n			: inout std_logic;
				DDR_ck_p			: inout std_logic;
				DDR_cke				: inout std_logic;
				DDR_cs_n			: inout std_logic;
				DDR_dm				: inout std_logic_vector( 3 downto 0);
				DDR_dq				: inout std_logic_vector(31 downto 0);
				DDR_dqs_n			: inout std_logic_vector( 3 downto 0);
				DDR_dqs_p			: inout std_logic_vector( 3 downto 0);
				DDR_odt				: inout std_logic;
				DDR_ras_n			: inout std_logic;
				DDR_reset_n			: inout std_logic;
				DDR_we_n			: inout std_logic;
				FIXED_IO_ddr_vrn	: inout std_logic;
				FIXED_IO_ddr_vrp	: inout std_logic;
				FIXED_IO_mio		: inout std_logic_vector(53 downto 0);
				FIXED_IO_ps_clk		: inout std_logic;
				FIXED_IO_ps_porb	: inout std_logic;
				FIXED_IO_ps_srstb	: inout std_logic );
end DmaTransfer;

architecture Behavioral of DmaTransfer is

	signal	RxData			: std_logic_vector(31 downto 0);
	signal	RxKeep			: std_logic_vector( 3 downto 0);
	signal	RxLast			: std_logic;
	signal	RxValid			: std_logic;
	signal	RxReady			: std_logic;
	signal	TxData			: std_logic_vector(31 downto 0);
	signal	TxKeep			: std_logic_vector( 3 downto 0);
	signal	TxLast			: std_logic;
	signal	TxValid			: std_logic;
	signal	TxReady			: std_logic;
	signal	clk				: std_logic;
	signal	rst				: std_logic;
	signal	FifoDataW		: std_logic_vector(36 downto 0);
	signal	FifoWrite		: std_logic;
	signal	FifoRead		: std_logic;
	signal	FifoDataR		: std_logic_vector(36 downto 0);
	signal	FifoEmpty		: std_logic;
	signal	FifoFull		: std_logic;

begin

	PS : entity WORK.ProcessingSystem
	port map	(	DDR_addr			=> DDR_addr,
					DDR_ba				=> DDR_ba,
					DDR_cas_n			=> DDR_cas_n,
					DDR_ck_n			=> DDR_ck_n,
					DDR_ck_p			=> DDR_ck_p,
					DDR_cke				=> DDR_cke,
					DDR_cs_n			=> DDR_cs_n,
					DDR_dm				=> DDR_dm,
					DDR_dq				=> DDR_dq,
					DDR_dqs_n			=> DDR_dqs_n,
					DDR_dqs_p			=> DDR_dqs_p,
					DDR_odt				=> DDR_odt,
					DDR_ras_n			=> DDR_ras_n,
					DDR_reset_n			=> DDR_reset_n,
					DDR_we_n			=> DDR_we_n,
					FIXED_IO_ddr_vrn	=> FIXED_IO_ddr_vrn,
					FIXED_IO_ddr_vrp	=> FIXED_IO_ddr_vrp,
					FIXED_IO_mio		=> FIXED_IO_mio,
					FIXED_IO_ps_clk		=> FIXED_IO_ps_clk,
					FIXED_IO_ps_porb	=> FIXED_IO_ps_porb,
					FIXED_IO_ps_srstb	=> FIXED_IO_ps_srstb,
					-- Dma Channel
					iDmaRx_tdata		=> RxData,
					iDmaRx_tkeep		=> RxKeep,
					iDmaRx_tlast		=> RxLast,
					iDmaRx_tready		=> RxReady,
					iDmaRx_tvalid		=> RxValid,
					oDmaTx_tdata		=> TxData,
					oDmaTx_tkeep		=> TxKeep,
					oDmaTx_tlast		=> TxLast,
					oDmaTx_tready		=> TxReady,
					oDmaTx_tvalid		=> TxValid,
					-- System
					oZynqClk			=> clk,
					oZynqRst(0)			=> rst );
	
	FifoDataW(31 downto  0) <= not TxData;
	FifoDataW(35 downto 32) <= TxKeep;
	FifoDataW(			36) <= TxLast;
	
	FifoWrite <= TxValid and not FifoFull;
	
	TxReady <= not FifoFull;
	
	EchFifo : entity WORK.SyncFifoBram37x1024
	port map	(	clk			=> clk,
					srst		=> rst,
					din			=> FifoDataW,
					wr_en		=> FifoWrite,
					rd_en		=> FifoRead,
					dout		=> FifoDataR,
					full		=> open,
					empty		=> FifoEmpty,
					prog_full	=> FifoFull );

	RxData <= FifoDataR(31 downto  0);
	RxKeep <= FifoDataR(35 downto 32);
	RxLast <= FifoDataR(36);
	
	RxValid <= not FifoEmpty;
	
	FifoRead <= RxReady;


end Behavioral;