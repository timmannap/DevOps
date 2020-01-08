# :Hardening the Operating System

These are some of the many things that need to be taken care of in the Operating system of the server where the application is going to be run when in Production.

A complete list can be found here.

https://www.stigviewer.com/stig/red_hat_enterprise_linux_7/2017-12-14/

each type of hardening consists of 4 items. The Title, Description, Testing and the Way to Overcome it.

The PDF found consists of some handpicked ones. Below are the ways to over come the findings.

---

## Title

#### Description

#### Testing

#### Solution

----
## The operating system must require authentication upon booting into single-user and maintenance modes.
#### Description
 If the system does not require valid root authentication before it boots into single-user or maintenance mode, anyone who invokes single-user or maintenance mode is granted privileged access to all files on the system. 
#### Check Text 
 Verify the operating system must require authentication upon booting into single-user and maintenance modes.Check that the operating system requires authentication upon booting into single-user mode with the following command:

```
grep -i execstart /usr/lib/systemd/system/rescue.serviceExecStart=-/bin/sh -c "/usr/sbin/sulogin; /usr/bin/systemctl --fail --no-block default"
```

**If "ExecStart" does not have "/usr/sbin/sulogin" as an option, this is a finding.** 

#### Fix Text 
 Configure the operating system to require authentication upon booting into single-user and maintenance modes.Add or modify the "ExecStart" line in "/usr/lib/systemd/system/rescue.service" to include "/usr/sbin/sulogin":ExecStart=-/bin/sh -c "/usr/sbin/sulogin; /usr/bin/systemctl --fail --no-block default" 

---

## The root accounts executable search path must be the vendor default and must contain only absolute paths.
#### Description
 The executable search path (typically the PATH environment variable) contains a list of directories for the shell to search to find executables.  If this path includes the current working directory or other relative paths, executables in these directories may be executed instead of system commands.  This variable is formatted as a colon-separated list of directories.  If there is an empty entry, such as a leading or trailing colon or two consecutive colons, this is interpreted as the current working directory.  Entries starting with a slash (/) are absolute paths.

#### Check Text 
 To view the root user's PATH, log in as the root user, and execute:

```
env | grep PATHOR# echo $PATH
```

This variable is formatted as a colon-separated list of directories. 

- **If there is an empty entry, such as a leading or trailing colon, or two consecutive colons, this is a finding.**
- **If an entry starts with a character other than a slash (/), this is a finding.**
- **If directories beyond those in the vendor's default root path are present. This is a finding.** 

#### Fix Text 
 Edit the root user's local initialization files ~/.profile,~/.bashrc (assuming root shell is bash). Change any found PATH variable settings to the vendor's default path for the root user. Remove any empty path entries or references to relative paths. 

---

## All skeleton files (typically those in /etc/skel) must have mode 0644 or less permissive.
#### Description
 If the skeleton files are not protected, unauthorized personnel could change user startup parameters and possibly jeopardize user files.


#### Check Text ( None )
```
ls -alL /etc/skel
```

#### Fix Text (F-31240r1_fix)
 Change the mode of skeleton files with incorrect mode:# chmod 0644  

---

## NIS/NIS+/yp files must be owned by root, sys, or bin.
#### Description
 NIS/NIS+/yp files are part of the system's identification and authentication processes and are critical to system security.  Failure to give ownership of sensitive files or utilities to root or bin provides the designated owner and unauthorized users with the potential to access sensitive information or change the system configuration which could weaken the system's security posture. 
#### Check Text
 Perform the following to check NIS file ownership:

```
# ls -la /var/yp/*
```

If the file ownership is not root, sys, or bin, this is a finding. 
#### Fix Text
 Change the ownership of NIS/NIS+/yp files to root, sys or bin. Procedure (example):# chown root     

---

## NIS/NIS+/yp files must be group-owned by root, sys, or bin.
#### Description
 NIS/NIS+/yp files are part of the system's identification and authentication processes and are, therefore, critical to system security.  Failure to give ownership of sensitive files or utilities to root or bin provides the designated owner and unauthorized users with the potential to access sensitive information or change the system configuration which could weaken the system's security posture.

#### Check Text
 Perform the following to check NIS file ownership.

```
ls -lRa /usr/lib/netsvc/yp /var/yp
```

If the file group owner is not root, sys, or bin, this is a finding. 
#### Fix Text
 Change the group owner of the NIS files to root, bin, or sys.Procedure:

