@echo off
setlocal enabledelayedexpansion enableextensions

set "MY_TMP=%TEMP%\bin"
if defined TMP set "MY_TMP=%TMP%\bin"

call "%~dp0bin.bat" || (echo ERROR: "%~dp0bin.bat" failed>&2& exit /b 1)

echo on

rem     typedef struct _IMAGE_DOS_HEADER {     // DOS .EXE header
rem 00:     WORD   e_magic;                    // Magic number
set "output_buffer=4D 5A" & rem IMAGE_DOS_SIGNATURE = 4D 5A  // MZ
rem 02:     WORD   e_cblp;                     // Bytes on last page of file
set "output_buffer=%output_buffer% 00 00"
rem 04:    WORD   e_cp;                        // Pages in file
set "output_buffer=%output_buffer% 00 00"
rem 06:    WORD   e_crlc;                      // Relocations
set "output_buffer=%output_buffer% 00 00"
rem 08:    WORD   e_cparhdr;                   // Size of header in paragraphs
set "output_buffer=%output_buffer% 04 00" & rem 4 (0x40 bytes)
rem 0A:    WORD   e_minalloc;                  // Minimum extra paragraphs needed
set "output_buffer=%output_buffer% 00 00"
rem 0C:    WORD   e_maxalloc;                  // Maximum extra paragraphs needed
set "output_buffer=%output_buffer% 00 00"
rem 0E:    WORD   e_ss;                        // Initial (relative) SS value
set "output_buffer=%output_buffer% 00 00"
rem 10:    WORD   e_sp;                        // Initial SP value
set "output_buffer=%output_buffer% 00 00"
rem 12:    WORD   e_csum;                      // Checksum
set "output_buffer=%output_buffer% 00 00"
rem 14:    WORD   e_ip;                        // Initial IP value
set "output_buffer=%output_buffer% 00 00"
rem 16:    WORD   e_cs;                        // Initial (relative) CS value
set "output_buffer=%output_buffer% 00 00"
rem 18:    WORD   e_lfarlc;                    // File address of relocation table
set "output_buffer=%output_buffer% 00 00"
rem 1A:    WORD   e_ovno;                      // Overlay number
set "output_buffer=%output_buffer% 00 00"
rem 1C:    WORD   e_res[4];                    // Reserved words
set "output_buffer=%output_buffer% 00 00 00 00 00 00 00 00"
rem 24:    WORD   e_oemid;                     // OEM identifier (for e_oeminfo)
set "output_buffer=%output_buffer% 00 00"
rem 26:    WORD   e_oeminfo;                   // OEM information; e_oemid specific
set "output_buffer=%output_buffer% 00 00"
rem 28:    WORD   e_res2[10];                  // Reserved words
set "output_buffer=%output_buffer% 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
rem 3C:    LONG   e_lfanew;                    // File address of new exe header
set "output_buffer=%output_buffer% 40 00 00 00"
rem      } IMAGE_DOS_HEADER, *PIMAGE_DOS_HEADER;




::#define IMAGE_FILE_RELOCS_STRIPPED           0x0001  // Relocation info stripped from file.
::#define IMAGE_FILE_EXECUTABLE_IMAGE          0x0002  // File is executable  (i.e. no unresolved externel references).
::#define IMAGE_FILE_LINE_NUMS_STRIPPED        0x0004  // Line nunbers stripped from file.
::#define IMAGE_FILE_LOCAL_SYMS_STRIPPED       0x0008  // Local symbols stripped from file.
::#define IMAGE_FILE_AGGRESIVE_WS_TRIM         0x0010  // Agressively trim working set
::#define IMAGE_FILE_LARGE_ADDRESS_AWARE       0x0020  // App can handle >2gb addresses
::#define IMAGE_FILE_BYTES_REVERSED_LO         0x0080  // Bytes of machine word are reversed.
::#define IMAGE_FILE_32BIT_MACHINE             0x0100  // 32 bit word machine.
::#define IMAGE_FILE_DEBUG_STRIPPED            0x0200  // Debugging info stripped from file in .DBG file
::#define IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP   0x0400  // If Image is on removable media, copy and run from the swap file.
::#define IMAGE_FILE_NET_RUN_FROM_SWAP         0x0800  // If Image is on Net, copy and run from the swap file.
::#define IMAGE_FILE_SYSTEM                    0x1000  // System File.
::#define IMAGE_FILE_DLL                       0x2000  // File is a DLL.
::#define IMAGE_FILE_UP_SYSTEM_ONLY            0x4000  // File should only be run on a UP machine
:: https://docs.microsoft.com/en-us/cpp/build/reference/driver-windows-nt-kernel-mode-driver
:: /DRIVER:UPONLY
::   causes the linker to add the IMAGE_FILE_UP_SYSTEM_ONLY bit to the characteristics in the output header
::   to specify that it is a uniprocessor (UP) driver.
::   The operating system will refuse to load a UP driver on a multiprocessor (MP) system.
::#define IMAGE_FILE_BYTES_REVERSED_HI         0x8000  // Bytes of machine word are reversed.

