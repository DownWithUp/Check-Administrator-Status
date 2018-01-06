format PE console
include 'win32a.inc' ;Basic Stuff
entry start

section '.data' data readable writable
;Consts from MSDN
SECURITY_NT_AUTHORITY        =  5
SECURITY_BUILTIN_DOMAIN_RID  =  0x00000020
DOMAIN_ALIAS_RID_ADMINS      =  0x00000220
 
NtAuthority db  0 , 0 , 0 , 0 , 0 , SECURITY_NT_AUTHORITY
 
pSidAdmin dd ?
pbAdmin dd ?
szIsAdmin db "You Have Admin Rights",0xA, 0
szNotAdmin db "You Do Not Have Admin Rights",0xA, 0

section '.text' code readable writable executable

start:
        invoke AllocateAndInitializeSid, NtAuthority, 2, SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS, 0, 0, 0, 0, 0, 0, pSidAdmin
        invoke CheckTokenMembership, 0, [pSidAdmin], pbAdmin
        mov eax , [pbAdmin]
        ;If eax = 1, program has admin rights
        cmp eax, 1
        jne isNotAdmin

isAdmin:
        invoke printf, szIsAdmin
        invoke ExitProcess, 0

isNotAdmin:
        invoke printf, szNotAdmin
        invoke ExitProcess, 0


section '.idata' import readable writable
library kernel32, 'kernel32.dll',\
        msvcrt, 'msvcrt',\
        advapi32, 'advapi32.dll'
import msvcrt,\
       printf,'printf'
import advapi32,\
       CheckTokenMembership, 'CheckTokenMembership',\
       AllocateAndInitializeSid, 'AllocateAndInitializeSid'
include 'api/kernel32.inc'