```
chgrp -R root /usr/lib/netsvc/yp /var/yp 
```



---

## Library files must have mode 0755 or less permissive.
#### Description
 Files from shared library directories are loaded into the address space of processes (including privileged ones) or of the kernel itself at runtime. Restrictive permissions are necessary to protect the integrity of the system. 
#### Check Text ( C-46019r4_chk )
 System-wide shared library files, which are linked to executables during process load time or run time, are stored in the following directories by default: /lib/lib64/usr/lib/usr/lib64Kernel modules, which can be added to the kernel during runtime, are stored in "/lib/modules". All files in these directories should not be group-writable or world-writable. To find shared libraries that are group-writable or world-writable, run the following command for each directory [DIR] which contains shared libraries: $

```
 find -L [DIR] -perm /022 -type f
```

If any of these files (excluding broken symlinks) are group-writable or world-writable, this is a finding. 
#### Fix Text (F-43409r2_fix)
 System-wide shared library files, which are linked to executables during process load time or run time, are stored in the following directories by default: /lib/lib64/usr/lib/usr/lib64If any file in these directories is found to be group-writable or world-writable, correct its permission with the following command: # chmod go-w [FILE] 

---

## All system command files must have mode 0755 or less permissive.
#### Description
 System binaries are executed by privileged users, as well as system services, and restrictive permissions are necessary to ensure execution of these programs cannot be co-opted. 
#### Check Text ( C-46024r2_chk )
 System executables are stored in the following directories by default: /bin/usr/bin/usr/local/bin/sbin/usr/sbin/usr/local/sbinAll files in these directories should not be group-writable or world-writable. To find system executables that are group-writable or world-writable, run the following command for each directory [DIR] which contains system executables: $ 

```
find -L [DIR] -perm /022 -type f
```

If any system executables are found to be group-writable or world-writable, this is a finding. 
#### Fix Text (F-43414r1_fix)
 System executables are stored in the following directories by default: /bin/usr/bin/usr/local/bin/sbin/usr/sbin/usr/local/sbinIf any file in these directories is found to be group-writable or world-writable, correct its permission with the following command: # chmod go-w [FILE] 

---

## The /etc/shadow (or equivalent) file must be owned by root.
#### Description
 The /etc/shadow file contains the list of local system accounts.  It is vital to system security and must be protected from unauthorized modification.  Failure to give ownership of sensitive files or utilities to root provides the designated owner and unauthorized users with the potential to access sensitive information or change the system configuration which could weaken the system's security posture. 
#### Check Text ( C-301r2_chk )
 Check the ownership of the /etc/shadow file.# 

```
ls -lL /etc/shadow
```

If the /etc/shadow file is not owned by root, this is a finding. 
#### Fix Text (F-34673r1_fix)
 Change the ownership of the /etc/shadow file.# chown root /etc/shadow 

---

## The /etc/passwd file must have mode 0644 or less permissive.
#### Description
 If the "/etc/passwd" file is writable by a group-owner or the world the risk of its compromise is increased. The file contains the list of accounts on the system and associated information, and protection of this file is critical for system security. 
#### Check Text ( C-46007r1_chk )
 To check the permissions of "/etc/passwd", run the command: $ 

```
ls -l /etc/passwd
```

If properly configured, the output should indicate the following permissions: "-rw-r--r--" If it does not, this is a finding. 
#### Fix Text (F-43397r1_fix)
 To properly set the permissions of "/etc/passwd", run the command: # chmod 0644 /etc/passwd 

---

## The /etc/shadow (or equivalent) file must have mode 0400.
#### Description
 The /etc/shadow file contains the list of local system accounts.  It is vital to system security and must be protected from unauthorized modification.  The file also contains password hashes which must not be accessible to users other than root. 
#### Check Text ( C-52987r1_chk )
 Check the mode of the /etc/shadow file.#

```
 ls -lL /etc/shadow
```

If the /etc/shadow file has a mode more permissive than 0400, this is a finding. 
#### Fix Text (F-55169r1_fix)
 Change the mode of the /etc/shadow (or equivalent) file.# chmod 0400 /etc/shadow 

---

## The system and user default umask must be 077.
#### Description
 The umask controls the default access mode assigned to newly created files.  An umask of 077 limits new files to mode 700 or less permissive.  Although umask can be represented as a 4-digit number, the first digit representing special access modes is typically ignored or required to be 0.  This requirement applies to the globally configured system defaults and the user defaults for each account on the system. 
