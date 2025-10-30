// Buggy code - find and fix 3 errors
task buggy_driver(htax_packet_c pkt);
    htax_tx_intf.tx_outport_req = pkt.dest_port;  // BUG 1
    htax_tx_intf.tx_vc_req = pkt.vc;
    
    @(posedge htax_tx_intf.clk);
    
    htax_tx_intf.tx_sot = htax_tx_intf.tx_vc_gnt;  // BUG 2
    htax_tx_intf.tx_data = pkt.data[0];
    htax_tx_intf.tx_outport_req = '0;
    htax_tx_intf.tx_vc_req = '0;
    
    @(posedge htax_tx_intf.clk);
    
    for(int i = 1; i < pkt.data.size(); i++) begin
        htax_tx_intf.tx_data = pkt.data[i];
        if(i == pkt.data.size() - 1)
            htax_tx_intf.tx_eot = 1;  // BUG 3
        @(posedge htax_tx_intf.clk);
    end
endtask
