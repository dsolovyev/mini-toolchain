setlocal disabledelayedexpansion enableextensions

call "%~dp0fs\init_global_tmp.bat" || (echo ERROR: "%~dp0fs\init_global_tmp.bat" failed>&2& exit /b 1)

call "%~dp0binary\create_template_bytes.bat" || (echo ERROR: "%~dp0binary\create_template_bytes.bat" failed>&2& exit /b 1)

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


:://
::// Directory format.
:://
::
::typedef struct _IMAGE_DATA_DIRECTORY {
::    DWORD   VirtualAddress;
::    DWORD   Size;
::} IMAGE_DATA_DIRECTORY, *PIMAGE_DATA_DIRECTORY;
::
::#define IMAGE_NUMBEROF_DIRECTORY_ENTRIES    16

::// Directory Entries
::
::#define IMAGE_DIRECTORY_ENTRY_EXPORT          0   // Export Directory
::#define IMAGE_DIRECTORY_ENTRY_IMPORT          1   // Import Directory
::#define IMAGE_DIRECTORY_ENTRY_RESOURCE        2   // Resource Directory
::#define IMAGE_DIRECTORY_ENTRY_EXCEPTION       3   // Exception Directory
::#define IMAGE_DIRECTORY_ENTRY_SECURITY        4   // Security Directory
::#define IMAGE_DIRECTORY_ENTRY_BASERELOC       5   // Base Relocation Table
::#define IMAGE_DIRECTORY_ENTRY_DEBUG           6   // Debug Directory
:://      IMAGE_DIRECTORY_ENTRY_COPYRIGHT       7   // (X86 usage)
::#define IMAGE_DIRECTORY_ENTRY_ARCHITECTURE    7   // Architecture Specific Data
::#define IMAGE_DIRECTORY_ENTRY_GLOBALPTR       8   // RVA of GP
::#define IMAGE_DIRECTORY_ENTRY_TLS             9   // TLS Directory
::#define IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG    10   // Load Configuration Directory
::#define IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT   11   // Bound Import Directory in headers
::#define IMAGE_DIRECTORY_ENTRY_IAT            12   // Import Address Table
::#define IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT   13   // Delay Load Import Descriptors
::#define IMAGE_DIRECTORY_ENTRY_COM_DESCRIPTOR 14   // COM Runtime descriptor


::#define IMAGE_NT_OPTIONAL_HDR32_MAGIC      0x10b
::#define IMAGE_NT_OPTIONAL_HDR64_MAGIC      0x20b


setlocal
:loop_cur_datetime
    call "%~dp0datetime\timebias.bat"|| (echo ERROR: datetime\timebias.bat failed>&2& exit /b 1)
    set "timebias_old=%timebias%"
    call "%~dp0datetime\current.bat"|| (echo ERROR: datetime\current.bat failed>&2& exit /b 1)
    call "%~dp0datetime\timebias.bat"|| (echo ERROR: datetime\timebias.bat failed>&2& exit /b 1)
    if not "%timebias_old%" == "%timebias%" goto :loop_cur_datetime