#### Check Text ( C-28907r3_chk )
 NOTE: The following commands must be run in the BASH shell.Check global configuration:# find /etc -type f | xargs grep -i umask		Check local initialization files:#

```
 cut -d: -f6 /etc/passwd | xargs -n1 -iHOMEDIR sh -c "grep umask HOMEDIR/.*"
```

If the system and user default umask is not 077, this a finding.Note: If the default umask is 000 or allows for the creation of world writable files this becomes a CAT I finding.. 
#### Fix Text (F-25929r2_fix)
 Edit the /etc/default/login file for Solaris. Set the variable UMASK=077.Edit local and global initialization files containing "umask" and change them to use "077". 

---

## Auditing must be implemented.

### Description

Without auditing, individual system accesses cannot be tracked and malicious activity
cannot be detected and traced back to an individual account.

### Check

Determine if auditing is enabled.# 

```
ps -ef |grep auditd
```

 If the auditd process is not found,
this is a finding.

---

## System audit logs must be owned by root.
#### Description
 Failure to give ownership of system audit log files to root provides the designated owner and unauthorized users with the potential to access sensitive information. 
#### Check Text ( C-28369r1_chk )
 Perform the following to determine the location of audit logs and then check the ownership.# 

```
more /etc/security/audit_control
ls -lLa 
```

If any audit log file is not owned by root, this is a finding. 
#### Fix Text (F-966r2_fix)
 Change the ownership of the audit log file(s).Procedure:# chown root  

---

## Audit log files must have mode 0640 or less permissive.
#### Description
 If users can write to audit logs, audit trails can be modified or destroyed. 
#### Check Text ( C-46055r1_chk )
 Run the following command to check the mode of the system audit logs: 

```
grep "^log_file" /etc/audit/auditd.conf|sed s/^[^\/]*//|xargs stat -c %a:%n
```

Audit logs must be mode 0640 or less permissive. If any are more permissive, this is a finding. 
#### Fix Text (F-43445r1_fix)
 Change the mode of the audit log files with the following command: # chmod 0640 [audit_file] 

---

## All system command files must be owned by root.
### Description
 System binaries are executed by privileged users as well as system services, and restrictive permissions are necessary to ensure that their execution of these programs cannot be co-opted. 
### Check Text ( C-46027r1_chk )
 System executables are stored in the following directories by default: /bin/usr/bin/usr/local/bin/sbin/usr/sbin/usr/local/sbinAll files in these directories should not be group-writable or world-writable. To find system executables that are not owned by "root", run the following command for each directory [DIR] which contains system executables: $ 

```
find -L [DIR] \! -user root
```

If any system executables are found to not be owned by root, this is a finding. 
### Fix Text (F-43417r1_fix)
 System executables are stored in the following directories by default: /bin/usr/bin/usr/local/bin/sbin/usr/sbin/usr/local/sbinIf any file [FILE] in these directories is found to be owned by a user other than root, correct its ownership with the following command: # chown root [FILE] 

---

## The ftpusers file must exist.
### Description
 The ftpusers file contains a list of accounts not allowed to use FTP to transfer files. If this file does not exist, then unauthorized accounts can utilize FTP. 
### Check Text ( C-51761r1_chk )
 Check for the existence of the ftpusers file.Procedure:For gssftp:# 

```
ls -l /etc/ftpusers
```

For vsftp:# 

```
ls -l /etc/vsftpd.ftpusers
```

or# 

```
ls -l /etc/vsftpd/ftpusers
```

If the appropriate ftpusers file for the running FTP service does not exist, this is a finding. 
### Fix Text (F-53533r1_fix)
 Create an ftpusers file appropriate for the running FTP service.For gssftp:Create an /etc/ftpusers file containing a list of accounts not authorized for FTP.For vsftp:Create an /etc/vsftpd.ftpusers or /etc/vsftpd/ftpusers (as appropriate) file containing a list of accounts not authorized for FTP. 

---

## The Network Information System (NIS) protocol must not be used.
### Description
 Due to numerous security vulnerabilities existing within NIS, it must not be used.  Possible alternative directory services are NIS+ and LDAP. 
### Check Text ( C-851r2_chk )
 Perform the following to determine if NIS is active on the system.# 

