chkdsk-all
==========

Windows Batch that runs a ScanDisk of *all drives* in an unattended manner.
The computer will be shutdown after check finish. But can be aborted by pressing enter.
Only double click is required to execute it ;)

Logically, only NTFS and FAT32 is supported.
For Windows 8 and upper, it uses new chkdsk features /scan /perf /forceofflinefix /offlinescanandfix