call "%~dp0datetime\cdate.bat" %cur_year% %cur_month% %cur_day% %cur_hour% %cur_minute% %cur_second%|| (echo ERROR: datetime\cdate.bat failed>&2& exit /b 1)
set /a cdate+=timebias*60
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
rem        typedef struct _IMAGE_OPTIONAL_HEADER {
rem            //
rem            // Standard fields.
rem            //

rem 18:        WORD    Magic;
set "output_buffer=%output_buffer% 0b 01" & rem IMAGE_NT_OPTIONAL_HDR32_MAGIC
rem 1A:        BYTE    MajorLinkerVersion;
set "output_buffer=%output_buffer% 00"
rem 1B:        BYTE    MinorLinkerVersion;
set "output_buffer=%output_buffer% 00"
rem 1C:        DWORD   SizeOfCode;
set "output_buffer=%output_buffer% 00 00 00 00"
rem 20:        DWORD   SizeOfInitializedData;
set "output_buffer=%output_buffer% 00 00 00 00"
rem 24:        DWORD   SizeOfUninitializedData;
set "output_buffer=%output_buffer% 00 00 00 00"
rem 28:        DWORD   AddressOfEntryPoint;
set "output_buffer=%output_buffer% 00 00 00 00"
rem 2C:        DWORD   BaseOfCode;
set "output_buffer=%output_buffer% 00 00 00 00"
rem 30:        DWORD   BaseOfData;
set "output_buffer=%output_buffer% 00 00 00 00"

rem            //
rem            // NT additional fields.
rem            //

rem 34:        DWORD   ImageBase;
set "output_buffer=%output_buffer% 00 00 00 00"
rem 38:        DWORD   SectionAlignment;
set "output_buffer=%output_buffer% 00 00 00 00"
rem 3C:        DWORD   FileAlignment;
set "output_buffer=%output_buffer% 00 00 00 00"
rem 40:        WORD    MajorOperatingSystemVersion;
set "output_buffer=%output_buffer% 00 00"
rem 42:        WORD    MinorOperatingSystemVersion;
set "output_buffer=%output_buffer% 00 00"
rem 44:        WORD    MajorImageVersion;
set "output_buffer=%output_buffer% 00 00"
rem 46:        WORD    MinorImageVersion;
set "output_buffer=%output_buffer% 00 00"
rem 48:        WORD    MajorSubsystemVersion;
set "output_buffer=%output_buffer% 00 00"
rem 4A:        WORD    MinorSubsystemVersion;
set "output_buffer=%output_buffer% 00 00"
rem 4C:        DWORD   Win32VersionValue;
set "output_buffer=%output_buffer% 00 00 00 00"
rem 50:        DWORD   SizeOfImage;
set "output_buffer=%output_buffer% 00 00 00 00"
rem 54:        DWORD   SizeOfHeaders;
set "output_buffer=%output_buffer% 00 00 00 00"
rem 58:        DWORD   CheckSum;
set "output_buffer=%output_buffer% 00 00 00 00"
rem 5C:        WORD    Subsystem;
set "output_buffer=%output_buffer% 00 00"
rem 5E:        WORD    DllCharacteristics;
set "output_buffer=%output_buffer% 00 00"
rem 60:        DWORD   SizeOfStackReserve;
set "output_buffer=%output_buffer% 00 00 00 00"
rem 64:        DWORD   SizeOfStackCommit;
set "output_buffer=%output_buffer% 00 00 00 00"
rem 68:        DWORD   SizeOfHeapReserve;
set "output_buffer=%output_buffer% 00 00 00 00"
rem 6C:        DWORD   SizeOfHeapCommit;
set "output_buffer=%output_buffer% 00 00 00 00"
rem 70:        DWORD   LoaderFlags;
set "output_buffer=%output_buffer% 00 00 00 00"
rem 74:        DWORD   NumberOfRvaAndSizes;
set "output_buffer=%output_buffer% 00 00 00 00"
rem 78:        IMAGE_DATA_DIRECTORY DataDirectory[IMAGE_NUMBEROF_DIRECTORY_ENTRIES];
rem 78:                             DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT=0]
set "output_buffer=%output_buffer% 00 00 00 00 00 00 00 00"
rem 80:                             DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT=1]
set "output_buffer=%output_buffer% 00 00 00 00 00 00 00 00"
rem 88:                             DataDirectory[IMAGE_DIRECTORY_ENTRY_RESOURCE=2]
set "output_buffer=%output_buffer% 00 00 00 00 00 00 00 00"
rem 90:                             DataDirectory[IMAGE_DIRECTORY_ENTRY_EXCEPTION=3]
set "output_buffer=%output_buffer% 00 00 00 00 00 00 00 00"
rem 98:                             DataDirectory[IMAGE_DIRECTORY_ENTRY_SECURITY=4]
set "output_buffer=%output_buffer% 00 00 00 00 00 00 00 00"
rem A0:                             DataDirectory[IMAGE_DIRECTORY_ENTRY_BASERELOC=5]
set "output_buffer=%output_buffer% 00 00 00 00 00 00 00 00"
rem A8:                             DataDirectory[IMAGE_DIRECTORY_ENTRY_DEBUG=6]
set "output_buffer=%output_buffer% 00 00 00 00 00 00 00 00"
rem B0:                             DataDirectory[IMAGE_DIRECTORY_ENTRY_COPYRIGHT(x86)||IMAGE_DIRECTORY_ENTRY_ARCHITECTURE=7]
set "output_buffer=%output_buffer% 00 00 00 00 00 00 00 00"
rem B8:                             DataDirectory[IMAGE_DIRECTORY_ENTRY_GLOBALPTR=8]
set "output_buffer=%output_buffer% 00 00 00 00 00 00 00 00"
rem C0:                             DataDirectory[IMAGE_DIRECTORY_ENTRY_TLS=9]
set "output_buffer=%output_buffer% 00 00 00 00 00 00 00 00"
rem C8:                             DataDirectory[IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG=10]
set "output_buffer=%output_buffer% 00 00 00 00 00 00 00 00"
rem D0:                             DataDirectory[IMAGE_DIRECTORY_ENTRY_BOUND_IMPORT=11]
set "output_buffer=%output_buffer% 00 00 00 00 00 00 00 00"
rem D8:                             DataDirectory[IMAGE_DIRECTORY_ENTRY_IAT=12]
set "output_buffer=%output_buffer% 00 00 00 00 00 00 00 00"
rem E0:                             DataDirectory[IMAGE_DIRECTORY_ENTRY_DELAY_IMPORT=13]
set "output_buffer=%output_buffer% 00 00 00 00 00 00 00 00"
rem E8:                             DataDirectory[IMAGE_DIRECTORY_ENTRY_COM_DESCRIPTOR=14]
set "output_buffer=%output_buffer% 00 00 00 00 00 00 00 00"
rem F0:                             DataDirectory[<padding>=15]
set "output_buffer=%output_buffer% 00 00 00 00 00 00 00 00"
rem        } IMAGE_OPTIONAL_HEADER32, *PIMAGE_OPTIONAL_HEADER32;
rem    } IMAGE_NT_HEADERS32, *PIMAGE_NT_HEADERS32;
rem F8:



call "%~dp0binary\output.bat" --create out.exe "%output_buffer%"|| (echo ERROR: "%~dp0binary\output.bat" failed>&2& exit /b 1)

echo off