```
ps -ef | egrep '(ypbind|ypserv)'
```

If NIS is found active on the system, this is a finding. 
### Fix Text (F-1021r2_fix)
 Disable the use of NIS.  Possible replacements are NIS+ and LDAP. 

---

## The nosuid option must be enabled on all Network File System (NFS) client mounts.
### Description
 Enabling the nosuid mount option prevents the system from granting owner or group-owner privileges to programs with the suid or sgid bit set.  If the system does not restrict this access, users with unprivileged access to the local system may be able to acquire privileged access by executing suid or sgid files located on the mounted NFS file system. 
### Check Text ( C-52625r1_chk )
 Check the system for NFS mounts not using the "nosuid" option.Procedure:# 

```
mount -v | grep " type nfs " | egrep -v "nosuid"
```

If the mounted file systems do not have the "nosuid" option, this is a finding. 
### Fix Text (F-54757r1_fix)
 Edit "/etc/fstab" and add the "nosuid" option for all NFS file systems. Remount the NFS file systems to make the change take effect. 

---

## Access to the cron utility must be controlled using the cron.allow and/or cron.deny file(s).
### Description
 The cron facility allows users to execute recurring jobs on a regular and unattended basis. The cron.allow file designates accounts allowed to enter and execute jobs using the cron facility. If the cron.allow file is not present, users listed in the cron.deny file are not allowed to use the cron facility. Improper configuration of cron may open the facility up for abuse by system intruders and malicious users. 
### Check Text ( C-52811r2_chk )
 This check is not applicable if only the root user is permitted to use cron.Check for the existence of the cron.allow and cron.deny files.# 

```
ls -lL /etc/cron.allow
```

```
ls -lL /etc/cron.deny
```

If neither file exists, this is a finding. 
### Fix Text (F-54993r2_fix)
 Create /etc/cron.allow and/or /etc/cron.deny with appropriate content and reboot the system to ensure no lingering cron jobs are processed. 

---

## The cron.allow file must have mode 0600 or less permissive.
### Description
 A cron.allow file that is readable and/or writable by other than root could allow potential intruders and malicious users to use the file contents to help discern information, such as who is allowed to execute cron programs, which could be harmful to overall system and network security. 
### Check Text ( C-28459r1_chk )
 Check mode of the cron.allow file.Procedure:#

```
 ls -lL /etc/cron.d/cron.allow
```

If either file has a mode more permissive than 0600, this is a finding. 
### Fix Text (F-24563r1_fix)
 Change the mode of the cron.allow file to 0600.Procedure:# 

```
chmod 0600 /etc/cron.d/cron.allow
```

 

---

## Cron and crontab directories must be owned by root or bin.
### Description
 Incorrect ownership of the cron or crontab directories could permit unauthorized users the ability to alter cron jobs and run automated jobs as privileged users.  Failure to give ownership of cron or crontab directories to root or to bin provides the designated owner and unauthorized users with the potential to access sensitive information or change the system configuration which could weaken the system's security posture. 
### Check Text ( C-52725r3_chk )
 Check the owner of the crontab directories.Procedure:# 

```
ls -ld /var/spool/cron
ls -ld /etc/cron.d /etc/crontab /etc/cron.daily /etc/cron.hourly /etc/cron.monthly /etc/cron.weekly
```

or

```
ls -ld /etc/cron*|grep -v deny
```

If the owner of any of the crontab directories is not root or bin, this is a finding. 
### Fix Text (F-54891r2_fix)
 Change the mode of the crontab directories.# chown root  

---

## Cron and crontab directories must be group-owned by root, sys, or bin.
### Description
 To protect the integrity of scheduled system jobs and to prevent malicious modification to these jobs, crontab files must be secured.  Failure to give group-ownership of cron or crontab directories to a system group provides the designated group and unauthorized users with the potential to access sensitive information or change the system configuration which could weaken the system's security posture. 
### Check Text ( C-28487r1_chk )
 Check the group owner of the crontab directories.Procedure:

```
ls -ld /var/spool/cron/crontabs
```

If the directory is not group-owned by root, sys, or bin, this is a finding. 
### Fix Text (F-24590r1_fix)
 Change the group owner of the crontab directories to root, sys, or bin.Procedure:# chgrp root /var/spool/cron/crontabs 

---

