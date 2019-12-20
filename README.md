# NoTimeToWaste

Automated subnet scan for RSSI 


## Requirements 
  - [Masscan](https://github.com/robertdavidgraham/masscan)
  - [Nmap](https://github.com/nmap/nmap)
  - [CrackMapExec](https://github.com/byt3bl33d3r/CrackMapExec)

## Usage

```bash
git clone https://github.com/Syzik/NoTimeToWaste.git
```

```
* OPTIONS : 
  * Mandatory argument : 
    -i inpute file 
  * Optionnal arguments : 
    -r Masscan rate
    -h Display help
```

```bash
./NoTimeToWaste.sh -i ipsubnet -r 50000
```
