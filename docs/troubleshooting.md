# Troubleshooting FAQ

## CDK

### **Signature expired: is now earlier than error : InvalidSignatureException**

This error happens because the system where you execute the CLI is having out-of-sync date time.

If you execute CLI on your host terminal, you should turn on Internet time synchronization in your OS settings.

If you execute CLI in Windows Subsystem Linux (WSL), running this command in an elevated PowerShell terminal:

```powershell
wsl -d docker-desktop -e /sbin/hwclock -s
```