## Access to the at utility must be controlled via the at.allow and/or at.deny file(s).
### Description
 The at facility selectively allows users to execute jobs at deferred times.  It is usually used for one-time jobs. The at.allow file selectively allows access to the at facility.  If there is no at.allow file, there is no ready documentation of who is allowed to submit at jobs. 
### Check Text ( C-28530r1_chk )
 Check for the existence of at.allow and at.deny files.

```
ls -lL /etc/cron.d/at.allow
ls -lL /etc/cron.d/at.deny
```

If neither file exists, this is a finding. 
### Fix Text (F-11346r2_fix)
 Create at.allow and/or at.deny files containing appropriate lists of users to be allowed or denied access to the "at" daemon.    

---

## The snmpd.conf file must have mode 0600 or less permissive.
### Description
 The snmpd.conf file contains authenticators and must be protected from unauthorized access and modification. 
### Check Text ( None )
 None 
### Fix Text (F-31997r1_fix)
 Change the mode of the SNMP daemon configuration file to 0600. Procedure:# chmod 0600  

---

## The Samba Web Administration Tool (SWAT) must be restricted to the local host or require SSL.
### Description
 SWAT is a tool used to configure Samba.  It modifies Samba configuration, which can impact system security, and must be protected from unauthorized access.  SWAT authentication may involve the root password, which must be protected by encryption when traversing the network.

Restricting access to the local host allows for the use of SSH TCP forwarding, if configured, or administration by a web browser on the local system. 
### Check Text ( C-43389r1_chk )
 SWAT is a tool for configuring Samba and should only be found on a system with a requirement for Samba. If SWAT is used, it must be utilized with SSH to ensure a secure connection between the client and the server.Procedure:

```
# grep -H "bin/swat" /etc/xinetd.d/*|cut -d: -f1 |xargs grep "only_from"
```

If the value of the "only_from" line in the "xinetd.d" file which starts with "/usr/sbin/swat" does not contain "localhost" or the equivalent, this is a finding. 
### Fix Text (F-39472r1_fix)
 Disable SWAT or require that SWAT is only accessed via SSH.Procedure:If SWAT is required, but not at all times, disable it when it is not needed.Modify the /etc/xinetd.d file for "swat" to contain a "disable = yes" line.To access using SSH:Follow vendor configuration documentation to create an stunnel for SWAT. 

---

## The system must not have special privilege accounts, such as shutdown and halt.
### Description
 If special privilege accounts are compromised, the accounts could provide privileges to execute malicious commands on a system. 
### Check Text ( C-51635r1_chk )
 Perform the following to check for unnecessary privileged accounts:# 

```
grep "^shutdown" /etc/passwd
grep "^halt" /etc/passwd
grep "^reboot" /etc/passwd
```

If any unnecessary privileged accounts exist this is a finding. 
### Fix Text (F-53347r1_fix)
 Remove any special privilege accounts, such as shutdown and halt, from the /etc/passwd and /etc/shadow files using the "userdel" or "system-config-users" commands. 

---

## The SSH daemon must be configured to use only the SSHv2 protocol.
### Description
 SSH protocol version 1 suffers from design flaws that result in security vulnerabilities and should not be used. 
### Check Text ( C-46165r1_chk )
 To check which SSH protocol version is allowed, run the following command: 

```
grep Protocol /etc/ssh/sshd_config
```

If configured properly, output should be Protocol 2If it is not, this is a finding. 
### Fix Text (F-43555r1_fix)
 Only SSH protocol version 2 connections should be permitted. The default setting in "/etc/ssh/sshd_config" is correct, and can be verified by ensuring that the following line appears: Protocol 2 

---

## The system must not run Samba unless needed.
### Description
 Samba is a tool used for the sharing of files and printers between Windows and UNIX operating systems.  It provides access to sensitive files and, therefore, poses a security risk if compromised. 
### Check Text ( C-37082r1_chk )
 Check the system for a running Samba server.Procedure:#

```
 ps -ef |grep smbd
```

If the Samba server is running, ask the SA if the Samba server is operationally required. If it is not, this is a finding. 
### Fix Text (F-32354r1_fix)
 If there is no functional need for Samba and the daemon is running, disable the daemon by killing the process ID as noted from the output of ps -ef |grep smbd. The samba package should also be removed or not installed if there is no functional requirement.Procedure:rpm -qa |grep sambaThis will show whether "samba" or "samba3x" is installed. To remove:rpm --erase sambaorrpm --erase samba3x 

