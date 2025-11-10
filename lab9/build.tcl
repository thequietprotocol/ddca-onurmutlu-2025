set project_name "mipsUp_final"
set top_module_name "top"

create_project $project_name ./lab_vivado -part xc7a35tcpg236-1 -force

add_files [glob ./src/*.v]
# For initialization files
add_files [glob ./src/*.txt]

add_files -fileset constrs_1 [glob ./constraints/*.xdc]

set_property top $top_module_name [current_fileset]

reset_run synth_1

launch_runs synth_1 -jobs 8

wait_on_run synth_1

if {[get_property PROGRESS [get_runs synth_1]] != "100%"} {
  error "ERROR: Synthesis failed!"
}

reset_run impl_1

launch_runs impl_1 -to_step write_bitstream -jobs 8

wait_on_run impl_1

if {[get_property PROGRESS [get_runs impl_1]] != "100%"} {
  error "ERROR: Implementation failed!"
}

puts "Bitstream generated successfully!"

#open_hw_manager

#connect_hw_server

#open_hw_target

#current_hw_device [lindex [get_hw_devices] 0]

#set_property PROGRAM.FILE "./lab_vivado/$project_name.runs/impl_1/$top_module_name.bit" [current_hw_device]

#program_hw_devices [current_hw_device]

#close_hw_target

#close_hw_manager

