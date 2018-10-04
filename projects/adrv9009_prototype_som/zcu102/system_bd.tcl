
set dac_fifo_name axi_adrv9009_dacfifo
set dac_fifo_address_width 10
set dac_data_width 256
set dac_dma_data_width 256

source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl

ad_ip_parameter sys_ps8 CONFIG.PSU__FPGA_PL2_ENABLE 1
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL2_REF_CTRL__SRCSEL {IOPLL}
ad_ip_parameter sys_ps8 CONFIG.PSU__CRL_APB__PL2_REF_CTRL__FREQMHZ 200

source ../common/adrv9009_p_som_bd.tcl

ad_connect sys_dma_clk sys_ps8/pl_clk2
ad_connect sys_dma_rstgen/ext_reset_in sys_rstgen/peripheral_reset

ad_ip_parameter axi_adrv9009_tx_xcvr CONFIG.XCVR_TYPE 2
ad_ip_parameter axi_adrv9009_rx_xcvr CONFIG.XCVR_TYPE 2
ad_ip_parameter axi_adrv9009_rx_os_xcvr CONFIG.XCVR_TYPE 2
ad_ip_parameter axi_adrv9009_b_tx_xcvr CONFIG.XCVR_TYPE 2
ad_ip_parameter axi_adrv9009_b_rx_xcvr CONFIG.XCVR_TYPE 2
ad_ip_parameter axi_adrv9009_b_rx_os_xcvr CONFIG.XCVR_TYPE 2

ad_ip_parameter util_adrv9009_p_som_xcvr CONFIG.XCVR_TYPE 2
ad_ip_parameter util_adrv9009_p_som_xcvr CONFIG.QPLL_FBDIV 80
ad_ip_parameter util_adrv9009_p_som_xcvr CONFIG.QPLL_REFCLK_DIV 1

ad_ip_parameter axi_adrv9009_rx_clkgen CONFIG.DEVICE_TYPE 2
ad_ip_parameter axi_adrv9009_tx_clkgen CONFIG.DEVICE_TYPE 2

