set_global_assignment -entity "PLL_GenClocks" -library "lib_PLL_GenClocks" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "PLL_GenClocks" -library "lib_PLL_GenClocks" -name IP_TOOL_VERSION "17.0"
set_global_assignment -entity "PLL_GenClocks" -library "lib_PLL_GenClocks" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_PLL_GenClocks" -name SPD_FILE [file join $::quartus(sip_path) "PLL_GenClocks.spd"]

set_global_assignment -library "lib_PLL_GenClocks" -name MISC_FILE [file join $::quartus(sip_path) "PLL_GenClocks_sim/PLL_GenClocks.vo"]
