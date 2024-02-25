# Network Security Tools Bash Script

## Overview
This Bash script provides various network security tools and functionalities to aid in network scanning, service version detection, traffic analysis, and penetration testing. It encapsulates several common security tasks into functions for ease of use.

## Prerequisites
- [Nmap](https://nmap.org/) - Network exploration tool and security scanner
- [tcpdump](https://www.tcpdump.org/) - Packet analyzer
- [Metasploit Framework](https://www.metasploit.com/) - Penetration testing framework

## Usage
./network_security.sh <function> <target_ip> <target_port>
- <target_port> is specified only when use `capture_password_traffic` `capture_cookies_traffic` functions

## Available Functions
- `scan_network`: Scans hosts on a specific network.
- `scan_ports`: Scans ports on the target host.
- `scan_versions`: Scans version services on the target port.
- `scan_ssh_auth_methods`: Scans SSH to check authentication methods.
- `capture_password_traffic`: Captures password traffic on specific port.
- `capture_cookies_traffic`: Captures cookies traffic on specific port.
- `brute_force_ssh`: Performs brute force attack on SSH.
- `brute_force_postgres`: Performs brute force attack on PostgreSQL.
- `dump_hash_user_postgres`: Dumps hashes of PostgreSQL users.
- `dump_schema_postgres`: Dumps PostgreSQL database schema.
- `postgres_readfile`: Reads files on PostgreSQL server.

## Example
- ./network_security_tool.sh scan_ports 192.168.1.10
- ./network_security_tool.sh capture_cookies_traffic 192.168.1.10 8000

## Note
- Some functions require superuser privileges (`sudo`).
- Ensure you have necessary permissions before using the functions.

## Disclaimer
This tool is intended for educational and testing purposes only. Misuse of this tool for unauthorized access to systems is illegal and unethical