---

## The "at"  directory must be owned by root, bin, or sys.
### Description
 If the owner of the "at" directory is not root, bin, or sys, unauthorized users could be allowed to view or edit files containing sensitive information within the directory. 
### Check Text ( C-39270r1_chk )
 Check the ownership of the "at" directory.Procedure:# 

```
ls -ld /var/spool/cron/at
```

jobs If the directory is not owned by root, sys, or bin, this is a finding. 
### Fix Text (F-34045r1_fix)
 Change the owner of the "at" directory to root, bin, or sys.Procedure:# chown root /var/spool/cron/atjobs 

---

## The at.allow file must be owned by root, bin, or sys.
### Description
 If the owner of the at.allow file is not set to root, bin, or sys, unauthorized users could be allowed to view or edit sensitive information contained within the file. 
### Check Text ( C-28552r1_chk )
```
ls -lL /etc/cron.d/at.allow
```

If the at.allow file is not owned by root, sys, or bin,  this is a finding. 

### Fix Text (F-24640r1_fix)
 Change the owner of the at.allow file.# chown root /etc/cron.d/at.allow 

---

## The at.deny file must be owned by root, bin, or sys.
### Description
 If the owner of the at.deny file is not set to root, bin, or sys, unauthorized users could be allowed to view or edit sensitive information contained within the file. 
### Check Text ( C-52851r1_chk )
```
ls -lL /etc/at.deny
```

If the at.deny file is not owned by root, sys, or bin, this is a finding. 

### Fix Text (F-55031r1_fix)
 Change the owner of the at.deny file.# chown root /etc/at.deny 

---

## The rexec daemon must not be running.
### Description
 The rexecd process provides a typically unencrypted, host-authenticated remote access service.  SSH should be used in place of this service. 
### Check Text ( C-36115r1_chk )
```
grep disable /etc/xinetd.d/rexec
```

If the service file exists and is not disabled, this is a finding. 

### Fix Text (F-31361r1_fix)
  Edit /etc/xinetd.d/rexec and set "disable=yes" 

---

## The system must log successful and unsuccessful access to the root account.
### Description
 If successful and unsuccessful logins and logouts are not monitored or recorded, access attempts cannot be tracked.  Without this logging, it may be impossible to track unauthorized access to the system. 
### Check Text ( C-28084r1_chk )
 Check the following log files to determine if access to the root account is being logged.  Try to su - and enter an incorrect password.# 

```
more /var/adm/sulog
```

If root login accounts are not being logged, this is a finding. 
### Fix Text (F-11241r2_fix)
 Troubleshoot the system logging configuration to provide for logging of root account login attempts. 

---

## All skeleton files and directories (typically in /etc/skel) must be owned by root or bin.
### Description
 If the skeleton files are not protected, unauthorized personnel could change user startup parameters and possibly jeopardize user files.  Failure to give ownership of sensitive files or utilities to root or bin provides the designated owner and unauthorized users with the potential to access sensitive information or change the system configuration which could weaken the system's security posture. 
### Check Text ( C-37238r1_chk )
 Check skeleton files ownership.Procedure:# 

```
ls -l /etc/security/.profile /etc/security/mkuser.sys
```

If a skeleton file is not owned by root or bin, this is a finding. 
### Fix Text (F-32452r1_fix)
 Change the ownership of skeleton files with incorrect mode.# chown root /etc/security/.profile /etc/security/mkuser.sys 

---

## The system must implement non-executable program stacks.
### Description
 A common type of exploit is the stack buffer overflow. An application receives, from an attacker, more data than it is prepared for and stores this information on its stack, writing beyond the space reserved for it. This can be designed to cause execution of the data written on the stack. One mechanism to mitigate this vulnerability is for the system to not allow the execution of instructions in sections of memory identified as part of the stack. 
### Check Text ( C-50461r2_chk )
 Determine the OS version you are currently securing.# 

```
uname –v
```

If the OS version is 11.3 or newer, this check applies to all zones and relies on the "sxadm" command. Determine if the system implements non-executable program stacks.# 

```
sxadm status -p nxstack | cut -d: -f2enabled (all)
```

If the command output is not "enabled (all)", this is a finding.For Solaris 11, 11.1, and 11.2, this check applies to the global zone only and the "/etc/system" file is inspected. Determine the zone that you are currently securing.# 