::#define IMAGE_FILE_MACHINE_UNKNOWN           0
::#define IMAGE_FILE_MACHINE_I386              0x014c  // Intel 386.
::#define IMAGE_FILE_MACHINE_R3000             0x0162  // MIPS little-endian, 0x160 big-endian
::#define IMAGE_FILE_MACHINE_R4000             0x0166  // MIPS little-endian
::#define IMAGE_FILE_MACHINE_R10000            0x0168  // MIPS little-endian
::#define IMAGE_FILE_MACHINE_WCEMIPSV2         0x0169  // MIPS little-endian WCE v2
::#define IMAGE_FILE_MACHINE_ALPHA             0x0184  // Alpha_AXP
::#define IMAGE_FILE_MACHINE_POWERPC           0x01F0  // IBM PowerPC Little-Endian
::#define IMAGE_FILE_MACHINE_SH3               0x01a2  // SH3 little-endian
::#define IMAGE_FILE_MACHINE_SH3E              0x01a4  // SH3E little-endian
::#define IMAGE_FILE_MACHINE_SH4               0x01a6  // SH4 little-endian
::#define IMAGE_FILE_MACHINE_ARM               0x01c0  // ARM Little-Endian
::#define IMAGE_FILE_MACHINE_THUMB             0x01c2
::#define IMAGE_FILE_MACHINE_IA64              0x0200  // Intel 64
::#define IMAGE_FILE_MACHINE_MIPS16            0x0266  // MIPS
::#define IMAGE_FILE_MACHINE_MIPSFPU           0x0366  // MIPS
::#define IMAGE_FILE_MACHINE_MIPSFPU16         0x0466  // MIPS
::#define IMAGE_FILE_MACHINE_ALPHA64           0x0284  // ALPHA64
::#define IMAGE_FILE_MACHINE_AXP64             IMAGE_FILE_MACHINE_ALPHA64

::#define IMAGE_FILE_MACHINE_AMD64             0x8664


setlocal
:loop_cur_datetime
    call "%~dp0datetime\timebias.bat"|| (echo ERROR: datetime\timebias.bat failed>&2& exit /b 1)
    set "timebias_old=%timebias%"
    call "%~dp0datetime\current.bat"|| (echo ERROR: datetime\current.bat failed>&2& exit /b 1)
    call "%~dp0datetime\timebias.bat"|| (echo ERROR: datetime\timebias.bat failed>&2& exit /b 1)
    if not "%timebias_old%" == "%timebias%" goto :loop_cur_datetime

call "%~dp0datetime\cdate.bat" %cur_year% %cur_month% %cur_day% %cur_hour% %cur_minute% %cur_second%|| (echo ERROR: datetime\cdate.bat failed>&2& exit /b 1)
set /a cdate+=(%timebias%)*60
call "%~dp0conversion\int_to_hex4le.bat" %cdate%
endlocal& set "hex_datetime_stamp=%result%"

rem     typedef struct _IMAGE_NT_HEADERS {
rem 00:    DWORD Signature;
set "output_buffer=%output_buffer% 50 45 00 00" & rem IMAGE_NT_SIGNATURE = 50 45 00 00  // PE00
rem 04:    IMAGE_FILE_HEADER FileHeader;
rem        typedef struct _IMAGE_FILE_HEADER {
rem 04:        WORD    Machine;
set "output_buffer=%output_buffer% 4c 01" & rem I386
rem 06:        WORD    NumberOfSections;
set "output_buffer=%output_buffer% 00 00"
rem 08:        DWORD   TimeDateStamp;
set "output_buffer=%output_buffer% %hex_datetime_stamp%"
rem 0C:        DWORD   PointerToSymbolTable;
set "output_buffer=%output_buffer% 00 00 00 00"
rem 10:        DWORD   NumberOfSymbols;
set "output_buffer=%output_buffer% 00 00 00 00"
rem 14:        WORD    SizeOfOptionalHeader;
set "output_buffer=%output_buffer% 00 00"
rem 16:        WORD    Characteristics;
set "output_buffer=%output_buffer% 00 00"
rem        } IMAGE_FILE_HEADER, *PIMAGE_FILE_HEADER;
rem 18:    IMAGE_OPTIONAL_HEADER32 OptionalHeader;
rem    } IMAGE_NT_HEADERS32, *PIMAGE_NT_HEADERS32;



::copy /y /b "%MY_TMP%\bin_4D.tmp"+"%MY_TMP%\bin_5A.tmp"+... out.exe>nul
copy /y /b ^"%MY_TMP%\bin_!output_buffer: =.tmp^"+^"%MY_TMP%\bin_!.tmp^" out.exe>nul

echo off
