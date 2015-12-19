# VeraCrypt for FreeBSD ports

VeraCrypt is a free disk encryption software by IDRI
(https://www.idrix.fr) and is based on TrueCrypt 7.1a.

This is an experimental port to FreeBSD of VeraCrypt.
It was NOT created and is in no way endorsed by IDRIX.

VeraCrypt adds enhanced security to the algorithms used for system and
partitions encryption making it immune to new developments in
brute-force attacks. VeraCrypt also solves many vulnerabilities and
security issues found in TrueCrypt. The following post describes some
of the enhancements and corrections done:
https://veracrypt.codeplex.com/discussions/569777#PostContent_1313325

Known issues:
- Only command line is support (UI will not compile)
- Compilation issue of Application.cpp (wxStandardPaths) see patch/Application.cpp

Note: to enable Fuse on FreeBSD 10.2 simply add ```fuse_load="YES"``` to ```/boot/loader.conf```