```
zonename
```

If the command output is "global", determine if the system implements non-executable program stacks. # 

```
grep noexec_user_stack /etc/system
```

If the noexec_user_stack is not set to 1, this is a finding. 
### Fix Text (F-51637r2_fix)
 The root role is required.Determine the OS version you are currently securing.# uname –vIf the OS version is 11.3 or newer, enable non-executable program stacks using the "sxadm" command.# pfexec sxadm enable nxstackFor Solaris 11, 11.1, and 11.2, this action applies to the global zone only and the "/etc/system" file is updated. Determine the zone that you are currently securing.# zonenameIf the command output is "global", modify the "/etc/system" file.# pfedit /etc/system add the line:set noexec_user_stack=1Solaris 11, 11.1, and 11.2 systems will need to be restarted for the setting to take effect. 

---

## Unencrypted FTP must not be used on the system.
### Description
 FTP is typically unencrypted and presents confidentiality and integrity risks. FTP may be protected by encryption in certain cases, such as when used in a Kerberos environment. SFTP and FTPS are encrypted alternatives to FTP. 
### Check Text ( C-43193r2_chk )
 Perform the following to determine if unencrypted FTP is enabled:# 

```
chkconfig --list pure-ftpd
chkconfig --list gssftp
chkconfig --list vsftpd
```

If any of these services are found, ask the SA if these services are encrypted.If they are not, this is a finding. 
### Fix Text (F-39254r2_fix)
 Disable the FTP daemons.Procedure:# chkconfig pure-ftpd off# chkconfig gssftp off# chkconfig vsftpd off 

---

## All FTP users must have a default umask of 077.
### Description
 The umask controls the default access mode assigned to newly created files. An umask of 077 limits new files to mode 700 or less permissive. Although umask is stored as a 4-digit number, the first digit representing special access modes is typically ignored or required to be zero (0). 
### Check Text ( C-51867r2_chk )
 Check the umask setting for FTP users.Procedure:For gssftp:Assuming an anonymous ftp user has been defined with no user initialization script invoked to change the umask# 

```
ftp localhostName: (localhost:root): anonymousPassword: anythingftp>umask
```

If the umask value returned is not 077, this is a finding.or:# 

```
grep "server_args" /etc/xinetd.d/gssftp
```

The default umask for FTP is "023" if the server _args entry does not contain "-u 077" this is a finding.For vsftp:# 

```
grep "_mask" /etc/vsftpd/vsftpd.conf
```

The default "local_umask" setting is 077. If this has been changed, or the "anon_umask" setting is not 077, this is a finding. 
### Fix Text (F-53701r1_fix)
 Edit the initialization files for the ftp user and set the umask to 077.Procedure:For gssftp:Modify the /etc/xinetd.d/gssftp file adding "-u 077" to the server_args entry.For vsftp:Modify the "/etc/vsftpd/vsftpd.conf" setting "local_umask" and "anon_umask" to 077. 

---

## X Window System connections that are not required must be disabled.
### Description
 If unauthorized clients are permitted access to the X server, a user's X session may be compromised. 
### Check Text ( C-7981r2_chk )
 Determine if the X Window system is running.Procedure:# 

```
ps -ef |grep X
```

Ask the SA if the X Window system is an operational requirement. If it is not, this is a finding. 
### Fix Text (F-11277r2_fix)
 Disable the X Windows server on the system. 

---

## The system access control program must be configured to grant or deny system access to specific hosts and services.
### Description
 If the systems access control program is not configured with appropriate rules for allowing and denying access to system network resources, services may be accessible to unauthorized hosts. 
### Check Text ( C-72549r1_chk )
 If the "firewalld" package is not installed, ask the System Administrator (SA) if another firewall application (such as iptables) is installed. If an application firewall is not installed, this is a finding.  Ask the SA to show that the running configuration grants or denies access to specific hosts or services.If "firewalld" is active and is not configured to grant access to specific hosts and "tcpwrappers" is not configured to grant or deny access to specific hosts, this is a finding. 
### Fix Text (F-78669r1_fix)
 If "firewalld" is installed and active on the system, configure rules for allowing specific services and hosts. If "tcpwrappers" is installed, configure the "/etc/hosts.allow" and "/etc/hosts.deny" to allow or deny access to specific hosts. 

---

41---

https://github.com/ComplianceAsCode/content

