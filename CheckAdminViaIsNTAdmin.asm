;No offical information on the "IsNtAdmin" API, meaning it might not be reliable, use at your own ristk.
;https://source.winehq.org/WineAPI/IsNTAdmin.html
Format PE Console
include 'win32a.inc'
entry start

section '.data' data readable writable
szIsAdmin db "You Have Admin Rights",0xA, 0
szNotAdmin db "You Do Not Have Admin Rights",0xA, 0

section '.text' code readable writable executable
start:
        invoke IsNTAdmin, 0, 0
        cmp eax, TRUE
        jne IsNotAdmin
IsAdmin:
        invoke printf, szIsAdmin
        invoke ExitProcess, 0
IsNotAdmin:
        invoke printf, szNotAdmin
        invoke ExitProcess, 0


section '.idata' import readable writable
library kernel32, 'kernel32.dll',\
        advpack, 'advpack.dll',\
        msvcrt, 'msvcrt.dll'
import advpack,\
       IsNTAdmin, 'IsNTAdmin'
import msvcrt,\
       printf, 'printf'

include 'api/kernel32.inc'
