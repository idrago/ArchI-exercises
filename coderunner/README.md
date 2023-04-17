
_start: code that fires the automatic correction
    - stdin receices the test case

available macros:
    - start_saved_registers_nonleaf
        puts numbers on temp/saved registers to check calling conventions
    - check_saved_registers
        check whether the saved registers have been preserved
    - exit_required_nonleaf_function
        update the global flag (True/False) that indicates a required
        non-leaf function has been called

    - printreg a0, __ra0
        print the string: "a0: <DWORD in a0>"



Folder backup: The file is missing the attachment (support.S)
