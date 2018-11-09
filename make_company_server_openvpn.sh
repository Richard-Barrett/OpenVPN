#!/bin/bash
# Created by Richard Barrett
# Date 11/09/2018 Version: 1.0
# ===============================
#       ***Script Notes***
# ===============================
# Script will install OpenVPN
# Script will prepare all files
# Script will prepare all routes
# Script will configure OpenVPN
# ===============================

# ================================================================================================================
#                                                 Documentation 
# ================================================================================================================
# https://blog.ssdnodes.com/blog/tutorial-installing-openvpn-on-ubuntu-16-04/
#
#
#
#
#
#
#
# ================================================================================================================


# OpenVPN Installation
# ====================

# Update and install
# ------------------
sudo apt-get update
sudo apt-get install openvpn easy-rsa


# Utilize Easy RSA Template
# -------------------------
make-cadir ~/openvpn-ca
cd ~/openvpn-ca

# Grab and move company-easy-RSA-template
# -------------------------------------------------
# Note you must configure company-easy-RSA-template
# -------------------------------------------------

sudo cp ~/OpenVPN/company-easy-RSA-template ~/openvpn-ca/easy-rsa

# Source the vars and build the certificate authority
# ---------------------------------------------------
source vars

#NOTE: If you run ./clean-all, I will be doing a rm -rf on /home/user/openvpn-ca/keys
./clean-all
./build-ca

# Create Server Public/Private Keys
# ---------------------------------
./build-key-server company_openvpn

# Build Diffie-Hellman keys
# -------------------------
./build-dh

# Generate an HMAC signature to strengthen the certificate
# --------------------------------------------------------
openvpn --genkey --secret keys/ta.key

# Create Client-Machine Keys
# =================================================================================
#                               ***Notes***
# =================================================================================

# This process will create a single client key and certificate. 
# If you have multiple users, you’ll want to create multiple pairs.
# When running the below command, 
# hit Enter to confirm the variables we set and then leave the password field blank.

# ==================================================================================

source vars
./build-key client_machine

# Configure the OpenVPN server
# ============================
cd ~/openvpn-ca/keys
sudo cp ca.crt ca.key company_opnvpn.crt company_openvpn.key ta.key dh2048.pem /etc/openvpn

# Extract a sample OpenVPN configuration to the default location.
# ---------------------------------------------------------------
gunzip -c /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz | sudo tee /etc/openvpn/server.conf

# 

