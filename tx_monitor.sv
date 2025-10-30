task monitor_transaction();
    htax_tx_mon_packet_c mon_pkt;
    int dest_port_num;
    
    mon_pkt = htax_tx_mon_packet_c::type_id::create("mon_pkt");
    
    // TODO 1: Wait for SOT to be asserted (any bit high)
    @(posedge htax_tx_intf.clk);
    wait(|htax_tx_intf.tx_sot);
    
    // TODO 2: Convert one-hot tx_outport_req to port number
    // Hint: Use a for loop or case statement
    for(int i = 0; i < `NUM_PORTS; i++) begin
        if(htax_tx_intf.tx_outport_req[i]) begin
            dest_port_num = i;
            break;
        end
    end
    mon_pkt.dest_port = dest_port_num;
    
    // TODO 3: Capture first data when SOT is high
    mon_pkt.data = new[1];
    mon_pkt.data[0] = htax_tx_intf.tx_data;
    
    @(posedge htax_tx_intf.clk);
    
    // TODO 4: Continue capturing data until EOT
    // Hint: Use a while loop checking for EOT
    while(!htax_tx_intf.tx_eot) begin
        // Dynamically grow the data array
        mon_pkt.data = new[mon_pkt.data.size() + 1](mon_pkt.data);
        mon_pkt.data[mon_pkt.data.size() - 1] = htax_tx_intf.tx_data;
        @(posedge htax_tx_intf.clk);
    end
    
    // TODO 5: Capture the last data beat (when EOT is high)
    mon_pkt.data = new[mon_pkt.data.size() + 1](mon_pkt.data);
    mon_pkt.data[mon_pkt.data.size() - 1] = htax_tx_intf.tx_data;
    
    // TODO 6: Display captured packet information
    `uvm_info("TX_MON", $sformatf("Captured packet: dest=%0d, length=%0d", 
              mon_pkt.dest_port, mon_pkt.data.size()), UVM_MEDIUM)
              
endtask


