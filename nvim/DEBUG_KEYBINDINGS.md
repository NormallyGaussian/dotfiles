# C/C++ Debugging in Neovim

## Setup
The debugger uses nvim-dap with codelldb for C/C++ debugging.

## Compilation
Compile your C/C++ programs with debug symbols:
```bash
gcc -g -Wall program.c -o program
# or for C++
g++ -g -Wall program.cpp -o program
```

## Keybindings

### Starting/Stopping Debug Sessions
- `<leader>dc` - Start debugging (Continue) - will prompt for executable path
- `<leader>dt` - Terminate debug session

### Breakpoints
- `<leader>db` - Toggle breakpoint on current line

### Stepping Through Code
- `<leader>dc` - Continue execution until next breakpoint
- `<leader>do` - Step over (execute current line, don't enter functions)
- `<leader>di` - Step into (enter function calls)
- `<leader>dO` - Step out (finish current function and return)

### Inspecting Variables
- `<leader>dh` - Hover over variable to see its value
- Virtual text shows variable values inline as you debug

### Debug UI
- `<leader>du` - Toggle debug UI (shows variables, call stack, breakpoints, etc.)
- `<leader>dr` - Toggle REPL (interactive console)

### Other
- `<leader>dl` - Run last debug configuration

## Workflow Example

1. Compile your program with `-g` flag:
   ```bash
   gcc -g -Wall myprogram.c -o myprogram
   ```

2. Open your C/C++ file in Neovim

3. Set breakpoints:
   - Navigate to lines where you want to pause
   - Press `<leader>db` to toggle breakpoint

4. Start debugging:
   - Press `<leader>dc`
   - Enter the path to your compiled executable (e.g., `./myprogram`)

5. Debug UI will open automatically showing:
   - **Scopes**: Local and global variables
   - **Call Stack**: Function call hierarchy
   - **Breakpoints**: All set breakpoints
   - **Watches**: Custom expressions to monitor
   - **REPL/Console**: Output and interactive commands

6. Step through your code:
   - Use `<leader>do` to step over lines
   - Use `<leader>di` to step into functions
   - Use `<leader>dO` to step out of functions
   - Use `<leader>dc` to continue to next breakpoint

7. Inspect variables:
   - Hover cursor over variable and press `<leader>dh`
   - Check the Scopes panel in the debug UI
   - Variable values appear inline with virtual text

8. When done:
   - Press `<leader>dt` to terminate the debug session
