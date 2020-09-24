# Auto-connect to DHCP-raspberry in arbitrary wireless network

- This is very simple **bash script** which makes it easy to connect to **raspberry SSH** even in **DHCP** and **arbitrary wireless network**.

- If you use multiple wireless networks, you will have to set up **DHCP** on you **Raspberry Pi** because it is difficult to use a **static IP**, and **SSH** connection is difficult because the IP changes every time. But this program can help you connect automatically by guessing the IP of raspberry pi by **nmap**.

## Dependencies

- `nmap`

## Usage

1. Connect **raspberry pi** to arbitrary wireless network **A** 

2. Connect your computer to use **SSH** connection to network **A** 

3. Now just execute script

`./auto-connect.sh <INTERFACE> <SSH_ID>`

![](https://user-images.githubusercontent.com/16812446/71444997-e8ae0c00-270d-11ea-8f40-c6c7a6961a43.png)
