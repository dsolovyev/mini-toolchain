@echo off
setlocal enabledelayedexpansion enableextensions

set "MY_TMP=%TEMP%\bin"
if defined TMP set "MY_TMP=%TMP%\bin"

call "%~dp0bin.bat" || (echo ERROR: "%~dp0bin.bat" failed>&2& exit /b 1)

echo on

rem     typedef struct _IMAGE_DOS_HEADER {     // DOS .EXE header
rem 00:     WORD   e_magic;                    // Magic number
rem     e_magic = IMAGE_DOS_SIGNATURE = 4D 5A  // MZ
set "output_buffer=4D 5A"
rem 02:     WORD   e_cblp;                     // Bytes on last page of file
set "output_buffer=%output_buffer% 00 00"
rem 04:    WORD   e_cp;                        // Pages in file
set "output_buffer=%output_buffer% 00 00"
rem 06:    WORD   e_crlc;                      // Relocations
set "output_buffer=%output_buffer% 00 00"
rem 08:    WORD   e_cparhdr;                   // Size of header in paragraphs
rem     e_cparhdr = 4 (0x40 bytes)
set "output_buffer=%output_buffer% 04 00"
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
set "output_buffer=%output_buffer% 00 00 00 00"
rem      } IMAGE_DOS_HEADER, *PIMAGE_DOS_HEADER;




::copy /y /b "%MY_TMP%\bin_4D.tmp"+"%MY_TMP%\bin_5A.tmp"+... out.exe>nul
copy /y /b ^"%MY_TMP%\bin_!output_buffer: =.tmp^"+^"%MY_TMP%\bin_!.tmp^" out.exe>nul

echo off
