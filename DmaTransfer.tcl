#
# Vivado (TM) v2019.2 (64-bit)
#
# DmaTransfer.tcl: Tcl script for re-creating project 'DmaTransfer'
#
# IP Build 2700528 on Thu Nov  7 00:09:20 MST 2019
#
# This file contains the Vivado Tcl commands for re-creating the project to the state*
# when this script was generated. In order to re-create the project, please source this
# file in the Vivado Tcl Shell.
#
# * Note that the runs in the created project will be configured the same way as the
#   original project, however they will not be launched automatically. To regenerate the
#   run results please launch the synthesis/implementation runs as needed.
#
#*****************************************************************************************
# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir [file dirname [info script]]

# Change current directory to project folder
cd [file dirname [info script]]

# Save old sources
file delete -force DmaTransfer.srcs.backup
file rename DmaTransfer.srcs DmaTransfer.srcs.backup

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

variable script_file
set script_file "DmaTransfer.tcl"

# Help information for this script
proc help {} {
  variable script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < [llength $::argc]} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir" { incr i; set origin_dir [lindex $::argv $i] }
      "--help"       { help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/"]"

# Create project
create_project DmaTransfer . -part xc7z010clg400-1 -force
# Restore old sources
file delete -force DmaTransfer.srcs
file rename DmaTransfer.srcs.backup DmaTransfer.srcs

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Reconstruct message rules
# None

# Set project properties
set obj [get_projects DmaTransfer]
set_property "default_lib" "xil_defaultlib" $obj
set_property "enable_vhdl_2008" "1" $obj
set_property "ip_cache_permissions" "read write" $obj
set_property "mem.enable_memory_map_generation" "1" $obj
set_property "part" "xc7z010clg400-1" $obj
set_property "sim.central_dir" "D:/Development/FPGA/DmaTransfer/DmaTransfer.ip_user_files" $obj
set_property "sim.ip.auto_export_scripts" "1" $obj
set_property "simulator_language" "Mixed" $obj
set_property "target_language" "VHDL" $obj
set_property "webtalk.activehdl_export_sim" "1" $obj
set_property "webtalk.ies_export_sim" "1" $obj
set_property "webtalk.modelsim_export_sim" "1" $obj
set_property "webtalk.questa_export_sim" "1" $obj
set_property "webtalk.riviera_export_sim" "1" $obj
set_property "webtalk.vcs_export_sim" "1" $obj
set_property "webtalk.xsim_export_sim" "1" $obj
set_property "xpm_libraries" "XPM_CDC XPM_FIFO XPM_MEMORY" $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 "[file normalize "$origin_dir/DmaTransfer.srcs/sources_1/bd/ProcessingSystem/ProcessingSystem.bd"]"\
 "[file normalize "$origin_dir/DmaTransfer.srcs/sources_1/hdl/DmaTransfer.vhd"]"\
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
# None

# Set 'sources_1' fileset file properties for local files
set file "ProcessingSystem/ProcessingSystem.bd"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "registered_with_manager" "1" $file_obj
if { ![get_property "is_locked" $file_obj] } {
  set_property "synth_checkpoint_mode" "Hierarchical" $file_obj
}

set file "hdl/DmaTransfer.vhd"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "file_type" "VHDL" $file_obj


# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property "top" "DmaTransfer" $obj

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 "[file normalize "$origin_dir/DmaTransfer.srcs/sources_1/ip/SyncFifoBram37x1024/SyncFifoBram37x1024.xci"]"\
]
add_files -norecurse -fileset $obj $files

# Set 'sources_1' fileset file properties for remote files
# None

# Set 'sources_1' fileset file properties for local files
set file "SyncFifoBram37x1024/SyncFifoBram37x1024.xci"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property "generate_files_for_reference" "0" $file_obj
set_property "registered_with_manager" "1" $file_obj
if { ![get_property "is_locked" $file_obj] } {
  set_property "synth_checkpoint_mode" "Singular" $file_obj
}


# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Empty (no sources present)

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]
set_property "target_part" "xc7z010clg400-1" $obj

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
# Empty (no sources present)

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property "top" "DmaTransfer" $obj
set_property "top_lib" "xil_defaultlib" $obj
set_property "xelab.nosort" "1" $obj
set_property "xelab.unifast" "" $obj

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
  create_run -name synth_1 -part xc7z010clg400-1 -flow {Vivado Synthesis 2019} -strategy "Vivado Synthesis Defaults" -constrset constrs_1
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2019" [get_runs synth_1]
}
set obj [get_runs synth_1]
set_property "part" "xc7z010clg400-1" $obj
set_property "report_strategy" "Vivado Synthesis Default Reports" $obj
set_property "strategy" "Vivado Synthesis Defaults" $obj
set_property "steps.synth_design.reports" "synth_1_synth_report_utilization_0 synth_1_synth_synthesis_report_0" $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
  create_run -name impl_1 -part xc7z010clg400-1 -flow {Vivado Implementation 2019} -strategy "Vivado Implementation Defaults" -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
  set_property flow "Vivado Implementation 2019" [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property "part" "xc7z010clg400-1" $obj
set_property "report_strategy" "Vivado Implementation Default Reports" $obj
set_property "strategy" "Vivado Implementation Defaults" $obj
set_property "steps.init_design.reports" "impl_1_init_report_timing_summary_0" $obj
set_property "steps.opt_design.reports" "impl_1_opt_report_drc_0 impl_1_opt_report_timing_summary_0" $obj
set_property "steps.power_opt_design.reports" "impl_1_power_opt_report_timing_summary_0" $obj
set_property "steps.place_design.reports" "impl_1_place_report_io_0 impl_1_place_report_utilization_0 impl_1_place_report_control_sets_0 impl_1_place_report_incremental_reuse_0 impl_1_place_report_incremental_reuse_1 impl_1_place_report_timing_summary_0" $obj
set_property "steps.post_place_power_opt_design.reports" "impl_1_post_place_power_opt_report_timing_summary_0" $obj
set_property "steps.phys_opt_design.is_enabled" "1" $obj
set_property "steps.phys_opt_design.reports" "impl_1_phys_opt_report_timing_summary_0" $obj
set_property "steps.route_design.reports" "impl_1_route_report_drc_0 impl_1_route_report_methodology_0 impl_1_route_report_power_0 impl_1_route_report_route_status_0 impl_1_route_report_timing_summary_0 impl_1_route_report_incremental_reuse_0 impl_1_route_report_clock_utilization_0 impl_1_route_report_bus_skew_0 impl_1_route_implementation_log_0" $obj
set_property "steps.post_route_phys_opt_design.reports" "impl_1_post_route_phys_opt_report_timing_summary_0 impl_1_post_route_phys_opt_report_bus_skew_0" $obj
set_property "steps.write_bitstream.reports" "impl_1_bitstream_report_webtalk_0 impl_1_bitstream_implementation_log_0" $obj
set_property "steps.write_bitstream.args.readback_file" "0" $obj
set_property "steps.write_bitstream.args.verbose" "0" $obj

# set the current impl run
current_run -implementation [get_runs impl_1]

puts "INFO: Project created:DmaTransfer"
