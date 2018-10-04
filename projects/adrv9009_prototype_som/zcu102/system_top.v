// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module system_top (

  input       [12:0]      gpio_bd_i,
  output      [ 7:0]      gpio_bd_o,

  inout                   iic_scl,
  inout                   iic_sda,

  input                   ref_clk0_p,
  input                   ref_clk0_n,
  input                   ref_clk1_p,
  input                   ref_clk1_n,
  input       [ 3:0]      rx_data_p,
  input       [ 3:0]      rx_data_n,
  output      [ 3:0]      tx_data_p,
  output      [ 3:0]      tx_data_n,
  output                  rx_sync_p,
  output                  rx_sync_n,
  output                  rx_os_sync_p,
  output                  rx_os_sync_n,
  input                   tx_sync_p,
  input                   tx_sync_n,
  input                   sysref_p,
  input                   sysref_n,
  
  input       [ 3:0]      rx_data_b_p,
  input       [ 3:0]      rx_data_b_n,
  output      [ 3:0]      tx_data_b_p,
  output      [ 3:0]      tx_data_b_n,
  output                  rx_sync_b_p,
  output                  rx_sync_b_n,
  output                  rx_os_sync_b_p,
  output                  rx_os_sync_b_n,
  input                   tx_sync_b_p,
  input                   tx_sync_b_n,
  
  output                  spi_csn_ad9528,
  output                  spi_csn_adrv9009,
  output                  spi_csn_adrv9009_b,
  output                  spi_clk,
  output                  spi_mosi,
  input                   spi_miso,

  inout                   ad9528_reset_b,
  inout                   adrv9009_tx1_enable,
  inout                   adrv9009_tx2_enable,
  inout                   adrv9009_rx1_enable,
  inout                   adrv9009_rx2_enable,
  inout                   adrv9009_test,
  inout                   adrv9009_reset_b,
  inout                   adrv9009_gpint,
  inout                   adrv9009_tx1_enable_b,
  inout                   adrv9009_tx2_enable_b,
  inout                   adrv9009_rx1_enable_b,
  inout                   adrv9009_rx2_enable_b,
  inout                   adrv9009_test_b,
  inout                   adrv9009_reset_b_b,
  inout                   adrv9009_gpint_b,

  inout                   adrv9009_gpio_00,
  inout                   adrv9009_gpio_01,
  inout                   adrv9009_gpio_02,
  inout                   adrv9009_gpio_03,
  inout                   adrv9009_gpio_04,
  inout                   adrv9009_gpio_05,
  inout                   adrv9009_gpio_06,
  inout                   adrv9009_gpio_07,
  inout                   adrv9009_gpio_15,
  inout                   adrv9009_gpio_08,
  inout                   adrv9009_gpio_09,
  inout                   adrv9009_gpio_10,
  inout                   adrv9009_gpio_11,
  inout                   adrv9009_gpio_12,
  inout                   adrv9009_gpio_14,
  inout                   adrv9009_gpio_13,
  inout                   adrv9009_gpio_17,
  inout                   adrv9009_gpio_16,
  inout                   adrv9009_gpio_18,

  inout                   adrv9009_gpio_00_b,
  inout                   adrv9009_gpio_01_b,
  inout                   adrv9009_gpio_02_b,
  inout                   adrv9009_gpio_03_b,
  inout                   adrv9009_gpio_04_b,
  inout                   adrv9009_gpio_05_b,
  inout                   adrv9009_gpio_06_b,
  inout                   adrv9009_gpio_07_b,
  inout                   adrv9009_gpio_15_b,
  inout                   adrv9009_gpio_08_b,
  inout                   adrv9009_gpio_09_b,
  inout                   adrv9009_gpio_10_b,
  inout                   adrv9009_gpio_11_b,
  inout                   adrv9009_gpio_12_b,
  inout                   adrv9009_gpio_14_b,
  inout                   adrv9009_gpio_13_b,
  inout                   adrv9009_gpio_17_b,
  inout                   adrv9009_gpio_16_b
);

  // internal signals

  wire        [94:0]      gpio_i;
  wire        [94:0]      gpio_o;
  wire        [94:0]      gpio_t;
  wire        [20:0]      gpio_bd;
  wire        [ 2:0]      spi_csn;
  wire                    ref_clk0;
  wire                    ref_clk1;
  wire                    rx_sync;
  wire                    rx_os_sync;
  wire                    tx_sync_a;
  wire                    tx_sync_b;
  wire                    tx_sync;
  wire                    sysref;

  assign gpio_i[94:83] = gpio_o[94:83];
  assign gpio_i[31:21] = gpio_o[31:21];

  // instantiations

  IBUFDS_GTE4 i_ibufds_rx_ref_clk (
    .CEB (1'd0),
    .I (ref_clk0_p),
    .IB (ref_clk0_n),
    .O (ref_clk0),
    .ODIV2 ());

  IBUFDS_GTE4 i_ibufds_ref_clk1 (
    .CEB (1'd0),
    .I (ref_clk1_p),
    .IB (ref_clk1_n),
    .O (ref_clk1),
    .ODIV2 ());

  OBUFDS i_obufds_rx_sync (
    .I (rx_sync),
    .O (rx_sync_p),
    .OB (rx_sync_n));

  OBUFDS i_obufds_rx_os_sync (
    .I (rx_os_sync),
    .O (rx_os_sync_p),
    .OB (rx_os_sync_n));

  IBUFDS i_ibufds_tx_sync (
    .I (tx_sync_p),
    .IB (tx_sync_n),
    .O (tx_sync_a));

  IBUFDS i_ibufds_sysref (
    .I (sysref_p),
    .IB (sysref_n),
    .O (sysref));

  OBUFDS i_obufds_rx_sync_b (
    .I (rx_sync),
    .O (rx_sync_b_p),
    .OB (rx_sync_b_n));

  OBUFDS i_obufds_rx_os_sync_b (
    .I (rx_os_sync),
    .O (rx_os_sync_b_p),
    .OB (rx_os_sync_b_n));

  IBUFDS i_ibufds_tx_sync_b (
    .I (tx_sync_b_p),
    .IB (tx_sync_b_n),
    .O (tx_sync_b));

  assign tx_sync = tx_sync_a && tx_sync_b;

  ad_iobuf #(.DATA_WIDTH(51)) i_iobuf (
    .dio_t ({gpio_t[82:32]}),
    .dio_i ({gpio_o[82:32]}),
    .dio_o ({gpio_i[82:32]}),
    .dio_p ({ 
              adrv9009_tx1_enable_b,  // 82
              adrv9009_tx2_enable_b,  // 81
              adrv9009_rx1_enable_b,  // 80
              adrv9009_rx2_enable_b,  // 79
              adrv9009_test_b,        // 78
              adrv9009_reset_b_b,     // 77
              adrv9009_gpint_b,       // 76
              adrv9009_gpio_00_b,     // 75
              adrv9009_gpio_01_b,     // 74
              adrv9009_gpio_02_b,     // 73
              adrv9009_gpio_03_b,     // 72
              adrv9009_gpio_04_b,     // 71
              adrv9009_gpio_05_b,     // 70
              adrv9009_gpio_06_b,     // 69
              adrv9009_gpio_07_b,     // 68
              adrv9009_gpio_08_b,     // 67
              adrv9009_gpio_09_b,     // 66
              adrv9009_gpio_10_b,     // 65
              adrv9009_gpio_11_b,     // 64
              adrv9009_gpio_12_b,     // 63
              adrv9009_gpio_13_b,     // 62
              adrv9009_gpio_14_b,     // 61
              adrv9009_gpio_15_b,     // 60
              adrv9009_gpio_16_b,     // 59
              ad9528_reset_b,         // 58
              adrv9009_tx1_enable,    // 57
              adrv9009_tx2_enable,    // 56
              adrv9009_rx1_enable,    // 55
              adrv9009_rx2_enable,    // 54
              adrv9009_test,          // 53
              adrv9009_reset_b,       // 52
              adrv9009_gpint,         // 51
              adrv9009_gpio_00,       // 50
              adrv9009_gpio_01,       // 49
              adrv9009_gpio_02,       // 48
              adrv9009_gpio_03,       // 47
              adrv9009_gpio_04,       // 46
              adrv9009_gpio_05,       // 45
              adrv9009_gpio_06,       // 44
              adrv9009_gpio_07,       // 43
              adrv9009_gpio_08,       // 42
              adrv9009_gpio_09,       // 41
              adrv9009_gpio_10,       // 40
              adrv9009_gpio_11,       // 39
              adrv9009_gpio_12,       // 38
              adrv9009_gpio_13,       // 37
              adrv9009_gpio_14,       // 36
              adrv9009_gpio_15,       // 35
              adrv9009_gpio_16,       // 34
              adrv9009_gpio_17,       // 33
              adrv9009_gpio_18}));    // 32

  ad_iobuf #(.DATA_WIDTH(21)) i_iobuf_bd (
    .dio_t (gpio_t[20:0]),
    .dio_i (gpio_o[20:0]),
    .dio_o (gpio_i[20:0]),
    .dio_p (gpio_bd));

  assign gpio_bd_i = gpio_bd[20:8];
  assign gpio_bd_o = gpio_bd[ 7:0];

  assign spi_csn_ad9528 =  spi_csn[0];
  assign spi_csn_adrv9009 =  spi_csn[1];
  assign spi_csn_adrv9009_b =  spi_csn[2];

  system_wrapper i_system_wrapper (
    .dac_fifo_bypass (gpio_o[83]),
    .gpio_i (gpio_i),
    .gpio_o (gpio_o),
    .gpio_t (gpio_t),
    .rx_data_0_n (rx_data_n[0]),
    .rx_data_0_p (rx_data_p[0]),
    .rx_data_1_n (rx_data_n[1]),
    .rx_data_1_p (rx_data_p[1]),
    .rx_data_2_n (rx_data_n[2]),
    .rx_data_2_p (rx_data_p[2]),
    .rx_data_3_n (rx_data_n[3]),
    .rx_data_3_p (rx_data_p[3]),
    .rx_data_4_n (rx_data_b_n[0]),
    .rx_data_4_p (rx_data_b_p[0]),
    .rx_data_5_n (rx_data_b_n[1]),
    .rx_data_5_p (rx_data_b_p[1]),
    .rx_data_6_n (rx_data_b_n[2]),
    .rx_data_6_p (rx_data_b_p[2]),
    .rx_data_7_n (rx_data_b_n[3]),
    .rx_data_7_p (rx_data_b_p[3]),
    .rx_ref_clk_0 (ref_clk1),
    .rx_ref_clk_2 (ref_clk1),
    .rx_sync_0 (rx_sync),
    .rx_sync_4 (rx_os_sync),
    .rx_sysref_0 (sysref),
    .rx_sysref_4 (sysref),
    .spi0_sclk (spi_clk),
    .spi0_csn (spi_csn),
    .spi0_miso (spi_miso),
    .spi0_mosi (spi_mosi),
    .spi1_sclk (),
    .spi1_csn (),
    .spi1_miso (1'b0),
    .spi1_mosi (),
    .tx_data_0_n (tx_data_n[0]),
    .tx_data_0_p (tx_data_p[0]),
    .tx_data_1_n (tx_data_n[1]),
    .tx_data_1_p (tx_data_p[1]),
    .tx_data_2_n (tx_data_n[2]),
    .tx_data_2_p (tx_data_p[2]),
    .tx_data_3_n (tx_data_n[3]),
    .tx_data_3_p (tx_data_p[3]),
    .tx_data_4_n (tx_data_b_n[0]),
    .tx_data_4_p (tx_data_b_p[0]),
    .tx_data_5_n (tx_data_b_n[1]),
    .tx_data_5_p (tx_data_b_p[1]),
    .tx_data_6_n (tx_data_b_n[2]),
    .tx_data_6_p (tx_data_b_p[2]),
    .tx_data_7_n (tx_data_b_n[3]),
    .tx_data_7_p (tx_data_b_p[3]),
    .tx_ref_clk_0 (ref_clk1),
    .tx_sync_0 (tx_sync),
    .tx_sysref_0 (sysref)
  );

endmodule

// ***************************************************************************
// ***************************************************************************
