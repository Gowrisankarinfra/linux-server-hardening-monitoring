# Linux Server Hardening Checklist (Lab)

Apply changes only after reviewing the OS version, application dependencies, and
maintenance window. Keep out-of-band console access available.

## Access
- [ ] Create named administrator accounts; avoid routine root login.
- [ ] Use SSH public-key authentication and verify a second session before closing
      the current session.
- [ ] Consider disabling password authentication only after key login is verified.
- [ ] Restrict SSH source addresses at the network firewall/security group.
- [ ] Review `/etc/ssh/sshd_config` and validate with `sshd -t` before reload.

## Patching and services
- [ ] Apply security updates in an approved maintenance window.
- [ ] Identify and disable only services confirmed unnecessary.
- [ ] Review listening ports with `ss -tulpn`.
- [ ] Keep time synchronization enabled.

## Firewall
- [ ] Document required inbound and outbound ports.
- [ ] Apply firewall rules in a test VM first.
- [ ] Preserve the active SSH management path to avoid lockout.

## Logging and monitoring
- [ ] Configure log rotation and retention.
- [ ] Monitor disk, memory, CPU, service health, and authentication failures.
- [ ] Protect logs and backups from unauthorized access.
- [ ] Test alert delivery.

## Backups
- [ ] Back up configuration and application data according to policy.
- [ ] Encrypt backups and restrict S3 bucket access.
- [ ] Enable S3 versioning/lifecycle policy where appropriate.
- [ ] Perform a restore test; a successful upload alone is not proof of recoverability.

## Evidence
Record OS version, commands used, before/after results, and test date. Do not publish
real hostnames, IPs, usernames, customer details, or company configurations.
