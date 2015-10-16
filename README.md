ScanDisk All
==========

This program will run CHKDSK on all drives in an unattended manner.
CHKDSK will be done in a two-steps way for safer execution.
The computer will be shutdown after finishing, but can be aborted
by pressing enter.

Supports:
 * NTFS 
 * FAT32 
 * New generation CKHDSK commands (/scan /perf ...) 
 * Special treatment of SYSTEM drive (C: as default). 
   - Includes "sfc /scannow" for check system files integrity. 

Notice that if you system drive is not C:, you MUST change the line: 
  `SET SYSTEM_DRIVE=C:`
